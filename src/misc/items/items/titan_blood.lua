
--[[
    Deal 50% extra damage to bosses
]]

return {
    damage = function(player, ent, amount)
        if ent.targetID == "boss" and ent.hp then
            -- Does 50% extra damage
            ent.hp.hp = ent.hp.hp - (amount/2)
        end
    end;

    description = "Damage bosses more"
}


