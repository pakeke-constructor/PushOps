


local dist = Tools.dist
local WALL_DMG_RANGE = 80

local COL = {0.9,0.4,0.4}


local function onBoom(e, x,y, strength)
    local p=e.pos
    if strength > 0 and dist(x-p.x, y-p.y) < WALL_DMG_RANGE then
        ccall("emit", "wallbreak", e.pos.x, e.pos.y, e.pos.z, 4, COL)
        ccall("damage",e,101)
        ccall("sound","crumble",0.5)
    end
end





return function (x, y, height)
    local swall = EH.Ents.wall(x,y,height)
    swall.colour = COL
    swall.onBoom = onBoom
    swall.hp.hp = math.huge
    swall.hp.max_hp = math.huge
end


