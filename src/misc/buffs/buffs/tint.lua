

local oldColours = setmetatable({
    -- [ ent ] = speed_change
},{__mode="kv"})



local cexists = Cyan.exists




return {
    buff = function(e, colour)
        oldColours[e] = e.colour
        e.colour = colour
    end;

    debuff = function(e)
        local col = oldColours[e]
        if not col then
            return -- oh no! anyway
            -- (the ent must have been deleted, doesnt hurt to double check tho)
        end

        if cexists(e) then
            e.colour = col
        end
    end
} 


