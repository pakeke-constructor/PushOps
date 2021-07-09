

local tick = 0

local colour = {1,1,1}

local function onUpdate(e,dt)
    colour[1] = (math.sin(tick+3)/2) + 0.5
    colour[2] = (math.sin(tick)/2+0.5)
    colour[3] = math.sin(tick+1.5)/2 + 0.5

    tick = (tick + dt) % (2*math.pi)
end

return {
    prefix = "enemy_";
    construct = function(self, player)
        player.colour = colour
        player.onUpdate = onUpdate
        player.hybrid = true
        self.super.construct(self, player)
    end;

    destruct = function(self, p)
        p.colour = {1,1,1}
    end
}

