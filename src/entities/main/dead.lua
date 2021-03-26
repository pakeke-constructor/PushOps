



return function(x,y)
    --[[
        entity to keep the camera on the player's death position,
    until the level has reset.
    ]]

    --TODO:
    -- add an image for this
    return Cyan.Entity()
    :add("pos",math.vec3(x,y,0))
    :add("control",{
        canPush = false;
        canPull = false;
    })
end


