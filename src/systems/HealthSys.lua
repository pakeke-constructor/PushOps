





local HealthSys = Cyan.System("hp")


local ccall = Cyan.call

local function checkDead(ent)
    if ent.hp.hp <= 0 then
        ccall("dead", ent)
    end
end




function HealthSys:added( ent )
    local hp = ent.hp

    if not hp.regen then -- default 0.
        hp.regen = 0
    end
end


function HealthSys:damage(ent, amount)
    if self:has(ent) then
        local hp = ent.hp
        hp.hp = hp.hp - amount
        checkDead(ent)
    end
end


function HealthSys:heal(ent, amount)
    if self:has(ent) then
        local hp = ent.hp
        hp.hp = hp.hp + amount
        checkDead(ent)
    end
end




function HealthSys:update(dt)
    for _, ent in ipairs(self.group )do
        checkDead(ent)
    end
end

