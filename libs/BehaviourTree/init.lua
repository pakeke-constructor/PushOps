

local Node = { }
local Node_mt = {__index = Node}


local Task = { }
local Task_mt = {__index = Task}


local Proxy = { }
local Tasks_and_Nodes = { }
setmetatable(Tasks_and_Nodes, {
    __newindex = function(t,k,v)
        if t[k] then
            error("Name `".. k .."` is already in use!")
        end
        Proxy[k]=v
    end,
    __index = Proxy
})


-- For when we want user to not be able to access task callbacks
local DUMB_FN = function()end
local DUMB_TABLE = setmetatable({},{__index = function() return DUMB_FN end})


local Time_mt = {
__index = function()
    return 0 --> every task time starts off at 0
end,
__mode = "k" -- weak keys avoid mem leak
}


--[[
Planning :::

Everything is comprised of `tasks`.

Tasks are a really good way to keep state across iterations of the BehaviourTree.
Each time a task ends,
you must call a ending function to signify what to do with the tree.


task_fn --> function( t, entity, dt ) <<<<<>>>>>> end

t:reset() --> resets current Node hierachy

t:resume() --> resumes same task next frame

t:next()  -->  quits the task next frame, runs next one

t:to( task_name ) --> quits the task next frame, goes to task named `task_name`.




`Nodes` are the tree structure.
These are what tasks are stored in

]]


local function newTask( task )
    --[[
        table ==> {

            name = name,

            start = function ( t,  ent, dt ), --callback for start of task

            run = function ( t, ent, dt ),   -- callback for when task is ran

            finish = function ( t, ent, dt )  -- callback for when task finishes

        }
    ]]
    if type(task) == "string" then
        task = { name = task }
    end

    Tasks_and_Nodes[task.name] = task

    assert(type(task.name) == "string", "Task( name, func ) requires a name as string, and a function.")

    task.node = nil -- The node this task is bound to

    task.time_runnings = setmetatable({}, Time_mt)
    -- The time spent running for each entity. {ent -> number}
    -- this is done this way so we don't have to copy Tasks. Its bad, I know, but it works


    -- Both these fields are temporary fields in the Task object, that don't persist across calls to :run.

    task.___state = false -- State of task end call. (for safety purposes. If _state is not set, raise an error)
    task.___ent = false -- current ent this task is running

    task.___finishing = false -- true if the task is just about to finish

    return setmetatable(task, Task_mt)
end


local task_err =
[[
Task function did not close correctly.
Ensure to close task functions ( function( t, ent, dt ) ) with
Any one of the below signature calls:

t:reset() --> resets current Node task hierachy
t:resume() --> resumes same task next frame
t:next()  -->  quits the task next frame, runs next one
t:random() --> goes to a random task in the Node
t:to( task_name ) --> quits the task next frame, goes to task named `task_name`.
]]

local dt_err = "Not given `dt` for Node:run( entity, dt )!"


function Task:reset()
    self.node.current = 1
    self.___state = true
    self:_finish()
end

function Task.start()
    -- USER DEFINED
end

function Task.finish()
    -- USER DEFINED
end


function Task:to( str )
    self.___state = true
    self.node.current = self.node.tasks[str]
    if not self.node.current then
        error("Attempt to move to unregistered Task. Ensure the task specified is in the current Node!")
    end
    self:_finish()
end



function Task:resume()
    self.___state = true
end


function Task:next()
    self.node:next() -- let the node handle this
    self.___state = true
    self:_finish()
end


function Task:overtime(time_limit) --> returns true if time is over time limit
    return (self.time_runnings[self.___ent] > time_limit)
end


function Task:runtime()
    return self.time_runnings[self.___ent]
end



function Task:_run(entity, dt)
    self.___ent = entity
    local time = self.time_runnings[entity]
    if time == 0 then
        self:start(entity)
    end
    self:run(entity, dt)
    if not self.___finishing then
        self.time_runnings[entity] = self.time_runnings[entity] + dt
    end
    self.___ent = nil
    self.___finishing = false
    assert(self.___state, task_err)
    self.___state = false
end


function Task:emerge()
    --[[
        proxies task control to this Task's Node's parent, if current node has a parent.
        If node does not have a viable parent, control remains bound to current node.
        example:

        t:emerge()
            :next() --> goes to next on the parent node! 
    ]]
    local node = self.node
    if node.parent then

    end
end



function Task:_finish()
    self.time_runnings[self.___ent] = nil
    self:finish(DUMB_TABLE, self.___ent)
    self.___finishing = true -- To alert the time increaser not to increase the time.
end






local function newNode( name )
    -- 'sequence' is a table of Nodes or Functions that are called.
    -- the functions in `sequence` are automatically converted to task objects.

    local node = {
        name = name,
        current = 1,
        tasks   = {}, --> task name key points to it's respective index in `ordered_tasks`.
        ordered_tasks = {},
        ordered_tasks_len = 0,
        parent = nil -- parent node of this node (if any)
    }

    Tasks_and_Nodes[node.name] = node

    return setmetatable(node, Node_mt)
end


function Node:next()
    if self.current >= self.ordered_tasks_len then
        if self.parent then
            -- Then this Node has done it's job. ermmmm, what now?
            self:break_to_parent()
        else
            -- It's a root node. So push current back to root
            self.current = 1
        end
    else
        -- Go onto next index
        self.current = self.current + 1
    end
end


function Node:run(ent, dt)
    assert(dt, dt_err)
    if (self.ordered_tasks_len == 0) then
        return
    end
    self.ordered_tasks[self.current]:_run(ent, dt)
end

Node._run = Node.run


function Node:add_task(task)
    assert(getmetatable(task) == Task_mt, "Node:add() requires a task or node object")

    table.insert(self.ordered_tasks, task)

    self.ordered_tasks_len = self.ordered_tasks_len + 1
    self.tasks[task.name] = #self.ordered_tasks

    task.node = self
end


function Node:break_to_parent()
    -- I have no clue in hell what should go here.
    -- Nodes do not have the luxury of having defined breaking behaviour like tasks.

    -- How should the user decide state of parent node when child node breaks???

    -- Okay, so this is my temporary solution. I really want a better idea for future though.
    -- Perhaps it is okay, as player could define custom selector function that controls the Tree? not sure
    self.parent:next()
end


function Node:add_node(node)
    assert(node~=self, "Bad idea man. Don't do this hahahahah")
    assert(getmetatable(node) == Node_mt, "Node:add() requires a task or node object")

    table.insert(self.ordered_tasks, node)
    self.tasks[node.name] = #self.ordered_tasks
end


function Node:add( task_or_node )
    local mt = getmetatable(task_or_node)

    if mt == Node_mt then
        self:add_node(task_or_node)
    elseif mt == Task_mt then
        self:add_task(task_or_node)
    else
        error("Node:add -> Expected task or node, got: ".. tostring(type(task_or_node)))
    end

    return self
end



return {
    Task = newTask,
    Node = newNode
}

