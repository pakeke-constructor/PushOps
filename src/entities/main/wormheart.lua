
--[[

NOT TO BE INSTANTIATED BY WORLDGEN!

This ent works alongside worms.
It should ONLY be instantiated by worm entities, nothing else!


]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
local cexists = Cyan.exists


local BIND_COLOUR = {0.6, 0.03, 0.08, 0.4}

local N_BINDINGS = 12



local function physColFunc(e1, e2, speed)
    if EH.PC(e1,e2,speed)then
        -- make the worm nodes spit out particles, make a sound etc.
    end
end


local drawLine = love.graphics.line
local setColour = love.graphics.setColor
local getColour = love.graphics.getColor


local function onDraw(ent)
    local r,g,b,a = getColour()
    setColour(BIND_COLOUR)
    for _,node in ipairs(ent._bound_nodes) do
        local n_pos = node.pos
        drawLine(ent.pos.x, ent.pos.y - ent.pos.z/2, n_pos.x, n_pos.y - n_pos.z/2)
    end
    setColour(r,g,b,a)
end


local function onDeath(ent)
    for i=1,#ent._bound_nodes do
        ent._bound_nodes[i] = nil -- easier on GC
    end

    --[[
        play sound and stuff, etc

        TODO: How are we going to communicate to the worm ent
        when all hearts are dead?
        Perhaps the worm ent should have a `lives` counter to check how many lives
        they have left.
        Or perhaps an `_onHeartDeath` function exclusive to the worm that is called
        when this heart dies.
        idk. do planning
    ]]
end


local rand_choice = Tools.rand_choice

local function chooseNewNodes(ent,dt)
    --[[
        randomly chooses new worm nodes
    ]]
    local pnodes = ent._parent._nodes
    local index = ent._node_index
    local len = ent._num_bindings
    local worm_nodes = ent._bound_nodes

    for _=1, #pnodes / (2 + 2*rand()) do
        worm_nodes[index] = rand_choice(pnodes)
        index = (index % len) + 1
    end
    ent._node_index = index
end






local collisions = {
    physics = physColFunc
}





local er1 = "This entity is not supposed to be instantiated by worldGen!"


return function(parent, sanity_check)
    --[[
        Notice that this function does not take in (x,y) as initial
        params. This is because this entity will NEVER (or, should never) be
        instantiated akin to other entities. It should only be instantiated
        inside a worm entity ctor
    ]]
    if sanity_check then
        error(er1)
    end

    local e = Cyan.Entity()
    EH.PV(e, parent.pos.x + 50*(rand()-0.5), parent.pos.y + 50*(rand()-0.5))

    assert(parent._nodes, "All worms must have nodes for the wormhearts to bind to")

    e._parent = parent -- private member
    e._bound_nodes = { } -- a list of worm nodes that the wormheart is currently observing.
    
    e._num_bindings = math.min(N_BINDINGS, #parent._nodes) -- cap at length of parent

    e._node_index = 0 -- the index in _bound_nodes that was last changed by
    --`chooseNewNodes()`.

    e.targetID = "enemy"

    e.image = {
        quad = Quads.NYI
    }

    e.collisions = collisions

    EH.BOB(e, 0.18)

    EH.PHYS(e, 13)

    e.hybrid=true
    e.onDraw = onDraw
    e.onHeavyUpdate = chooseNewNodes
end




