
--[[

<Reverse> pocket watch
    Moob'ing near enemies slows them down  (not bosses)

]]



local MAX_DIST = 100
local MAX_SLOW = 0.15 -- 15% slow

local max = math.max

local slowedEnts = setmetatable({},{__mode="kv"})



local function func(ent, x, y)
    if ent.speed and (not slowedEnts[ent]) then
        -- Slows up to 60%

        local pos = ent.pos
        local ratio = max(0, (MAX_DIST -
                        Tools.dist(pos.x - x, pos.y - y))/MAX_DIST) * MAX_SLOW

        if ratio > 0.002 then
            local spd = ent.speed
            spd.speed = spd.speed * (1-ratio)
            spd.max_speed = spd.max_speed * (1-ratio)

            ccall("animate", "time", 0, 0, 30, 0.12, 9, nil, ent)
            slowedEnts[ent] = true
        end
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

