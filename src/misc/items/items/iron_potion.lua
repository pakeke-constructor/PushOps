
--[[

Iron potion
    +100% health
    no HP regen
    healthbar turns gray colour

]]

return {
    load = function(player)
        if player.hp then
            local hp = player.hp
            hp.max_hp = hp.max_hp * 2
            hp.hp = hp.hp * 2

            player.hpBarColour = {0.4,0.4,0.4}

            hp.regen = 0
        end
    end
}
