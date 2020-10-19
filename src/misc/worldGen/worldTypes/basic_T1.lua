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
local Ents = require("src.entities._ENTITIES")

return {
    type = 'basic',
    tier = 1,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.

    probabilities = nil, -- Can modify the character probabilities by setting
                        -- this to a table. 

    entities = {
    ["#"] = { -- For wall entity.
        max = 999999, --No max.
        Ents.wall
    };

    ["p"] = {
        max = 999999, --No max
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, love.math.random(2,5) do
                block_ctor(
                    x + love.math.random(-10, 10),
                    y + love.math.random(-10, 10)
                )
            end
        end
    };

    ["P"] = {
        max = 3, -- Max spawns :: 3
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, love.math.random(8,9) do
                block_ctor(
                    x + love.math.random(-32, 32),
                    y + love.math.random(-32, 32)
                )
            end
        end
    }}

}










