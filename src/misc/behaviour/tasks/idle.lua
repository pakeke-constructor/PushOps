
--[[
idle tasks, 1 -> 10.

idle1 --> idle 1 second
idle2 --> idle 2 seconds
idle3 --> idle 3 seconds
...
etc etc.
...
idle10 --> idle 10 seconds

]]



local B=require'libs.BehaviourTree'
local ccall = Cyan.call


for N = 1, 10 do

B.Task{
    name = "idle"..tostring(N),

    start = function(t,e)
        -- TODO ==> 
        -- Cache moveBehaviourState somewhere
        -- Change to idle moveBehaviour state.
    end,

    run = function(t, e, dt)
        if t:overtime(N) then
            t:next()
        else
            t:resume()
        end
    end,

    finish = function(t,e)
        -- TODO ==>
        -- Revert back to regular moveBehaviour State.
        -- (original is cached from task:start.)
    end
}

end


