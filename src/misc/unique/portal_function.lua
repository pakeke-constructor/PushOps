




local partition = require("src.misc.partition")
local ccall = Cyan.call
local rand = love.math.random

local BUF_TIME = 0.75 -- wait BUF_TIME seconds then spawn new world


-- We need a way to make player invincible during the windup.
-- Or else we are in for a world of hurt.

local genLevel = function(e)
    local dest = e.portalDestination or error("No portal destination given")
    ccall("switchWorld", {
        x = dest.x;
        y = dest.y;
        type = dest.type;
        tier = dest.tier
    })
end


local function regularShockwave(x,y, col)
    ccall("shockwave", x, y, 210, 40, 9, 0.4, col)
end


return function(portal, player)
    --[[
        creates new level with feedback
    ]]
    local R = 3
    player.hidden = true

    if (player.hp and player.hp.hp <= 0) then
        return --  cancel teleport, player is dead.
    end

    if player.hp then
        -- Make invulnerable; player is gonna be reset anyway.
        local hp = player.hp
        hp.max_hp = 0xfffffffffffffffffffffffffff
        hp.hp = 0xfffffffffffffffffffffffffff
    end
    
    ccall("sound", "boom")
    ccall("sound", "teleport",0.4)
    ccall("animate", "tp_up", 0,0,0, BUF_TIME/10, 1, nil, player, true)
    -- TOOD: play a sound here
    for i=0, R-2 do
        ccall("await", regularShockwave, (i-1)*(BUF_TIME/R),
                portal.pos.x, portal.pos.y - portal.pos.z/2, {0.05,0.3,0.3})
    end
    ccall("await", genLevel, BUF_TIME+0.05, portal) -- wait  seconds
end


