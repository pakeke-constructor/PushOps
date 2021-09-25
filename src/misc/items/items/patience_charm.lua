
--[[

    Standing still regains health, 15hp per second

]]


return {
    update = function(player, dt)
        if player.vel:len() < 2 then
            if player.hp then
                player.hp.hp = player.hp.hp + 15*dt
            end
        end
    end;

    description = "Standing still gives HP"
}

