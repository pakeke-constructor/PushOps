--[[

times how long the player has been
on a run for

(useful for speedruns and endless mode)



TODO: how are we going to export the time value?
hmmm- I dont really want to do it thru a callback

--> Maybe constantly put runTime in _G.CONSTANTS.

]]


local TimerSys = Cyan.System()



local t1 = 0
local t2 = 0


local function getTime()
    return (t1-t2)
end


function TimerSys:update()
    t1 = love.timer.getTime()
    CONSTANTS.runtime = getTime()
end


function TimerSys:reset()
    t2 = love.timer.getTime()
end

