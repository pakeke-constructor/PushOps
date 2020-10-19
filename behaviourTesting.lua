

local BT =require("libs.BehaviourTree")



local Tprint_ye = BT.Task{
    name="Tprint_ye",

    start=function(t,e)
        --print(e, " start! ye ")
    end,

    run = function(t, e, dt)
        --print(e, "ye")
        if t:overtime(2) then
            return t:to("hw")
        end
        t:resume()
    end,

    finish = function(t,e) return
        --print(e, "end! YE")
    end
}

local Tprint_helloworld = BT.Task("hw")

function Tprint_helloworld:run(e, dt)
    --print("Hello world")
    self:next()
end

local Tprint_bah = BT.Task{
    name = "Tprint_bah",

    start=function(t,e)
        --print(e, " BAH ")
    end,

    run = function(t,e,dt)
        --print(e, "BAH")
        local will_continue = (math.random( ) < 0.5)

        if t:overtime(2) then
            if will_continue then
                return t:resume()
            else
                return t:next()
            end
        end
        t:resume()
    end
}



local nested = BT.Node("nested")
    :add(Tprint_bah)
    :add(Tprint_helloworld)
    :add(Tprint_bah)



local nodeAI = BT.Node("testAI")
    :add(Tprint_ye)
    :add(Tprint_helloworld)
    :add(nested)

