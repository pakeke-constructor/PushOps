

--[[

TYPE :: 'basic'

tier :: T4 :: 4


]]


--[[

World map will be encoded by a 2d array of characters.
Capital version of any character stands for "spawn multiple."

.  :  nothing (empty space)
#  :  wall
e  :  enemy spawn
r  :  rare enemy spawn
u  :  unique enemy spawn (i.e. crowd control enemy, enemies that are bad solo)
n  :  neutral mob spawn
!  :  Bossfight
$  :  shop (add this at the end)
c  :  coin (add this at the end)
@  :  player spawn
&  :  exit level / next level
p  :  physics object
q :  spiky physics object (damages player upon hit)
^  :  decoration area (grass, nice ground texture, etc)
l  :  large immovable structure (basically a solo wall, ie a pillar, tree, giant mushroom)
*  :  collectable artefact / trophy!!



(NYI:)
In order to spawn entities, the worldGen will pick a random
constructor function from the respective char table.
That constructor function will then be called and an
entity will be placed.


]]
local Ents = require("src.entities")
local WH = require("src.misc.worldGen.WH")
local rand = love.math.random

local enemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.devil]     = 0.2;
    [Ents.demon]     = 0.2;
    [Ents.mallow]    = 0.2;
    [Ents.enemy]     = 0.1;
    [Ents.boxenemy]  = 0.5;
    [Ents.splatenemy]= 0.1;
    [Ents.boxblob]   = 0.15;
    [Ents.trickblock]= 0.15
}


local bigEnemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.boxbully] = 1
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
        tier = 5;
        type="basic"
    }
end



return {
    type = 'basic',
    tier = 4,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.

    construct = function(wor,wmap,px,py)
        WH.zonenum(4,px,py)
        WH.lights(wor, wmap, 15, 500)
    end;

    ratioWin = function(cam_x, cam_y)
        ccall("apply", purge_fn, cam_x, cam_y)
        ccall("await", spawn_portal, 0, cam_x, cam_y)
        ccall("shockwave", cam_x,cam_y, 10,250,4,0.43)
    end;
    
    PROBS = {
            -- World generation:
            -- Probability of each character occuring.
            -- Each value is a weight and does not actually represent the probability.
            -- see `GenerationSys` for what character represents what.
            ["e"] = 0.4;
            ["E"] = 0.005;
            ["r"] = 0.02; -- 0.02 weight chance of spawning on random tile.
            ["R"] = 0.005;
            ["u"] = 0.01;
            ["U"] = 0.003;
            ["^"] = 0.8;
            ["l"] = 0.12;
            ["p"] = 0.3;
            ["P"] = 0.01;
            ["."] = 0.4
            -- Bossfights, artefacts, are done through special structure generator
            -- Walls, shops, player spawn, and player exit are done uniquely.
    }, -- Can modify the character probabilities by setting
                        -- this to a table. 

    entExclusionZones = nil, -- Can modify this table also.
                            -- See `defaultEntExclusionZones.lua`.

    enemies = {
        n = 34; n_var=2;
        bign = 2
    };

    entities = {
    ["#"] = { -- For wall entity.
        max = 999999, --No max.
        Ents.wall
    };

    ["e"] = {
        max = 200;
        function(x,y)
            for i=-1,rand(1,2) do
                local f = enemySpawns()
                f(x+(i-1)*40, y+(i-1)*40)
            end
        end
    };

    ["E"] = {
        max = 6;
        function(x,y)
            bigEnemySpawns()(x,y)
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
            if rand() < 0.15 then
                -- mwahahahah
                EH.Ents.trickblock(x,y)
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
                Ents.blue_mushroom(x+rand()*20,y+rand()*20)            
            else
                if rand() < 0.5 then
                    Ents.pine(x+rand()*20,y+rand()*20)
                else
                    Ents.mushroom(x+rand()*20, y+rand()*20)
                end
            end
        end
    }
}
}










