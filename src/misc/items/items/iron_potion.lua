
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
            hp.max_hp = hp.max_hp * 3
            hp.hp = hp.hp * 3

            player.hpBarColour = {0.4,0.4,0.4}

            hp.regen = 0
        end
    end;

    description = "Increased HP, no regen"
}


