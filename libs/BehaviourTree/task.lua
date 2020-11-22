


local Task = {
    type = "Task"
}

local Task_mt = {__index = Task}



local PROXY = { }
local NodesAndTasks = setmetatable({},
{
    __newindex = function(t,k,v)
        if PROXY[k] then
            error("Attempted to overwrite Node or task name: `".. k .."`")
        end
        PROXY[k] = v
    end,
    __index = PROXY
})


local runtimeMT = {
    __mode = "k"
    ;__index = function() return 0 end
}





local function newTask(name, copy)
    -- `copy` optional argument

    local task = {name = name}

    task.runtimes = setmetatable({}, runtimeMT)
    
    if copy then
        task.start = copy.start
        task.update = copy.update
        task.finish = copy.finish
    end

    task.parent = nil -- Parent node this task belongs to

    if name then
        NodesAndTasks[name] = task
    end

    return setmetatable(task, Task_mt)
end



function Task:runtime(ent)
    return self.runtimes[ent]
end




function Task:_reset(ent)
    --[[
        _resets state of this task entirely
    ]]    
    if self.runtimes[ent] > 0 then
        -- This way, :finish cannot be ran twice.
        self:finish(ent)
    end

    self.runtimes[ent] = nil
end





local er_missing_par = "Task does not have a parent, oli, fix"

local closing_funcs = {
    r = function(task, ent, dt) end;

    n = function(task, ent, dt)
        -- "next" update callback
        assert(task.parent, er_missing_par)

        task:_reset(ent)
        task.parent:next(ent)
    end;

    k = function(task, ent, dt)
        -- "_kill" update callback
        assert(self.parent, er_missing_par)

        self:_reset(ent)
        self.parent:_kill(ent)
    end
}





local er_noclose = "Incorrect task close. return either `r`, `k`, or `n`."

function Task:_update(ent, dt)
    local runtime = self.runtimes[ent]
    
    if runtime == 0 then
        self:start(ent,dt)
    end

    self.runtimes[ent] = runtime + dt

    local outcome = self:update(ent, dt)

    if not closing_funcs[outcome] then
        error(er_noclose)
    end

    closing_funcs[outcome](self, ent, dt)
end









function Task:finish(ent, dt)
    -- USER CALLBACK
end
function Task:start(ent, dt)
    -- USER CALLBACK
end







return {
    newTask = newTask,
    NodesAndTasks = NodesAndTasks
}

