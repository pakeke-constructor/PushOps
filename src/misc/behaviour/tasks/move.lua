

local BT = require("libs.BehaviourTree")

local ccall=Cyan.call

local tab = {"IDLE","ROOK","LOCKON","ORBIT","RAND","SOLO",
            "CORBIT","CLOCKON","VECORBIT","VECLOCKON"}
local f = function() return "n" end

for _,t in ipairs(tab) do
    local task = BT.Task("move::"..t)
    -- We dont need to do xtra permutations for targetIDs,
    -- because targetID can be changed at runtime no problemo.
        
    task.start = function(T, e)
        assert(e.behaviour, "you made mistake")
        assert(e.behaviour.move, "you made mistake")
        ccall("setMoveBehaviour", e, t, e.behaviour.move.id)
    end
    task.update = f;
end




