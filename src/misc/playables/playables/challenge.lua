--[[

challenge character

has 1 hp


]]

return {
    prefix = "dual_player_";
    construct = function(self, player)
        player.hp.hp = 1
        player.hp.max_hp = 1
        self.super.construct(self, player)
    end
}


