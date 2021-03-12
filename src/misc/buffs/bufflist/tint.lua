

local oldColours = setmetatable({
    -- [ ent ] = colour
},{__mode="k"})



local cexists = Cyan.exists



return {
    buff = function(e, col)
        oldColours[e] = e.colour
        e.colour = col
    end;

    debuff = function(e)
        local col = oldColours[e]
        if not col then
            -- either the ent has been GC'd, 
            -- OR the ent had no colour to begin with.
            -- default to white
            col = {1,1,1,1}
        end

        if cexists(e) then
            e.colour = col
        end
    end
} 


