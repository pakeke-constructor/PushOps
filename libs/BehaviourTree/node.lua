



local PATH = (...):gsub('%.[^%.]+$', '')
local task_lua = require(PATH..".task")

local newTask = task_lua.newTask

local NodesAndTasks = task_lua.NodesAndTasks
task_lua = nil







local Node = {
    type = "Node"
}



local parsePath

local newNode


local Node_mt = {
    __index = Node;
    __newindex = function(node,k,v)
        if k == "choose" then
            -- Then we are looking at a `choose` function
            if type(v) ~= "function" then
                error("expected function for choose, got : "..tostring(type(v)))
            end
    
            rawset(node,k,v)

        elseif k == "parent" then
            rawset(node,k,v)
            return -- We leave parent nodes alone
        
        else
            -- Else, it must be a path
            if type(v) ~= "table" then
                error("expected table for path `"..tostring(k).."`, got: " .. tostring(type(v)))
            end

            rawset(node.paths,k,v)
            parsePath(node, k)
        end
    end
}


local weakMT = {__mode = "k"}



function parsePath(node, path)

    local pathArr = node.paths[path]

    for i, task in ipairs(pathArr) do
        if type(task) == "string" then
            local taskname = task
            task = NodesAndTasks[taskname]
            if not task then
                error("unrecognized task string: "..taskname)
            end
        end
        
        if task.type == "Node" then
            -- Second arg means that this is a copy
            pathArr[i] = newNode(nil, task)
        elseif task.type == "Task" then
            -- Second argument means that this instance is a copy.
            pathArr[i] = newTask(nil, task)
        else
            -- unrecognized type
            error("unrecognized type passed into Node path. Only Nodes, Tasks, and/or task/node string names allowed.")
        end

        pathArr[i].parent = node
    end

    return pathArr
end



function newNode(name, copy)
    -- `copy` optional argument
    if type(name)~= "string" then
        error("BehaviourTree.Node( arg ) expected arg as type string, not "..type(name))
    end

    local node = {name = name}

    node._ent_paths = setmetatable({ }, weakMT)
    node._ent_indexes = setmetatable({ }, weakMT)

    node.parent = nil -- Parent node
    node.paths = { } -- list of paths
    node.callbacks = { }

    setmetatable(node, Node_mt)

    if copy then
        assert(copy.type == "Node", "Expected node")
        
        node.callbacks = copy.callbacks
        node.choose = copy.choose

        for pathname, task_arr in pairs(copy.paths) do
            local newArr = {}
            for i, t_or_n in ipairs(task_arr) do
                if t_or_n.type == "Node" then
                    -- Then its node
                    newArr[i] = newNode(nil, t_or_n)
                elseif t_or_n.type == "Task" then
                    -- else its a task
                    newArr[i] = newTask(nil, t_or_n)
                else
                    -- else... wat? Error
                    error("Attempted to copy something that wasn't node nor task")
                end
            end

            node.paths[pathname] = newArr
            parsePath(node, pathname)
        end
    end

    if name then
        NodesAndTasks[name] = node
    end

    return node
end



function Node:choose()
    error("Node `".. (tostring(self.name) or '') .."` not given :choose(obj) function!")
end




function Node:_reset(ent)
    --[[
        _reset node state and child state
    ]]
    local i = self._ent_indexes[ent]
    local path = self._ent_paths[ent]

    local current = self.paths[path][i]

    if current.type == "Node" then
        -- Then its a Node, recursive _reset
        current:_reset(ent)
    else
        -- Then its a Task, _reset as well
        current:_reset(ent)
    end

    self._ent_indexes[ent] = 1
    self._ent_paths[ent] = nil
end





function Node:update(ent, dt)
    if (not self._ent_paths[ent]) then
        self._ent_indexes[ent] = 1
        self._ent_paths[ent] = self:choose(ent)
    end

    local t_or_n = self.paths[self._ent_paths[ent]][self._ent_indexes[ent]]

    if t_or_n.type == "Node" then
        t_or_n:update(ent, dt)
    else
        t_or_n:_update(ent, dt)
    end
end



function Node:next(ent)
    local index = self._ent_indexes[ent] + 1
    local path = self.paths[self._ent_paths[ent]]

    if index > (#path) then
        -- If the path overflows ::
        if self.parent then
            self:_reset(ent)
            self.parent:next(ent)
        else
            self:_reset(ent)
        end
    else
        self._ent_indexes[ent] = index
    end
end





function Node:_kill(ent)
    --[[
        _resets root Node
    ]]
    if self.parent then
        self.parent:_kill(ent)
    else
        self:_reset(ent)
    end
end





function Node:on(cb_name, func)
    self.callbacks[cb_name] = func
end



function Node:call(cb_name, ent, ...)
    local ret = self.callbacks[cb_name](self, ent, ...)

    if ret then
        -- Can change path!
        self:_reset(ent)
        assert(self.paths[ret], "Path does not exist in this Node.")
        self._ent_paths[ent] = ret
    end
end



return newNode
