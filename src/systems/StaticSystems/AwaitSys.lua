
--[[

System for asynchronous/delayed events


]]


local AwaitSys = Cyan.System()




local times = Tools.set()
--[[
Each `time` object is represented as a table:
{
    func = func -- The func is constructed with varargs saved as a closure (bad but oh well)
    time = time
}
]]


function AwaitSys:await(func, time, a,b,c,d,e)
    times:add({
        func = function()
            func(a,b,c,d,e)
        end;
        time = time
    })
end

function AwaitSys:update(dt)
    for _,timeObj in ipairs(times.objects) do
        timeObj.runtime = timeObj.runtime or 0
        timeObj.runtime = timeObj.runtime + dt
        if timeObj.runtime > timeObj.time then
            timeObj.func()
            times:remove(timeObj)
        end
    end
end



