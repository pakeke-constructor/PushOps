



return function(x,y)
    --[[
        entity to keep the camera on the player's death position,
    until the level has reset.
    ]]

    --TODO:
    -- add an image for this
    return EH.PV(Cyan.Entity(),x,y)
    :add("_control_dummy", true) -- this entity does not count as a player
    :add("hp", {
        hp=0;max_hp=100
    })
    :add("speed",{
        speed=0;
        max_speed=0
    })
    :add("control",{
        canPush = false;
        canPull = false;
    })
end


