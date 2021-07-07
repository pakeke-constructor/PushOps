


local atlas = require( "assets.atlas" )

local Quads = atlas.Quads

local walls = {
    --[[
        These wall sprites are sorted by height.

        wall<H>_<t>

        <H> represents the relative height, 1-4
        <t> represents the wall variation
    ]]
    {Quads.wall1_1, Quads.wall1_2},

    {Quads.wall2_1, Quads.wall2_2},
    
    {Quads.wall3_1, Quads.wall3_2},
    
    {Quads.wall4_1, Quads.wall4_2}
}

--[[
Height boundary for walls:

0.7 to 1

(some walls will have lower heights because they are 
part of a structure. If a height is less than 0.7, just set them to height3
or something )

]]


local _,_,w,h = walls[1][1]:getViewport()
local shape = love.physics.newRectangleShape(w/1.3,h/2)

local ccall = Cyan.call


local WALL_HP = 200;
local WALL_DMG_RANGE = 80


local dist = Tools.dist

local function onBoom(e, x,y, strength)
    local p=e.pos
    if strength > 0 and dist(x-p.x, y-p.y)<WALL_DMG_RANGE then
        ccall("emit", "wallbreak", e.pos.x, e.pos.y, e.pos.z, 4)
        ccall("damage",e,101)
    end
end

local rand = love.math.random

local function spawnFunc(p)
    for i=1,rand(1,2) do
        EH.Ents.block(p.x + rand(-20,20), p.y + rand(-20,20))
    end 
end

local function onDeath(e)
    ccall("emit", "wallbreak", e.pos.x, e.pos.y, e.pos.z, 10)
    ccall("await", spawnFunc, 0, e.pos)
end



return function(x,y, height) -- I hate taking xtra params like this!! ahhh spagetti code
    local quad
    height = height or 1
    if height < 0.7 then
        -- Then its part of a structure
        quad = Tools.rand_choice(walls[3])
    else
        -- Then we randomly select.
        height = (math.max(math.min(height, 0.98), 0.7) - 0.7) / 0.3
        height = math.ceil(height * 4)
        if not walls[height] then
            print("AHH: height  ", height)
        end
        quad = Tools.rand_choice(walls[height])
    end

    local wall = Cyan.Entity( )
    :add("pos", math.vec3(x,y,20))
    :add("image",{quad=quad})-- {quad = Tools.rand_choice(walls)})
    :add("physics", {
        body = "static";
        shape = shape
    })
    :add("hp",{
        hp=WALL_HP;
        max_hp=WALL_HP
    })
    --:add("colour",CONSTANTS.grass_colour)
    :add("onBoom",onBoom)
    :add("onDeath",onDeath)
    :add("targetID","static")

    return wall
end




