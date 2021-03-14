
--[[

Handles abstract events that don't really belong to any other system,
or events that other Systems use.

]]


local AbstractSys = Cyan.System()


local Partition = require("src.misc.partition")

local PartitionTargets = require("src.misc.unique.partition_targets")



local er1 = "Invalid targetID"

function AbstractSys:apply(effect, x, y, targetID)
    --[[
        Applys `effect` function to all entities within
        relative range of `x` and `y`.
    ]]
    if targetID then
        assert(PartitionTargets[targetID], er1)
        for ent in PartitionTargets[targetID]:iter(x,y)do
            effect(ent, x, y)
        end
    else
        for ent in Partition:iter(x,y)do
            effect(ent, x, y)
        end
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
    --[[

    Im kinda using this callback a lot. Maybe I should stop
        being so damn reliant on it
    ]]
    local args={...}
    
    if CONSTANTS.DEBUG then
        assert(#args<7,"sorry, you broke the arg cap on ccall('await'). \nExtend the arg number in AbstractSys.")
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
            -- unpack isnt JIT'd
            timeObj.func(args[1],args[2],args[3],args[4],args[5],args[6],args[7])
            for i=1, #timeObj.args do
                timeObj.args[i] = nil -- cut GC some slack
            end
            timeObj.args=nil
            times:remove(timeObj)
        end
    end
end


function AbstractSys:purge()
    times:clear()
end





