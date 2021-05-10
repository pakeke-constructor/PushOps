

local Ents = require("src.entities")
local rand = love.math.random



local TXT_COLOUR = {120/255, 90/255, 65/255, 0.52}

return {
    type="menu";
    tier = 1;

    enemies = {
        n=0;
        bign=0
    };

    entities = {

        ["X"] = {
            --[[
                Experimental entity slot.
                This ent could refer to any entity type, it just depends what I
                am testing rn!
            ]]
            function(x,y)
                for i=1,1 do
                    EH.Ents.pillar(x + i*10,y + i*10)
                end
            end;
            max=0xfff
        };

        ["#"] = { -- For wall entity.
            max = 999999, --No max.
            Ents.wall
        };

        ["1"] = {
            max=0xff;
            function(x,y)
                local txt = EH.Ents.goodtxt(x, y-35, nil,
                    " WASD\nto move",
                    TXT_COLOUR, 250)
            end
        };

        ["2"] = {
            max=0xff;
            function(x,y)
                local txt = EH.Ents.goodtxt(x,y,nil,
                    "Arrow keys\nto push\nand pull",
                    TXT_COLOUR, 250)
            end
        };

        ["3"] = {
            max=2;
            function(x,y)
                local txt = EH.Ents.goodtxt(x, y, nil,
                    "Colliding blocks\nwill deal damage",
                    TXT_COLOUR, 250)
            end
        };

        ["L"] = {
            max=1;
            function(x,y)
                local txt=EH.Ents.goodtxt(x,y+25, nil,
                    "PROUDLY MADE\nWITH LOVE 2d",
                    {0.85,0.45,0.45})
                EH.Ents.love2d_logo(x,y)
            end
        };

        ["t"] = {
            max=0xfff;
            function(x,y)
            ccall("spawnText", x, y, "push game")
        end};

        ["e"] = {
            max = 200;
            function(x,y)
                Ents.blob(x,y)
                Ents.enemy(x+5,y+5)
                Ents.mallow(x-5,y-5)
            end
        };

        ["p"] = {
            max = 300, -- 300 max
            function(x, y)
                for i = 1, rand(3,6) do
                    Ents.block(
                        x + rand(-10, 10),
                        y + rand(-10, 10)
                    )
                end
            end
        };

        ["P"] = {
            max = 12, -- Max spawns :: 6
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

        ['w'] = {
            max = 1;
            function(x,y)
                Ents.bigwall(x,y)
            end
        };

        ['^'] = {
            max = 0xFFFFFFF;
            function(x,y)
                local grass = Ents.grass
                local stone = Ents.stone
                for i=1, rand(8,9) do
                    grass(x + rand(-50, 50), y + rand(-50, 50))
                end
                if rand()<0.3 then
                    for i=1, rand(2,3)do
                        stone(x + rand(-10, 10), y + rand(-10, 10))                    
                    end
                end
            end
        };

        ['%'] = {
            max = 0xFFFFFFFF; --no max;
            Ents.wall
        };

        ['l'] = {
            max = 100;
            function (x, y)
                if rand()<0.5 then
                    Ents.mushroom(x+rand()*5, y+rand()*5)            
                else
                    Ents.pine(x+rand()*5, y+rand()*5)
                end
            end
        },

        ['&'] = {
            max = 0xfff;
            function(x,y)
                local portal = Ents.portal(x,y)
                portal.portalDestination = {
                    tier = 1;
                    type = "basic";
                    x = 32;
                    y = 32
                }
                
                EH.Ents.goodtxt(x,y+10, nil,"ZONE I",{0.1,0.7,0.1}, 250)
            end
        }
    }
}




