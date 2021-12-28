

local flags = require("src.misc.items.itemflags")

local LANTERN_REGEN = 150 -- 150 hp regen per sec

local WHITE = {1,1,1,1}


local frames = {1,2,3,2}
for i,v in ipairs(frames)do
    frames[i] = EH.Quads["firefly"..tostring(v)]
end

local SHOCK_TIME = 0.2 -- seconds between shockwaves
local time_since_last_shock = 0 

return function(x,y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.size = 50
    e.light = {
        height = nil; --There is a default value in lightSys
        distance = 500;
        colour = WHITE
    }

    e.collisions = {
        area = {
            player = function(self, player, dt)
                if flags.lantern and player.hp then
                    ccall("heal", player, LANTERN_REGEN * dt)
                    
                    -- do shockwave effcct
                    time_since_last_shock = time_since_last_shock - dt
                    if time_since_last_shock <= 0 then
                        time_since_last_shock = SHOCK_TIME
                        ccall("shockwave", player.pos.x, player.pos.y,
                                10, 50, 10, SHOCK_TIME * 1.5, {0.9,0,0})
                        ccall("shockwave", self.pos.x, self.pos.y,
                                10, 100, 10, SHOCK_TIME * 3, {0,0,0.9})          
                    end
                end
            end
        }
    }

    e.animation = {
        frames=frames;
        interval=0.1
    }

    e.speed = {
        speed = 10;
        max_speed = 10
    }

    e.behaviour = {
        move={
            type="RAND";
            id=1
        }
    }

    return e
end

