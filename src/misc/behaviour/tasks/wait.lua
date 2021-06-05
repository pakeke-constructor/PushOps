
--[[
wait tasks, 1 -> 10.

wait1 --> wait 1 second
wait2 --> wait 2 seconds
wait3 --> wait 3 seconds
...
etc etc.
...
wait10 --> wait 10 seconds

]]


local B=require'libs.BehaviourTree'
local ccall = Cyan.call


for N = 1, 10 do
    local name = "wait::"..tostring(N)
    local task = B.Task(name)

    task.start = function(t,e)
    end

    task.update = function(t, e, dt)
        local ret
        if t:runtime(e)>N then
            ret= "n"
        else
            ret="r"
        end
        return ret
    end

    task.finish = function(t,e)
    end
end

-- also add a wait::r task that waits a small time, usually like 0.5 seconds
-- (But with a max of 2 seconds )
local _wait_r = B.Task("wait::r")

local rand = love.math.random

_wait_r.update=function(t,e,dt)
    local ret
    if (rand()*2) >  t:runtime(e) then
        ret= "n"
    else
        ret="r"
    end
    return ret
end

