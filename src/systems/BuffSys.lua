

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



local Buffs = require("src.misc.buffs.buffs")




function BuffSystem:buff(ent, buffType, time, a1,a2,a3,a_ER)
    --[[

        buff( ent, buff_type, time, ... )

    ]]
    if not Buffs[buffType] then
        error("Unknown buff type: "..tostring(buffType))
    end

    if a_ER then
        error("too many args used, add an xtra one in BuffSystem")
    end

    if type(time)~="number" then
        error("time parameter was not number. got: "..type(time))
    end

    if (not ent:has("buff")) then
        ent:add("buff", {
            [buffType] = time;
            buffs = {buffType}
        })
        Buffs[buffType].buff(ent, a1, a2, a3)
    elseif not ent.buff[buffType] then
        Buffs[buffType].buff(ent, a1, a2, a3)
        table.insert(ent.buff.buffs, buffType)
        ent.buff[buffType] = time
    else
        -- else- it either already has the buff.
        -- can't buff twice, but we can increase the time tho.
        ent.buff[buffType] = math.max(ent.buff[buffType], time)
    end
end



local function debuff(ent, bufftype, i)
    local buff = ent.buff
    table.remove(buff.buffs, i)
    buff[bufftype] = nil
    assert(Buffs[bufftype].debuff,"?????")
    Buffs[bufftype].debuff(ent)

    if #buff.buffs <= 0 then
        -- entity has no more buffs left.
        -- remove from system
        ent:remove("buff")
    end
end



function BuffSystem:debuff(ent, btype)
    if self:has(ent) then
        local buffs = ent.buff.buffs
        for i=1, #buffs do
            if buffs[i] == btype then
                debuff(ent, btype, i)
            end
        end
    end
end





local function update(ent,dt)
    local buff = ent.buff
    for i, bufftype in ipairs(buff.buffs) do
        assert(buff[bufftype], "????????????")
        buff[bufftype] = buff[bufftype] - dt
        if buff[bufftype] < 0 then
            debuff(ent, bufftype, i)
        end
    end
end



function BuffSystem:update(dt)
    for _,ent in ipairs(self.group) do
        update(ent, dt)
    end
end


