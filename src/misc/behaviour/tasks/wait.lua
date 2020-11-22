
--[[
wait tasks, 1 -> 10.

idle1 --> wait 1 second
idle2 --> wait 2 seconds
idle3 --> wait 3 seconds
...
etc etc.
...
idle10 --> wait 10 seconds

]]



local B=require'libs.BehaviourTree'
local ccall = Cyan.call


for N = 1, 10 do

B.Task{
    name = "wait"..tostring(N),

    start = function(t,e)
    end,

    run = function(t, e, dt)
        if t:overtime(e,N) then
            t:next()
        end
    end,

    finish = function(t,e)
        -- TODO ==>
        -- Revert back to regular moveBehaviour State.
        -- (original is cached from task:start.)
    end
}
end


