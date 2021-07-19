

local gladiator_colour = {255, 243, 176}

for i,v in ipairs(gladiator_colour) do-- to normalized
    gladiator_colour[i] = v/255
end

local WH = require("src.misc.worldGen.WH")



local Ents=EH.Ents
local rand = love.math.random

local currentMediator = nil
    -- The current game mediator will be kept here


return {
    type="endless",
    tier=1,

    enemies = {
        n=0;
        n_var=0;
        bign=0; bign_var=0
    };

    construct = function(wor,wmap,px,py)
        ccall("spawnText", px, py - 100, "endless", 320, 20)
        WH.lights(wor, wmap, 15, 150)
        ccall("setGrassColour", table.copy(gladiator_colour))
    end;

    entities = {

        ['M'] = {
            max=1;
            function(x,y)
                EH.Ents.mediator(x,y) -- An entity that spawns 
            end
        };
        
        ['^'] = {
            max = 0xFFFFFFF;
            function(x,y)
                local grass = Ents.grass
                for i=1, rand(8,9) do
                    grass(x + rand(-50, 50), y + rand(-50, 50))
                end
            end
        };

        ['x'] = {
            max=0xffff;
            function(x,y)
                local e =  Ents.pillar(x,y)
                e.colour = gladiator_colour
            end
        };

        ["#"] = {
            max=0xffff;
            function(x,y)
                local grass = Ents.grass
                Ents.pine(x + rand(-100,100), y + rand(-100,100))
                for i=1, rand(1,3) do
                    grass(x + rand(-50, 50), y + rand(-50, 50))
                end
            end
        };

        ["%"] = {
            max=0xfffff;
            function(x,y)
                Ents.inviswall(x,y)
                local pillar = Ents.pillar(x,y)
            end
        };
    
    
        ['l'] = {
            max = 100;
            function (x, y)
                Ents.pine(x+(rand()-.5)*20,y+(rand()-.5)*20)
            end
        };

    }
}

