

local WALL_HP = 200;
local WALL_DMG_RANGE = 80

local COLOUR = {0.63,0,0.82}


local dist = Tools.dist

local function onBoom(e, x,y, strength)
    local p=e.pos
    if strength > 0 and dist(x-p.x, y-p.y)<WALL_DMG_RANGE then
        ccall("emit", "wallbreak", e.pos.x, e.pos.y, e.pos.z, 4, COLOUR)
        ccall("damage",e,101)
    end
end


local rand = love.math.random

local function spawnFunc(p)
    for i=1,rand(1,2) do
        EH.Ents.spookyblock(p.x + (rand()-0.5)*30, p.y + (rand()-0.5)*30)
    end 
end

local function onDeath(e)
    ccall("emit", "wallbreak", e.pos.x, e.pos.y, e.pos.z, 10, COLOUR)
    ccall("await", spawnFunc, 0, e.pos)
end



return function(x,y)
    local wall = EH.Ents.wall(x,y)
    wall.colour = COLOUR
    wall.onDeath = onDeath
    wall.onBoom = onBoom
    return wall
end




