


# API:
There are two objects in this library
`Tasks` and `Nodes`.


Tasks are like glorified functions.


Nodes can hold tasks, and control the flow of functions better. Nodes can also hold other Nodes! When this happens, it becomes a Tree.


```lua
-- Require the folder itself- lua will automatically run `init.lua`.
local BT = require("path.to.BehaviourTree.init")
```

# Tasks

Tasks are a collection of functions, that take the following form:

(Note that the table fields `start`, `finish`, and `name` are optional.)
```lua
local Example = BT.Task("example") -- Name is `example`.
-- Note that names are optional for Tasks and Nodes.



function Example:start(obj, dt)
    -- Called when the Task starts
    print("example started, with obj: ", obj)
end



function Example:update(obj, dt)
    -- Called whilst the task is running
    print("running with obj: ", obj)

    return "n" -- Return type is important, see next section.
end




function Example:finish(obj, dt)
    -- Called finally when the task stops running
    print("example task stopped!")
end



```
The most confusing thing about tasks is the return functionality.
What value the `update` function returns will determine what will happen to the tree on the next step.


Here are the returns the update function can use:
```lua
return "r" 
-- The tree will resume running the same next frame


return "n"
-- The tree will go onto the next task next frame
-- (see Node paths for explanation)


return "k"
-- The tree will kill it's current state (reset itself fully)
```
If the Task does not return one of these special return values, and error will be raised.


### Getting runtime of a task:

To see how long a task has been running on an object for, use
```lua
task:runtime( obj ) -- Returns how long it's been running on this object for!
```
This is useful for ensuring that tasks run for X amount of time.
For example:
```lua

local myTask = BT.Task("mytask")


function myTask:update(task, obj, dt)
    if task:runtime(obj) > 5 then -- (time in seconds)
        print("I ran out of gas.")
        return "n" -- Will move onto next task
    end

    print("Hey, I'm running!! cool")
    return "r"
end

```

# Nodes

Nodes are the backbone of this library.

To construct:
```lua

local Node = BT.Node("name") -- Node with name `name`

```
The core of a Node is it's `choose` function.

The `choose` function determines what path will be ran. (A path is just a simple array of tasks.) 

Example:

```lua
local myNode = BT.Node() -- A node with no name


function myNode:choose(node, obj)
    if obj.health < 50 then
        return "angry"
    else
        return "normal"
    end
end



-- Now, creation of "behaviour paths":

myNode.normal = {
    walk, -- `walk` and `eat` are task objects
    eat
}


myNode.angry = {
    run_around,-- These are also task objects
    attack 
}


```

In this example, if the object's health is below 50, the Node runs the `angry` path, which runs the tasks `run_around` and `attack`.

Conversely, if the object's health is above 50, the Node runs the `normal` path, which runs the tasks `walk_around` and `eat`.


NOTE:
The second tasks in both paths (`eat` and `attack`) will only be ran if the first tasks (`run_around` and `walk`) return an "n" return code, telling the tree to move onto the next Task in the path.
If the Tasks return "k" instead, for example, the second Tasks will never be ran, as the tree will just do a full reset and run the `choose` function again.


#### Running objects:

To run an object under a behaviourTree, simply do
```lua
Node:update( object, dt )
```
the object will be ran under the tree `Node` without any side effects. You can run multiple objects under the same tree at the same time, no problem.




## Node callbacks
### **UNTESTED / WORK IN PROGRESS AS OF 22/11/2020**

```lua

Node:on("damage",
    function(node, ent)
        return "scared" -- Changes to `scared` path
    end
)

Node:call("damage", ent) -- Callback!
```


# Extra questions

#### *What happens when a task returns "n" and it is the last in the path?*
This will cause the Node to invoke :next() on it's parent. If that Node has no parent, then it will just invoke a full reset on itself.


#### What are names for?
Names offer a shorthand for putting Tasks and Nodes in paths.

Example:
```lua
local t = BT.Task("q")

function t:update(obj, dt)
        print("task q ran!")
        return "n"
end




local N = BT.Node()

function N:choose(node, obj)
    return "main"
end


N.main = {
    "q", -- This "q" here gets transformed into the Task above.
    "q", 
    "q" -- Note that this kind of thing works for Nodes also
}

```
#### Why don't Nodes have `start` and `finish` callbacks?
If you think about it, `node:choose(obj)` pretty much **is** a starting callback. The reason Nodes don't have ending callbacks is because they can be implemented easily with Tasks anyway




