
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


function AbstractSys:await(func, time, ...)
    local args={...}
    
    if CONSTANTS.DEBUG then
        assert(#args<7,"sorry, you broke the arg cap on ccall('await'). \n Extend the arg number in AbstractSys")
    end

    times:add({
        args = args;
        func = func;
        time = time
    })
end

function AbstractSys:update(dt)
    for _,timeObj in ipairs(times.objects) do
        timeObj.runtime = timeObj.runtime or 0
        timeObj.runtime = timeObj.runtime + dt
        if timeObj.runtime > timeObj.time then
            local args = timeObj.args
            timeObj.func(args[1],args[2],args[3],args[4],args[5],args[6],args[7])
            timeObj.args=nil
            times:remove(timeObj)
        end
    end
end


function AbstractSys:purge()
    times:clear()
end





