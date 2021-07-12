


--[[

Take 4x damage

Deal 2x damage to enemies

]]

return {
    damage = function(player, ent, amount)
        if ent.hp then
            local hp = ent.hp
            if ent.targetID == "player" then
                hp.hp = hp.hp - amount * 3
            elseif ent.targetID == "enemy" then
                hp.hp = hp.hp - amount
            end
        end
    end
}




