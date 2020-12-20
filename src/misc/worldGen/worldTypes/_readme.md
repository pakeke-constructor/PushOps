


## FILENAMES FOR WORLDS DON'T MATTER!


This is a set of files that denote how different world types should
be generated.


Note that each "world tile" is 64 x 64 !!!
This also means that walls must be 64 x 64.


Each char in the world generator refers to a different type of
entity. 
The worldType table's job is to provide a constructors to each
char in order for entities to be made.

There is also a `max` field that ensures that there are not too many
of one type of entity in the generated world.


worldTypes is a table of the form ::

```lua

{
    basic = {
        [1] = require("basic_T1"),
        [2] = require("basic_T2")
    },

    other = {
        [1] = require("other_T1"),
        [2] = require("other_T2")
    }
}

--  Note :::

--  It doesn't matter what the files are called in this directory!!!
--  All that matters is that each file is a worldType table,
--  and each worldType has the appropriate `tier` and `type` fields.
```




Each one of the worldType tables should be of the format :::

```lua
{
    type = 'basic'
    tier = 1
    structureRule = nil -- Use default structure rule for this tier.

    entExclusionZones = nil -- See below! (allows ents to specify spawn radiuses away from each other)
    

    ["#"] = { -- Ctor for wall entity.
        max = 999999, --No max.
        require("src.entities.wall") -- A function to construct a wall entity
    };


    -- Here is an example of a character tile that will produce multiple
    -- entities, scattered at random.
    --  Get used to using this!!!
    ["p"] = {
        max = 999999, --No max
        function(x, y)
            local block_ctor = require("src.entities.block")
            for i = 1, love.math.random(2,5) do
                block_ctor(
                    x + love.math.random(-10, 10),
                    y + love.math.random(-10, 10)
                )
            end
        end
    },

}
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

]]
```



"Exclusion zone tables" are set up to ensure
ents don't spawn too closely to each other.

For example, we can set up an exclusion table to ensure enemies
don't spawn around ["E"] spawn locations:
see example:
```lua
exclusionZones = {
    ["E"] = {
        ["e"] = 1, -- exclusion radius 1
        ["u"] = 1, -- exclusion radius 1
        ["E"] = 3 -- exclusion radius 3.
    };
    -- Likewise, we can ensure large structures don't spawn
    -- next to each other:
    ["l"] = {
        ["l"] = 1
    }
}
```
(please note that player spawn, walls, player exit, shop, etc are done 
such that exclusion zones should not need to be used for those spawns)

