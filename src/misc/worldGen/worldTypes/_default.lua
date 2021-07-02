
--[[

Fallback entity hasher so code can be reused.

This covers basic entities that will be the same across (pretty much)
all iterations of basic_T1, basic_T2 etc.

(Prime example being '@' character)

]]
local Ents = require("src.entities")
local rand = love.math.random

local menu = require("src.misc.worldGen.maps.menu_map")


local function goToMenu()
    ccall("purge")
    ccall("newWorld",{
        x=100,y=100,
        tier = 1,
        type = 'menu'
    }, menu)
end


return {

    -- NOTE:: YOU DONT NEED TO USE THESE CALLBACKS! they are optional; things will work fine without em
    construct = function(world, worldMap, player_x, player_y )
        -- Callback for when this wType is constructed
        -- (worldMap is only available if passed in)
    end;
    destruct = function()
        -- Callback for when this wType is destructed
    end;


    lose = function( x, y )
        -- wait a bit, then respawn player at menu
        ccall("shockwave", x, y, 10, 700, 30, .57, {0.8,0.05,0.05})
        ccall("spawnText", x, y, "rekt", 750,100)
        ccall("await", goToMenu, 4)
    end;

    entities = {
    ["#"] = { -- For wall entity.
        max = 999999, --No max.
        Ents.wall
    };

    ["%"] = {
        max=math.huge;
        function(x,y)
            Ents.inviswall(x,y)
            for i=1, (rand()*2) do--4 + rand()*2 do
                local X = x+90*(rand()-0.5)
                local Y = y+90*(rand()-0.5)
                Ents.fakepine(X,Y)    
            end
        end
    };

    ["+"] = {
        max=0xff;
        function(x,y)
            local light = EH.Ents.light(x,y)
            light.light.distance = 160
        end
    };

    ["~"] = {
        max=math.huge;
        function(x,y)
            for i=1, rand()*4 do--4 + rand()*2 do
                local X = x+200*(rand()-0.5)
                local Y = y+200*(rand()-0.5)
                Ents.fakepine(X,Y)    
            end
        end
    };

    ["p"] = {
        max = 300, -- 60 max
        function(x, y)
            for i = 1, rand(1,3) do
                Ents.block(
                    x + rand(-10, 10),
                    y + rand(-10, 10)
                )
            end
        end
    };

    ["P"] = {
        max = 3, -- Max spawns :: 3
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, rand(3,6) do
                block_ctor(
                    x + rand(-32, 32),
                    y + rand(-32, 32)
                )
            end
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

    ['l'] = {
        max = 100;
        function (x, y)
            if rand()<0.5 then
                Ents.mushroom(x+rand()*5,y+rand()*5)            
            else
                Ents.pine(x+rand()*5,y+rand()*5)
            end
        end
    };
    ["@"] = {
        max = 1;
        function(x,y)
            return Ents.bullyplayer(x,y)
        end
    }
    }
}











