
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call

local Entity = Cyan.Entity

local DISTANCE = 11 -- The distance between worm nodes


local MIN_LEN = 10
local MAX_LEN = 20 -- min and max lengths for worm.



local rocks = {}
for x=1,4 do
    local quad_name = 'rock' .. tostring(x)
    table.insert(rocks, Quads[quad_name])
end


local function onDetatch(e)
    -- yeah just kill em
    ccall("kill",e)
end


local function wormNodeCtor(e)
    local new = Entity()
    local epos=e.pos
    new.pos = math.vec3(epos.x,epos.y,epos.z)
    new.vel = math.vec3(0,0,0)
    new.follow = {
        following = e;
        distance = DISTANCE;
        onDetatch = onDetatch
    }
    new.image = Tools.rand_choice(rocks)
    return new
end



--local Tree = EH.Node("_worm behaviour tree")

--[[

tree planning :===>>>

We want worm to dig underground and jump towards player from a `random` position.

So perhaps change moveBehaviour state to `rand`? Or should we just TP using `setPos`


IDEA ==>
Use Tools.isIntersect() to find an adequate path for the worm to jump.
TP worm to that position and jump the gap

But what move behaviour do we use here???????????
TODO:::: Think about this!!!!!
]]



local rand = love.math.random



return function(x,y)
    local e = Entity()
    EH.PV(e,x,y)

    local len = math.floor(love.math.random(MIN_LEN, MAX_LEN))
    
    -- Create big chain of worm nodes.
    local last = e
    for x=1,len do
        last = wormNodeCtor(last)
    end

    e.speed = {
        speed = 230 + rand()*50;
        max_speed = 270 + rand()*50
    }

    e.behaviour = {
        --tree = Tree;
        move = {
            id="player";
            type="LOCKON";
        }
    }
end

