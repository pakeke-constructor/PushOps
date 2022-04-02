
--[[

walking into walls destroys them, 2 second cooldown.

Player loses 10% speed

]]


local cooldown = 0.3

local function physics(player, oth, speed)
    if oth.targetID ~= "physics" and oth.targetID ~= "enemy" and oth.targetID ~= "boss" and cooldown <= 0 then
        ccall("damage", oth, 9999)
        cooldown = 1
    end
end

return {
    load = function(player)
        if not player.collisions then
            player:add("collisions", {
                physics = physics
            })
            if player.speed then
                player.speed.speed = player.speed.speed * 0.9
                player.speed.max_speed = player.speed.max_speed * 0.9
            end
        end
    end;

    update = function(player, dt)
        cooldown = cooldown - dt
    end;

    description = "Speed down, Instability up"
}


