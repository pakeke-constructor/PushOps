
--[[

Totem
gain 2 dark red block orbitals around you

]]

local COL = {77/255, 132/255, 150/255}
local radius = 45

local ORBIT_SPEED = 4

local tau = math.pi * 2
local sin, cos = math.sin, math.cos

local cexists = Cyan.exists

local function block(x,y)
    local block = EH.Ents.block(x,y)
    block.colour = COL
    block.physicsImmune = true
    block.pushable = false
    return block
end


local blocks = {}


local tick = 0


return {
    load = function(player)
        blocks[1] = block(player.pos.x + 45, player.pos.y)
        blocks[2] = block(player.pos.x - 45, player.pos.y)
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
            if blocks[1] and blocks[2] and 
                 cexists(blocks[1]) and cexists(blocks[2]) then
                ccall("setPos", blocks[1], px + x, py + y)
                ccall("setPos", blocks[2], px - x, py - y)
            end
        end
    end;

    description = "Defensive orbitals"
}

