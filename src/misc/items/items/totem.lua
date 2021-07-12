
--[[

Totem
gain 2 dark red block orbitals around you

]]

local RED = {0.65,0,0}
local radius = 45

local ORBIT_SPEED = 4

local tau = math.pi * 2
local sin, cos = math.sin, math.cos

local cexists = Cyan.exists

local function block(x,y)
    local block = EH.Ents.block(x,y)
    block.colour = RED
    block.physicsImmune = true
end


local blocks = {}


local tick = 0


return {
    load = function(player)
        table.insert(blocks, block(player.pos.x + 45, player.pos.y))
        table.insert(blocks, block(player.pos.x - 45, player.pos.y))
    end;

    reset = function(player)
        blocks = {}
    end;

    update = function(player, dt)
        if cexists(player) then
            tick = (tick - dt*4) % (tau)

            local x = radius * sin(tick)
            local y = radius * cos(tick)

            local px, py = player.pos.x, player.pos.y
            ccall("setPos", block[1], px + x, py + y)
            ccall("setPos", block[2], px - x, py - y)
        end
    end
}

