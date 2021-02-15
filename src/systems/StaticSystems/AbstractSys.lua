
--[[

Handles abstract events that don't really belong to any other system,
or events that other Systems use.

]]


local AbstractSys = Cyan.System()


local Partition = require("src.misc.partition")


function AbstractSys:apply(effect, x,y)
    --[[
        Applys `effect` function to all entities within
        relative range of `x` and `y`.
    ]]
    for ent in Partition:iter(x,y)do
        effect(ent)
    end
end



local times = Tools.set()
--[[
Each `time` object is represented as a table:
{
    func = func -- The func is constructed with varargs saved as a closure (bad but oh well)
    time = time
}
]]


function AbstractSys:await(func, time, a,b,c,d,e)
    times:add({
        func = function()
            func(a,b,c,d,e)
        end;
        time = time
    })
end

function AbstractSys:update(dt)
    for _,timeObj in ipairs(times.objects) do
        timeObj.runtime = timeObj.runtime or 0
        timeObj.runtime = timeObj.runtime + dt
        if timeObj.runtime > timeObj.time then
            timeObj.func()
            times:remove(timeObj)
        end
    end
end


function AbstractSys:purge()
    times:clear()
end





