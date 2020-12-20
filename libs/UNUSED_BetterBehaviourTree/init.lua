




local NODE_CALLBACKS = {
    start = true;
    update = true;
    finish = true
}


local Node_mt = {
    __index = Node,
    __newindex = function(node, ke, v)
        if NODE_CALLBACKS[ke] then
            assert(type(v) == "function", "Node: Expected type function for field `".. tostring(ke) .."`")
        else
            assert(type(v) == "table", "Node: Expected type `table` for field `".. tostring(ke) .."`")
            rawset(node,ke,v)
            node:_init_path(ke)
        end

        rawset(node,ke,v)
    end}

local Node = {}



local Nodes_proxy = {}
local Nodes = setmetatable({},
{
    __newindex = function(t,k,v)
        if rawget(Nodes_proxy,k) then
            error("Attempt to overwrite node name :: " .. k)
        end
        Nodes_proxy[k]=v
    end,
    __index = Nodes_proxy
})


local RunningTime_mt = {
    __index = function(t,k)
        t[k] = 0
        return t[k]
    end,
    __mode = "k"
}



local RESERVED_FIELDS = {
    -- Reserved field names for Node object
    next=true,
    reset=true,
    continue=true,
    run=true,
    runtime=true,
    overtime=true,
    root=true,
    parent=true,
    on=true,
    event=true,
}



local function newNode( node )
    if node.name then
        Nodes[node.name] = node
    end

    for key, _ in pairs(node) do
        if RESERVED_FIELDS[key] then
            error("Node was given protected or reserved field :: "..key)
        end
        if not NODE_CALLBACKS[key] then
            Node._init_path(node, key)
        end
    end

    node._index = 1 -- the node index that it is currently running
    node._path = nil -- the string path that it is currently running
    node._parent = nil

    node._closed_correctly = false -- Whether or not this node's update function closed correctly.

    node._ent = nil -- The current ent that is being ran
    node._dt = nil -- The last DT value passed into node

    -- table that stores the runtimes of entities upon this node.
    node._runtimes = setmetatable({}, RunningTime_mt)

    --[[
        This nodes "children" are in keyworded tables specified by
        the user.

        A common thing to do is to name the children tables
        "left" and "right", to resemble a tree.
    ]]

    setmetatable(node, Node_mt)
    return node
end



function Node:_init_path(name)
    local path = self[name]
    assert(path)
    assert(not getmetatable(path), "Objects added to Node paths must be basic arrays. See documentation")

    for i, node in ipairs(path) do
        if type(node) == "string" then
            if not Nodes[node] then
                error("Node `".. tostring(node) .."` does not exist!")
            end
            path[i] = Nodes[node]
        end
        node._parent = self
    end
end



function Node:running( run_again )
    if run_again then
        self:root():run(self._ent, self._dt)
    end
end


function Node:to(childPath, run_again)
    assert(self[childPath], "Node:to >> path `" .. childPath .. "` does not exist in this Node.")

    local cur_path = self[self._path]
    self._index = 1
    self._closed_correctly = true
    if cur_path then
        local cur_node = cur_path[self._index]
        if cur_node then
            cur_node:finish(self._ent, self._dt)
        end
    end
    self._path = childPath
    self._closed_correctly = true

    if run_again then
        self:root():run(self._ent, self._dt)
    end
end



function Node:next(run_again)
    self._closed_correctly = true
    if self._parent then
        self._parent._index = self._parent._index + 1

        if self._parent._index > #self._parent[self._path] then
            self:finish()
            self._parent._index = 1
        end
    else
        self._index = self._index + 1

        if self._index > #self[self._path] then
            self:finish()
            self._index = 1
        end
    end

    if run_again then
        self:root():run(self._ent, self._dt)
    end
end



function Node:reset(run_again)
    --[[
        resets state of the whole tree from root.
    ]]
    if self._parent then
        self:root():_reset_whole_tree()
    else
        self:_reset_whole_tree()
    end

    if run_again then
        self:root():run(self._ent, self._dt)
    end
end






function Node:root()
    if self._parent then
        return self._parent:root()
    else
        return self
    end
end


local er_missing_arg = "Missing argument! Use node:run(ent, dt) to run the behaviour tree on object `ent`."
local er_didnt_finalize = "Node `update` function did not finalize. "

function Node:run(ent, dt)
    -- Assertions
    do 
        assert(ent and dt, er_missing_arg)
        if type(ent) ~= "table" then
            error("Node:run(ent, dt) ::: arg `ent` is supposed to be table!")
        end
        if type(dt) ~= "number" then
            error("Node:run(ent, dt) ::: arg `dt` is supposed to be number!")
        end
    end

    self._ent = ent
    self._dt = dt

    if self._runtimes[ent] == 0 then
        self:start(ent,dt)
    end

    self._closed_correctly = false

    if self._path then
        self._closed_correctly = true -- This node does not have control, so leave it be.
        self[self._path][self._index]:run(ent, dt)
    else
        self:update(ent, dt)
        if not self._closed_correctly then
            error(er_didnt_finalize)
        end
    end

    self._runtimes[ent] = self._runtimes[ent] + dt
end



function Node:_reset_whole_tree()
    
end



function Node:runtime(e)
    return self._runtimes[e]
end

function Node:overtime(ent, time)
    return self._runtimes[e] <= time
end

function Node:parent()
    return self._parent
end







--[[
    User defined callbacks
]]
function Node:start()
end

function Node:finish()
end

return newNode
