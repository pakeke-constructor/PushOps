
--[[

NOT TO BE INSTANTIATED BY WORLDGEN!

This ent works alongside worms.
It should ONLY be instantiated by worm entities, nothing else!




TODO :
Make it so the hearts gravitate towards the center of the worm,
or orbit around it or something

]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
local cexists = Cyan.exists



local BIND_COLOUR = {0.6, 0.03, 0.08, 0.2}

local N_BINDINGS = 5




local spd_cmp = {
    speed = 80;
    max_speed = 90
}


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
        if not node.hidden then
            drawLine(ent.pos.x, ent.pos.y - ent.pos.z/2, n_pos.x, n_pos.y - n_pos.z/2)
        end
    end
    setColour(r,g,b,a)
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

    local iterL = #pnodes / (2+2*rand())

    if len == 0 then return end

    for _=1, iterL do
        worm_nodes[index] = rand_choice(pnodes)
        index = (index % len) + 1
    end

    ent._node_index = index
end






local collisions = {
    physics = physColFunc
}


local function rem(tab, e)
    for i,v in ipairs(tab) do
        if v == e then
            table.remove(tab, i)
            return
        end
    end
end


local function onDeath(e)
    --[[
        put particles and stuff here, yada
    ]]
    for i=1,#e._bound_nodes do
        e._bound_nodes[i] = nil -- easier on GC
    end

    local parent = e._parent
    rem(parent._hearts, e)

    if #parent._hearts <= 0 then
        -- worm is out of hearts. kill it
        ccall("kill",parent)
    end
end

local quad_arr
do
    quad_arr = {3,2,1,1}
    for i,ii in ipairs(quad_arr)do
        quad_arr[i] = Quads["heart"..tostring(ii)]
    end
end



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

    assert(parent._nodes, "All worms must have `ent._nodex` for the wormhearts to bind to")
    assert(parent._hearts, "All worms must have `ent._hearts` for the hearts to reside in")

    table.insert(parent._hearts, e)

    e._parent = parent -- private member
    e._bound_nodes = { } -- a list of worm nodes that the wormheart is currently observing.
    
    e._num_bindings = math.min(N_BINDINGS, #parent._nodes) -- cap at length of parent

    e._node_index = 0 -- the index in _bound_nodes that was last changed by
    --`chooseNewNodes()`.

    e.targetID = "enemy"

    e.hp = {
        hp = 1000;
        max_hp=1000
    }

    e.onDeath = onDeath

    e.animation = {
        frames = quad_arr;
        interval = 0.13;
        current = 0
    }

    e.collisions = collisions

    e.speed = spd_cmp

    e.behaviour = {
        move = {
            id = "enemy";
            type='ORBIT';
            orbit_tick = rand()*6.2;
            orbit_radius = 25;
            orbit_speed = 0.4
        }
    }

    e.behaviour.move.target_ent = parent

    EH.BOB(e, 0.18)

    EH.PHYS(e, 13)

    e.hybrid=true
    e.onDraw = onDraw
    e.onHeavyUpdate = chooseNewNodes
end




