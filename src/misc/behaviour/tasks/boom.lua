
local B=require'libs.BehaviourTree'




B.Task{
    name="boom"
    ;
    run=function(t,e)
        local strength = 15 -- default is 15

        if e.strength then
            strength = e.strength
        end

        Cyan.call("boom", e.pos.x, e.pos.y, strength)

        t:next()
    end
}

