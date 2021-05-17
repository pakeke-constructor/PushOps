

local gladiator_colour = {255, 243, 176}

for i,v in ipairs(gladiator_colour) do-- to normalized
    gladiator_colour[i] = v/255
end




local Ents=EH.Ents
local rand = love.math.random


return {
    type="gladiator",
    tier=1,

    enemies = {
        n=0;
        n_var=0;
        bign=0; bign_var=0
    };

    entities = {

        ['M'] = {
            max=0;
            function(x,y)return end
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
        }
    }
}

