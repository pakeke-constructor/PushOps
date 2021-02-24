

local HealthSys = Cyan.System("hp")

local ccall = Cyan.call


local DEFAULT_IFRAMES = 0 -- default invincibility of 0 seconds
                    -- (Just so we can get lovely chain reaction :booms going :p)



local function checkDead(ent)
    if ent.hp.hp <= 0 then
        ccall("dead", ent)
    end
end


function HealthSys:dead(ent)
    --[[
        NOTE that the entity doesn't need to have HP for this
        callback to come into effect.
    ]]
    if ent.onDeath then
        ent:onDeath()
    end

    ent:delete()
end

HealthSys.kill = HealthSys.dead



function HealthSys:added( ent )
    local hp = ent.hp

    if not hp.regen then -- default 0.
        hp.regen = 0
    end

    if not hp.iframe_count then
        -- invincibility frame counter.  <0 means that the ent isnt invincible.
        hp.iframe_count = -.1
    end
end


--[[

-- Should we do health bars, or will it add too much clutter??


local Atlas = require("assets.atlas")
local mob_hp_bars = {}
for i=1,20 do 
    local mob_hp_bar_str = "mob_hp_"..tostring(i)
    if Atlas.Quads[mob_hp_bar_str] then
        table.insert(mob_hp_bars, Atlas.Quads[mob_hp_bar_str])
    end
end


local getColour, setColour = love.graphics.getColor, love.graphics.setColor

function HealthSys:drawEntity(e)
    if self:has(e) then
        local hp = e.hp
        if hp.draw_hp and hp.hp < hp.max_hp then
            local r,g,b,a = getColour()
            setColour(1,0.2,0.2)

            local ratio = hp.hp / hp.max_hp
            local index = math.ceil((#mob_hp_bars) * ratio)
            local pos = e.pos
            local draw = e.draw
            assert(draw,"??")

            Atlas:draw(mob_hp_bars[index], pos.x, pos.y - pos.z/2,
                        0, 1, 1, draw.ox, draw.oy)

            setColour(r,g,b,a)
        end
    end
end
]]


function HealthSys:damage(ent, amount)
    if self:has(ent) and ent.hp.iframe_count < 0 then
        local hp = ent.hp
        hp.hp = hp.hp - amount

        if ent.onDamage then
            ent:onDamage(amount)
        end
        
        hp.iframe_count = hp.iframe_count + (hp.iframes or DEFAULT_IFRAMES)
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





function HealthSys:hit( ent, hitting_ent, hit_amount )
    if (ent.toughness or 0) < (hitting_ent.toughness or 0) then
        HealthSys:damage( ent, hit_amount )
    end
end






function HealthSys:update(dt)
    for _, ent in ipairs(self.group )do
        checkDead(ent)
        local hp = ent.hp
        if hp.regen then
            hp.hp = hp.hp + (hp.regen * dt)
        end
        if hp.iframe_count > 0 then
            hp.iframe_count = hp.iframe_count - dt  -- reduce iframes
        end
    end
end

