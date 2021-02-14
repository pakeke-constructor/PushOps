

local Ents = require("src.entities")
local rand = love.math.random




return {
    type="menu";
    tier = 1;

    entities = {
        ["#"] = { -- For wall entity.
            max = 999999, --No max.
            Ents.wall
        };

        ["@"] = {
            max = 1,
            Ents.player
        },
        
        ["e"] = {
            max = 200;
            function(x,y)
                Ents.blob(x,y)
                Ents.enemy(x+5,y+5)
                Ents.mallow(x-5,y-5)
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
            max = 6, -- Max spawns :: 6
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
            max = 0xFFFFFFFF; --no max;
            Ents.fakeWall -- Nothing :) waste of space, you!
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
        }
    }
}