

local Ents = require("src.entities")
local rand = love.math.random

local enemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.enemy]    = 0.5;
    [Ents.boxenemy] = 0.3;
    [Ents.blob]     = 0.3;
    [Ents.boxblob]  = 0.3;
    [Ents.ghost]    = 0.1
}


local bigEnemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [function(x,y)
        for i=-1,0 do
            Ents.devil(x+(i*15), y+(i*15))
        end
    end] = 0.5
}



local purge_fn = function(e, cam_x, cam_y)
    -- called at end of level to clear enemies and walls.
    -- (Passed in as a param to `ccall(apply, .)`  ).
    if (e.targetID ~= "player")
    and (Tools.dist(cam_x-e.pos.x,cam_y-e.pos.y) < 160) then
        ccall("damage",e,0xffff)
    end
end


local function spawn_portal(x, y)
    local portal = EH.Ents.portal(x, y)
    portal.portalDestination = {
        x = 30;
        y = 30;
        tier = 1;
        type="menu";
        
    }
end


local WH = require("src.misc.worldGen.WH")

return {

    construct = function(wor,wmap, px, py)
        WH.zonenum(1, px,py)
        WH.lights(wor, wmap, 15, 150)
    end;

    type = 'basic',
    tier = 1,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.

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
        n = 35;
        n_var = 1;

        bign = 1;
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
            if rand()<0.3 then
                Ents.mushroom(x + rand(-20,20), y + rand(-20,20))
            else
                if rand()<0.5 then
                    Ents.pine(x + rand(-20,20), y + rand(-20,20))
                else
                    Ents.blue_mushroom(x + rand(-20,20), y + rand(-20,20))
                end
            end
        end
    }
}
}












