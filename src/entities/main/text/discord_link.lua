
--[[
    Discord link entity
    ]]



local FNAME = "src/misc/unique/discord_link.txt"
local fdat, err
fdat, err = love.filesystem.read(FNAME)
if not fdat then
    error(err)
end

local DISCORD_LINK = fdat



local function onInteract(e, interacting, type)
    if type == "push" then
        love.system.setClipboardText(DISCORD_LINK)
        ccall("message", interacting.pos.x, interacting.pos.y,
            "Discord Link Copied!", 3, {0.5,1,1})
        
        ccall("sound", "unlock",1,2)
        return true
    end
end


return function(x,y)
    --[[
        this spawns 2 entities at once.
        One text entity, and another text entity with half the colour
        behind it. 
    ]]
    local text = "(Press > for link)"
    local colour = {0.5,1,1}
    local fade = 250
    assert(text and type(text)=="string", "goodtxt.lua: not given txt string properly")
    assert(colour and type(colour)=="table", "goodtxt.lua: not given colour table properly")
    local back_txt = Cyan.Entity()

    local z
    if not z then
        back_txt:add("pos",math.vec3(x+1,y+24,-50)) -- default z pos -50
    else
        back_txt:add("pos",math.vec3(x+1,y-1-(z/2),z))
    end
    back_txt:add("text",text)
    :add("colour", {colour[1]/2 - 0.2,colour[2]/2 - 0.2,colour[3]/2 - 0.2})
    
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

    back_txt.size = 100
    back_txt.onInteract = onInteract
    back_txt.targetID = "interact"

    return nil -- This isnt an entity!!!
end






