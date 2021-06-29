
local Ents = require("src.entities")
local WH = require("src.misc.worldGen.WH")
local rand = love.math.random

local enemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.boxenemy]    = 0.5;
    [Ents.splatenemy]  = 0.3;
    [Ents.boxblob]     = 0.2;
    [Ents.boxblob]     = 0.2;
    [Ents.ghost]       = 0.1;
    [Ents.boxsplitter] = 0.05
}

local bigEnemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.splatbully] = 1;
}



local purge_fn = function(e, cam_x, cam_y)
    -- called at end of level to clear enemies and walls.
    -- (Passed in as a param to `ccall(apply, .)`  ).
    if (e.targetID ~= "player")
    and (Tools.dist(cam_x-e.pos.x,cam_y-e.pos.y) < 160) then
        ccall("damage",e,0xffff)
    end
end



local bossMap = require("src.misc.worldGen.maps.boss_map")

local function spawn_portal(x, y)
    local portal = EH.Ents.portal(x, y)
    portal.portalDestination = {
        x = 30;
        y = 30;
        tier = 8;
        type="basic";
        map = bossMap
    }
end




return {
    type = 'basic',
    tier = 7,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.
    
    construct = function(wor,wmap)
        WH.lights(wor, wmap, 15, 10)
    end;

    PROBS = {
            -- World generation:
            -- Probability of each character occuring.
            -- Each value is a weight and does not actually represent the probability.
            -- see `GenerationSys` for what character represents what.
            ["^"] = 0.8;
            ["l"] = 0.12;
            ["p"] = 0.3;
            ["P"] = 0.01;
            ["."] = 0.4
            -- Bossfights, artefacts, are done through special structure generator
            -- Walls, shops, player spawn, and player exit are done uniquely.
    }, -- Can modify the char probabilities by setting
                        -- this to a table. 

    enemies = {
        n = 25;
        n_var = 4;

        bign = 2;
        bign_var = 0
    };

    ratioWin = function(cam_x, cam_y)
        ccall("apply", purge_fn, cam_x, cam_y)
        ccall("await", spawn_portal, 1.5, cam_x, cam_y)
        --[[
        TODO:
        play sounds and stuff here. Like, a gong would be cool.
        have a shockwave also, that would be cool
        ]]
    end;

    entities = {

    ["e"] = {
        max = 200;
        function(x,y)
            for i=0, 1+rand(1,2) do
                local f = enemySpawns()
                f(x+(i-1)*10 + (rand()-.5)*20, y+(i-1)*10 + (rand()-.5)*20)
            end
        end
    };

    ["E"] = {
        max = 10;
        function(x,y)
            bigEnemySpawns()(x,y)
        end
    };


    ["p"] = {
        max = 300,
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
        max = 3, 
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
                Ents.mushroom(x+(rand()-.5)*40,y+(rand()-.5)*40)
            else
                Ents.pine(x+(rand()-.5)*40,y+(rand()-.5)*40)
            end
        end
    }
}
}











