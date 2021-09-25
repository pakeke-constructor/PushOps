
--[[

Bull ring
    Increased movement speed, decreased agility
        <NOTE: less control over movement>


(Increases max speed by 20%)

]]


return {
    load = function(player)
        if player.speed then
            player.speed.max_speed = player.speed.max_speed * 1.2
        end
    end;

    description = "Max speed increased"
}
