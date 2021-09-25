
return {
    --[[
        15% speed boost
        
    ]]
    load = function(player)
        if player.speed then
            local spd = player.speed
            spd.speed = spd.speed * 1.15
            spd.max_speed = spd.max_speed * 1.15
        end
    end;

    description = "Speed up"
}


