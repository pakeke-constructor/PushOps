
--[[

this entity has a special field:
toggleFunction

]]

local quadStates = {
    [false] = "button_inactive";
    [true] = "button_active"
}

local colourStates = {
    [true]  = {0.5, 0.5, 0.5};
    [false] = {0.8, 0.8, 0.8}
}

local SIZE = 50

local function toggleFunction(e, player, type)
    if type == "push" then
        -- Toggle the button
        if e.toggleFunction then
            local new = e:toggleFunction(player, type)
            e.image.quad = EH.Quads[quadStates[new]]
            e.colour = colourStates[new]
            ccall("sound", "unlock",1,2)
            return true
        end
    end
end






return function(x, y, on_state)
    -- on_state is true/false, 
    -- whether button is on or off.
    
    --[[

    These entities have a private "toggleFunction" component
    that is enacted when the button activates.

    Whatever the toggle function returns will become the new 
        "on" or "off" state.

    ]]
    
    return EH.PHYS(Cyan.Entity(), 10, "static")
    :add("pos", math.vec3(x,y,0))
    :add("image", { quad = EH.Quads[quadStates[on_state]]})
    :add("targetID", "interact")
    :add("size", SIZE)
    :add("colour", colourStates[on_state])
    :add("onInteract", toggleFunction)
end



