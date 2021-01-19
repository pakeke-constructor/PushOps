
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
    name = "wait::"..tostring(N)
    local task = B.Task(name)

    task.start = function(t,e)
    end

    task.run = function(t, e, dt)
        local ret
        if t:overtime(e,N) then
            ret= "n"
        else
            ret="r"
        end
        return ret
    end

    task.finish = function(t,e)
    end
end


