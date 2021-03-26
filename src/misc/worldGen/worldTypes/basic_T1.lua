
--[[

TYPE :: 'basic'

tier :: T1 :: 1


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
local rand = love.math.random

local enemySpawns = Tools.weighted_selection{
    [Ents.enemy]    = 0.5;
    [Ents.mallow]   = 0.3;
    [Ents.boxenemy] = 0.2;
    [Ents.blob]     = 0.3;
    [Ents.boxblob]  = 0.2;
    [Ents.ghost]    = 0.1
}

local bigEnemySpawns = Tools.weighted_selection{
    [Ents.bully] = 0.8;
    [Ents.ghost_squad] = 0.2;
    [function(x,y)
        for i=-1,0 do
            Ents.devil(x+(i*15), y+(i*15))
        end
    end] = 0.5
}

return {
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
    }, -- Can modify the char probabilities by setting
                        -- this to a table. 

    entExclusionZones = nil, -- Can modify this table also.
                            -- See `defaultEntExclusionZones.lua`.

    entities = {
    ["#"] = { -- For wall entity.
        max = 999999, --No max.
        Ents.wall
    };

    ["e"] = {
        max = 200;
        function(x,y)
            for i=1, rand(2,3) do
                local f = enemySpawns()
                f(x,y)
            end
        end
    };

    ["E"] = {
        max = 10;
        bigEnemySpawns
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
    }
}
}











