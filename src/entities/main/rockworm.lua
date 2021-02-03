
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call

local Entity = Cyan.Entity

local FRAME_GAP = 11 -- The frame gap between following worm nodes.

local MIN_LEN = 5
local MAX_LEN = 13 -- min and max lengths for worm.


local rocks = {}
for x=1,10 do
    local quad_name = 'rock' .. tostring(x)
    if Quads[quad_name] then
        table.insert(rocks, Quads[quad_name])
    end
end



local function wormNodeCtor(e)
    local new = Entity()
    local epos=e.pos
    
    new.pos = math.vec3(epos.x,epos.y,epos.z)
    new.follow = {
        following = e;
        frameGap = FRAME_GAP
    }
    new.image = Tools.rand_choice(rocks)

    return new
end



local Tree = EH.Node("_worm behaviour tree")
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







return function(x,y)
    local e = Entity()
    e.PV(e,x,y)

    local len = math.floor(love.math.random(MIN_LEN, MAX_LEN))
    
    -- Create big chain of worm nodes.
    local last = e
    for x=1,len do
        last = wormNodeCtor(last)
    end

    e.speed = {
        speed = 170;
        max_speed = 200
    }

    e.behaviour = {
        tree = Tree;
        move = { }
    }
end

