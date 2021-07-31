

local PILLAR_COLOUR = {255, 243, 176}

for i,v in ipairs(PILLAR_COLOUR) do-- to normalized
    PILLAR_COLOUR[i] = v/255
end

local WH = require("src.misc.worldGen.WH")
local menu_map = require("src.misc.worldGen.maps.menu_map")


local Ents=EH.Ents
local rand = love.math.random


local function goToMenu()
    ccall("purge")
    ccall("newWorld",{
        x=100,y=100,
        tier = 1,
        type = 'menu',
        minimap = EH.Quads.menu_minimap
    }, menu_map)
end


return {
    type="endless",
    tier=1,

    enemies = {
        n=0;
        n_var=0;
        bign=0; bign_var=0
    };

    lose = function( x, y )
        -- wait a bit, then respawn player at menu
        ccall("shockwave", x, y, 10, 700, 30, .57, {0.8,0.05,0.05})
        ccall("spawnText", x, y, "gg", 750,100)
        ccall("await", goToMenu, 4)
    end;

    construct = function(wor,wmap,px,py)
        ccall("spawnText", px, py - 160, "endless", 1200, 260)
        ccall("spawnText", px, py + 160, "endless", 1200, 260)

        WH.lights(wor, wmap, 15, 150)
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
                e.colour = PILLAR_COLOUR
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

