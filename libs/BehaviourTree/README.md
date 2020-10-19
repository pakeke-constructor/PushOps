
# BehaviourTree

Note: I made this library in an afternoon and it has hardly been tested, so take care!!!!

Much of the API is inspired off of https://github.com/tanema/behaviourtree.lua


# Usage:

There are 2 objects in the BehaviourTree module.

`Nodes`, and `Tasks`. Nodes hold Tasks. Nodes can also hold other Nodes. This is how a tree is made!
Think of a Task like a glorified function.
Think of a Node like a Task that has many steps, and keeps state across 



# Tasks

### Task creation:
The main bit of a task is it's `run` method.

`run` takes `(task, object, dt)` as its arguments, and is called every frame whilst the task is running.

You must specify how the `run` method ends, to tell the Tree where to move to next. More on this in the next section, though.

```lua
local BT = require("path.BehaviourTree")


local obj = <...> -- some user defined object.



-- A task
local task1 = BT.Task({
    name = "task1", -- must have a name

     -- OPTIONAL: Called when the task starts running
    start = function( task, obj, dt ) end,


    -- `run` is called every frame whilst the task is running.
    run = function( task, obj, dt )
        -- NOTE: `task` is a reference to `task1`.
        
        task:next() -- Next frame, the next task will be ran. 
                    -- Read more about this below.
    end


    -- OPTIONAL: Called when the task finishes (stops running)
    finish = function( task, obj, dt ) end
    -- Note that calling task:resume() or anything here won't do anything.
})




-- Alternative way to define Tasks:
local task2 = BT.Task("task2")

-- This works fine!
function task2.run( task, obj, dt )
    if math.random() < 0.5 then
        task:resume()
    else
        task:next()
    end
end
```


### Task signals:
As you saw in the above example, we called `task:next()` to tell the Tree to go to the next task the next frame. I call this a "Task signal".

You MUST call a signal in every `run` function in a task, to let the Tree know where to go

Here are all the ones you can use:
```lua
task:resume() --> resumes same task next frame

task:next()  -->  quits the task next frame, runs next one (ordered by :add() order.)

task:reset() --> goes to the starting task

task:to( task_name ) --> quits the task next frame, goes to task named `task_name`.
            -- (There must be a task called `task_name` in the current Node, else
            -- an error will be raised.)
```
You must call one of these when the function ends, or the tree won't know where to go!
(And an error will be thrown)


### OPTIONAL Task functions: (not signals)
```lua
task:overtime( 5 ) -- returns true if this task has been running for over 5 seconds, false otherwise

task:runtime() -- returns how long the task has been running for.
```


# Nodes

Nodes basically store Tasks.

They are kinda like a big array, with the exception that they keep track of names too.

## Construction
```lua


local my_Node = BT.Node("my_Node")


my_Node:add(task1) -- Add task1 to Node

my_Node:add("task1") -- Same thing.



local otherNode = BT.Node("otherNode")
    :add(task2)
    :add(my_Node) -- We can nest nodes!
```
When `my_Node` is ran as a task, my_Node will just run normally as it would on it's own.

When `my_Node` completes, it passes control back to `otherNode`, which will run
the next task in the tree. In this case, there are no more tasks, so the Tree resets.


## Usage:

Now all you need to do is run the root Node with an object!

`object` will now behave according to `otherNode`'s behaviour Tree.
```lua
function love.update(dt)
    otherNode:run( object, dt )
end
```

# Gotchas:

There are two "Gotchas" with this library.

- Running a behaviour tree from inside itself may not crash the program, but will cause undefined behaviour.

- The Task `finish` function takes the task object as a parameter, but the task object is locked when the finish function runs.



