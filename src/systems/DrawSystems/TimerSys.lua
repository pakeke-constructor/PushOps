--[[

times how long the player has been
on a run for

(useful for speedruns and endless mode)
]]


local TimerSys = Cyan.System()



local tick = 0


function TimerSys:update(dt)
    tick = tick + dt
    CONSTANTS.runtime = tick
end


function TimerSys:reset()
    tick = 0
end

