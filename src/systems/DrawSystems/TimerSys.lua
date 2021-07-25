--[[

times how long the player has been
on a run for

(useful for speedruns and endless mode)
]]


local TimerSys = Cyan.System()



local runtime = 0


function TimerSys:update(dt)
    runtime = runtime + dt
    CONSTANTS.runtime = runtime
end


function TimerSys:reset()
    runtime = 0
end


