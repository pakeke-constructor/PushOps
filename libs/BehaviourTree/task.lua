


local Task = {
    type = "Task"
}

local Task_mt = {__index = Task}



local PROXY = { }


local NodesAndTasks = setmetatable({ },
{
    __newindex = function(t,k,v)
        if v == nil then
            error("This is an error with BT lib. Tell Oli!")
        end
        if PROXY[k] then
            error("Attempted to overwrite Node or task name: `".. k .."`")
        end
        if not(k:sub(1,1)=="_") then
            -- `_` at start of name denotes private name.
            PROXY[k] = v
        end
    end,
    __index = function(_,k)
        if not PROXY[k] then
            local availables = {}
            for tn,_ in pairs(PROXY) do
                table.insert(availables, tostring(tn))
            end
            local available_str = table.concat(availables, "\n")
            error("Unknown task or node:   " .. k .. "\nHere are all possible options: \n\n" .. available_str)
        end
        return PROXY[k]
    end
})



local runtimeMT = {
    __mode = "k"
    ;__index = function() return 0 end
}





local function newTask(name, copy)
    -- `copy` optional argument
    if name then
        if type(name) ~= "string" then
            error("Expected string for BT.Task( str ), got: "..type(name))
        end
    end

    local task = {name = name}

    task.runtimes = setmetatable({}, runtimeMT)
 
    if copy then
        task.start = copy.start
        task.update = copy.update
        task.finish = copy.finish
        task.name = "_copy_" .. copy.name
    end

    task.parent = nil -- Parent node this task belongs to

    if name then
        if not copy then
            NodesAndTasks[name] = task
        end
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





function Task:_update(ent, dt)
    local runtime = self.runtimes[ent]
    
    if runtime == 0 then
        self:start(ent,dt)
    end

    self.runtimes[ent] = runtime + dt

    if not self.update then
        error("Task `" .. tostring(self.name) .. "` not given .update function")
    end

    local outcome = self:update(ent, dt)

    if not closing_funcs[outcome] then
        error("Incorrect task close. return either `r`, `k`, or `n`.")
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

