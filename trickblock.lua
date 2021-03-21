

--[[

Block entity that turns into an enemy when provoked
(current trigger is when player moves close)


]]



local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local cexists = Cyan.exists
local cam = require("src.misc.unique.camera")


local frames = {1,2,3,4,3,2}
for i,v in ipairs(frames) do
    frames[i] = Quads["trick_block"..tostring(v)]
end



local Tree = EH.Node("trickblock BehaviourTree")

function Tree:choose(e)
    if e.is_block then
        if (Tools.distToPlayer(e, cam) < 70) then
            return "turnIntoEnemy"
        end
    else
        -- is an enemy already
        if e.hp.hp < e.hp.max_hp/3 then
            return "scared"
        end
    end
    return 'wait'
end





Tree.turnIntoEnemy = {
    -- turns into enemy
    TE_task
}


Tree.turnIntoBlock = {
    -- turns back into block when it is a safe distance from player,
    -- and regains all HP
}


Tree.scared = {
    "move::SOLO",
    "wait::4"
}


Tree.wait = {
    "wait::2"
}





return function(x, y)

    local e = Cyan.Entity()
    EH.PV(e,x,y)

    e._is_block = true --whether this entity is a block or not

    e.animation = {
        frames = frames;
        interval = 0.3;
        current=0
    }
    
    e.hp = {
        hp=400;
        max_hp = 400
    }

    e.pushable = true

end


