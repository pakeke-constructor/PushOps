


--[[

This is the better looking text format that (should) be used
very thouroughly throughout the project, simply
because it looks way way better.

]]


return function(x,y,z, text, colour, fade)
    --[[
        this spawns 2 entities at once.
        One text entity, and another text entity with half the colour
        behind it. 
    ]]
    assert(text and type(text)=="string", "goodtxt.lua: not given txt string properly")
    assert(colour and type(colour)=="table", "goodtxt.lua: not given colour table properly")
    local back_txt = Cyan.Entity()
    if not z then
        back_txt:add("pos",math.vec3(x+1,y+24,-50)) -- default z pos -50
    else
        back_txt:add("pos",math.vec3(x+1,y-1-(z/2),z))
    end
    back_txt:add("text",text)
    :add("colour", {colour[1]/2,colour[2]/2,colour[3]/2})
    

    local front_txt = Cyan.Entity()
    if not z then
        front_txt:add("pos",math.vec3(x,y+25,-50)) -- default z pos -50
    else
        front_txt:add("pos",math.vec3(x,y-(z/2),z))
    end
    front_txt:add("text", text)
    :add("colour",table.copy(colour))--memory unique copy is pretty essential here
            -- due to potential of `textfade` component
    
    if fade then
        back_txt.fade = fade
        front_txt.fade = fade
    end

    return nil -- This isnt an entity!!!
end






