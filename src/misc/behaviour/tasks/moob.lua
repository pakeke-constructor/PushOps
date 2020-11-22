

local B=require'libs.BehaviourTree'




B.Task{
    name="moob"
    ;
    run=function(t,e)
        local strength = 15 -- default is 15

        if e.strength then
            strength = e.strength
        end

        Cyan.call("moob", e.pos.x, e.pos.y, strength)

        t:next()
    end
}

