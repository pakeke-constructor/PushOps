

local BT = require("libs.behaviourTree")

local ccall=Cyan.call


for _,t in ipairs{"IDLE","ROOK","LOCKON","ORBIT","RAND"} do
    local task = BT.Task("move::"..t)
    -- We dont need to do xtra permutations for targetIDs,
    -- because targetID can be changed at runtime no problemo.
        
    task.start = function(T, e)
        assert(e.behaviour, "you made mistake")
        assert(e.behaviour.move, "you made mistake")
        ccall("setMoveBehaviour", t, object.behaviour.move, e.behaviour.move.id)
    end
    task.update = function() return "n" end;
end




