--[[

Vector based version of `LOCKON`
MoveBehaviour.

MoveBehaviour :: VECLOCKON


.move = {
    target = vec3(...)
}

]]


local VECLOCKON = { }

local Partitions = require("src.misc.unique.partition_targets")



function VECLOCKON:update(e, dt)
    -- self is ent
    local move = e.behaviour.move
    
    if not move.initialized then
        self:init(e)
    end

    local target_ent = move.target_ent

    if not target_ent then
        return nil -- No target given, fine by me
    end

    local tp = target_ent.pos -- BUG:: for some reason, `tp` is a vector in this case
    self.updateGotoTarget(e, tp.x, tp.y, dt)
end



function VECLOCKON:init(e)
    local move = e.behaviour.move
    move.initialized = true
end





return setmetatable(VECLOCKON, require(Tools.Path(...)..".base"))
