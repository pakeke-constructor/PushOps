
--[[

Blue cross
    a blue ghost follows the player and constantly deals
    a little bit of damage to enemies


]]

return {
    load = function(player)
        EH.Ents.friendlyghost(player.pos.x, player.pos.y)
    end
}

