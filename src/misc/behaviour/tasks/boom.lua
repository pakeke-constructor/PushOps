
local B=require'libs.BehaviourTree'




local task = B.Task("boom")

task.run=function(t,e)
        local strength = 15 -- default is 15

        if e.strength then
            strength = e.strength
        end

        Cyan.call("boom", e.pos.x, e.pos.y, strength)

        return "n"
end


