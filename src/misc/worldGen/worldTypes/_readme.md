


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
    
    probs = {
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
    },

    enemies = {
        n = 10; -- spawn 10 'e's
        n_var = 1; --   10 e's, +- 1.
        
        bign = 1; -- spawn 1 'E'.
        bign_var = 1 -- 1 'E', +- 1.
    }

    entities = {
    ["#"] = { -- Ctor for wall entity.
        max = 999999, --No max.
        require("src.entities.wall") -- A function to construct a wall entity
    };


    -- Here is an example of a character tile that spawns 2 blocks
    --  Get used to using this!!!
    ["p"] = {
        max = 999999, --No max
        function(x, y)
            EH.Ents.block(x,y)
            EH.Ents.block(x+5, y+5)
        end
    }
    }

    voidWin = function(cam_x, cam_y) end -- no more enemies left
    ratioWin = function(cam_x, cam_y) end -- win by ration (see WinSys)
        -- these callbacks are invoked when
    bossWin = function(cam_x, cam_y) end

    -- TODO: Make a default function for this!!!
    lose = function(cam_x, cam_y) end -- when the player dies

}

--[[

World map will be encoded by a 2d array of characters. (strings)
Capital version of any character stands for "spawn multiple."

If brackets are used, that means "spawn everything inside the brackets."
i.e. '(pqe)' means spawn physics object, spiky object, and enemy


.  :  nothing (empty space)
#  :  wall
%  :  An invincible wall
~  :  A decoration entity to be placed outside border
e  :  enemy spawn
r  :  rare enemy spawn
u  :  unique enemy spawn (i.e. crowd control enemy, enemies that are bad solo)
n  :  neutral mob spawn
!  :  Bossfight
$  :  shop (add this at the end)
c  :  coin (add this at the end)
@  :  player spawn
&  :  portal
p  :  physics object
q :  spiky physics object (damages player upon hit)
^  :  decoration area (grass, nice ground texture, etc)
l  :  large immovable structure (basically a solo wall, ie a pillar, tree, giant mushroom)
*  :  collectable artefact / trophy!!
+  :  light

]]


```

