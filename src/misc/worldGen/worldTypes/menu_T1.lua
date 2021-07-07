

local Ents = require("src.entities")

local WH = require("src.misc.worldGen.WH")

local savedata = require("src.misc.unique.savedata")

local rand = love.math.random


local function tokenTextUpdateFn(ent)
    if ent.tokens_displayed ~= savedata.tokens then
        ent.text = "Tokens: "..tostring(savedata.tokens)
    end
end


local TXT_COLOUR = {120/255, 90/255, 65/255, 0.52}

return {
    type="menu";
    tier = 1;

    enemies = {
        n=0;
        bign=0
    };

    construct = function(wor,wmap)
        ccall("setGrassColour","green")
        WH.lights(wor, wmap, 100, 120)
    end;

    entities = {

    ["X"] = {
            --[[
                Experimental entity slot.
                This ent could refer to any entity type, it just depends what I
                am testing rn!
            ]]
            function(x,y)
                for i=1,1 do
                    --EH.Ents.bigworm(x + i*10,y)
                end
            end;
            max=0xfff
        };

        ["a"] = {
            max=0xff;
            function(x,y)
                local txt = EH.Ents.goodtxt(x, y-35, nil,
                    " WASD\nto move",
                    TXT_COLOUR, 250)
            end
        };

        ["b"] = {
            max=0xff;
            function(x,y)
                local txt = EH.Ents.goodtxt(x,y,nil,
                    "Arrow keys\nto push\nand pull",
                    TXT_COLOUR, 200)
            end
        };

        ["c"] = {
            max=2;
            function(x,y)
                local txt = EH.Ents.goodtxt(x, y, nil,
                    "Colliding blocks\nwill deal damage",
                    TXT_COLOUR, 200)
            end
        };

        ["L"] = {
            max=1;
            function(x,y)
                local txt=EH.Ents.goodtxt(x,y+25, nil,
                    "PROUDLY MADE\nWITH LOVE 2D",
                    {0.9,0.4,0.8})
                EH.Ents.love2d_logo(x,y)
            end
        };

        ["%"] = {
            max = 0xffffff;
            function(x,y)
                EH.Ents.strongwall(x,y)
            end
        };

        ["t"] = {
            max=0xfff;
            function(x,y)
            ccall("spawnText", x, y, "push ops")
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
                for i = 1, 1 do--rand(3,6) do
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

        ['^'] = {
            max = 0xFFFFFFF;
            function(x,y)
                local grass = Ents.grass
                for i=1, rand(8,11) do
                    grass(x + rand(-50, 50), y + rand(-50, 50))
                end
            end
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

        ['&'] = { -- Turn off for now.
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
        };

        ["0"] = {
            max=1;
            function(x,y)
                EH.Ents.goodtxt(x,y-50,nil,"PLAYABLE CHARACTERS",{0.6,0.1,0.05}, 400)
                
                local token_txt = EH.Ents.txt(x,y-20,"Tokens: "..tostring(savedata.tokens))
                token_txt.colour = {0.8,0.2,0.2}
                token_txt.fade = 350
                token_txt.onHeavyUpdate = tokenTextUpdateFn -- Need to update
                token_txt.hybrid = true
                token_txt.tokens_displayed = savedata.tokens
            end
        };

        ["1"] = {
            max = 1;
            function(x,y)
                local ent = EH.Ents.playerpillar(x,y)
                ent.playerType = "red";
                ent.playerPillarImage = EH.Quads.red_player_down_1
                ent.unownedPillarImage = EH.Quads.unknown_player
                ent.playerCost = 0
            end
        };

        ["2"] = {
            max = 1;
            function(x,y)
                local ent = EH.Ents.playerpillar(x,y)
                ent.playerType = "glasses";
                ent.playerPillarImage = EH.Quads['3d_player_down_1']
                ent.unownedPillarImage = EH.Quads.unknown_player
                ent.playerCost = 100
            end
        };

        ["3"] = {
            max = 1;
            function(x,y)
                local ent = EH.Ents.playerpillar(x,y)
                ent.playerType = "blind";
                ent.playerPillarImage = EH.Quads.blind_player_down_1
                ent.unownedPillarImage = EH.Quads.unknown_player
                ent.playerCost = 200
            end
        };

        ["4"] = {
            max=1;
            function(x,y)
                local ent = EH.Ents.playerpillar(x,y)
                ent.playerType = "cyclops";
                ent.playerPillarImage = EH.Quads.cyclops_player_down_1
                ent.unownedPillarImage = EH.Quads.unknown_player
                ent.playerCost = 500
            end
        }
    }
}




