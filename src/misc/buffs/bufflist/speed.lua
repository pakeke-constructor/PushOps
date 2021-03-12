

local speedChanges = setmetatable({
    -- [ ent ] = speed_change
},{__mode="kv"})


local cexists = Cyan.exists


return {
    buff = function(e, amount)
        speedChanges[e] = amount
        local spd = e.speed;
        -- Just give it a whole new table. Its (probably) very safe
        -- (definitely safer than alternative anyway lol)
        e.speed = {
            speed = spd.speed + amount,
            max_speed = spd.max_speed + amount
        }
    end;

    debuff = function(e)
        local am = speedChanges[e]
        if not am then
            return
        end

        if cexists(e) then
            e.speed.max_speed = e.speed.max_speed - am
            e.speed.speed = e.speed.speed - am
        end
    end
} 


