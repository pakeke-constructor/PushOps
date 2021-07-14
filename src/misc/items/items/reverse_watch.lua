
--[[

<Reverse> pocket watch
    Moob'ing near enemies slows them down  (not bosses)

]]



local MAX_DIST = 50
local MAX_SLOW = 0.6 -- 60% slow

local max = math.max

local function func(ent, x, y)
    if ent.speed then
        -- Slows up to 60%

        local pos = ent.pos
        local ratio = max(0, (50 - Tools.dist(pos.x - x, pos.y - y))/50) * MAX_SLOW

        local spd = ent.speed
        spd.speed = spd.speed * (1-ratio)
        spd.max_speed = spd.max_speed * (1-ratio)
    end
end


return {

    moob = function(player, x, y, strength)
        local pos = player.pos
        if pos then
            if Tools.dist(pos.x-x, pos.y-y) < 0.5 then
                -- Then the boom is likely the player's
                ccall("apply", func, x, y, "enemy")
            end
        end
    end

}

