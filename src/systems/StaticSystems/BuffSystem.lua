

local BuffSystem = Cyan.System("buff")
--[[

TODO:::: NEEDS TESTING!!

In charge of buffing and debuffing ents.


buff component:


    buff = {
        buffs = {"speed", "strength"}

        speed = 30 -- 30 seconds left for speed
        strength = 15.32
    }



]]



local Buffs = require("src.misc.buffs")




function BuffSystem:buff(e, type, time, a1,a2,a3,a_ER)
    --[[

        buff( e, buff_type, time, ... )

    ]]
    
    if not Buffs[type] then
        error("Unknown buff type: "..tostring(type))
    end

    if a_ER then
        error("too many args used, add an xtra one in BuffSystem")
    end

    if not e:has("buff") then
        e:add("buff", {
            [type] = time;
            buffs = {type}
        })
    end

    Buffs[type].buff(e, a1, a2, a3)
end



local function debuff(e, bufftype, i)
    table.remove(buff.buffs, i)
    buff[bufftype] = nil
    Buffs[bufftype].debuff(e)

    if #buff.buffs <= 0 then
        -- entity has no more buffs left.
        -- remove from system
        ent:remove("buff")
    end
end



function BuffSystem:debuff(e, type)
    if self:has(e) then
        local buffs = e.buff.buffs
        for i=1, #buffs do
            if buffs[i] == type then
                debuff(e, type, i)
            end
        end
    end
end




local function update(e,dt)
    local buff = ent.buff
        
    for i, bufftype in ipairs(buff.buffs) do

        if buff[bufftype] then
            -- if time is nil, we assume its infinite buff

            buff[bufftype] = buff[bufftype] - dt
            if buff[bufftype] < 0 then
                debuff(ent, bufftype, i)
            end
        end
    end
end



function BuffSystem:update(dt)
    for _,ent in ipairs(self.group) do
        update(ent, dt)
    end
end


