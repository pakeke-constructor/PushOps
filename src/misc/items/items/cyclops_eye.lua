

--[[

Cyclops eye
    Removes fade component from all entities in a certain
    radius, when boom is used
    If a entity with fade is found, a purple shockwave is shot out

]]

local PURPLE = {0.43,0,0.52}


local function removeFade(ent)
    ent:remove("fade")
    ent.minFade = nil
    ccall("animate", "blink", 0, 0, 30, 0.12, 9, nil, ent)
end


local function func(ent, x, y)
    if ent.fade then
        local pos = ent.pos
        local dist = Tools.dist(pos.x-x, pos.y-y)
        ccall("await", removeFade, dist / 300, ent)
    end
end


return {

    moob = function(player, x, y, strength)
        local pos = player.pos
        if pos then
            if Tools.dist(pos.x-x, pos.y-y) < 0.5 then
                -- Then the boom is likely the player's
                ccall("apply", func, x, y)
                ccall("shockwave", pos.x, pos.y,
                        30, 150, 4, 0.4, table.copy(PURPLE))
            end
        end
    end
}


