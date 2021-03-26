
--[[

Fallback entity hasher so code can be reused.

This covers basic entities that will be the same across (pretty much)
all iterations of basic_T1, basic_T2 etc.

(Prime example being '@' character)

]]
local Ents = require("src.entities")
local rand = love.math.random


return {
    ["#"] = { -- For wall entity.
        max = 999999, --No max.
        Ents.wall
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

    ['%'] = {
        max = 999999; --no max;
        Ents.wall -- had to change to regular wall due to destruction
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
            return Ents.player(x,y)
        end
    }
}











