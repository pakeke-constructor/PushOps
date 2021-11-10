


local TextSys = Cyan.System("text", "pos")
--[[

Responsible for spawning block letter text, 
rendering temporary messages,
and drawing text above entities.


]]



local LETTER_WIDTH = 28

local newText = love.graphics.newText
local lgdraw = love.graphics.draw
local floor = math.floor

local FONT = require("src.misc.unique.font")



function TextSys:added(ent)
    assert(type(ent.text) == "string", "ent.text has gotta be type string")

    -- Remember what the initial text was, so we can change it
    ent._old_text = ent.text
    ent._textObj = newText(FONT, ent.text)
    ent.rot = 0
    
    if not ent.draw then
        local ox2, oy2 = ent._textObj:getDimensions( )
        ent:add("draw",{
            ox = ox2/2;
            oy = oy2/2
        })
    end
end


local cam = require("src.misc.unique.camera")



local function supdate(ent)
    if ent.text ~= ent._old_text then
        -- oh damn, its been re-initialized.
        -- make new text Obj
        ent._old_text = ent.text
        ent._textObj:release()
        ent._textObj = newText(FONT, ent.text)

        local ox2, oy2 = ent._textObj:getDimensions( )
        ent.draw = {
            ox = ox2/2;
            oy = oy2/2
        }
    end
end




local default_bob = {value = 1, magnitude = 0, oy = 0}
local default_sway = {value = 0, magnitude = 0, ox = 0}



function TextSys:drawEntity(ent)
    if ent._textObj then
        local pos = ent.pos
        local bob_comp = ent.bobbing or default_bob
        local sway_comp = ent.swaying or default_sway
        local draw = ent.draw
        if not ent.draw then
            Tools.dump(ent,"get a load of this guy. didnt have .draw comp")
            error("same old: cexists?: "..tostring(Cyan.exists(ent)))
        end

        lgdraw(
            ent._textObj,
            floor(pos.x), floor(pos.y - pos.z/2),
            ent.rot or 0, 1,
            bob_comp.scale,
            draw.ox + sway_comp.ox, 
            draw.oy + bob_comp.oy,
            sway_comp.value
        )
    end
end


function TextSys:sparseupdate(dt)
    for _, e in ipairs(self.group)do
        supdate(e)
    end
end



local messages = Tools.set()

local WHITE = {1,1,1}

function TextSys:message(x,y, str, duration, colour, rot)
    --[[
        Spawns a text message at X, Y that slowly blinks out of existance.
    ]]
    local msg = {
        time = 0;
        duration = duration;
        x = x, y = y,
        str = str,
        colour = colour or WHITE,
        rot = rot,
        ox = FONT:getWidth(str)/2,
        oy = FONT:getHeight(str)/2
    }
    messages:add(msg)
end


local BLINK_THRESHHOLD = 1 -- starts blinking with 2 seconds left
local BLINK_FREQ = 0.2 -- blinks every 0.15 seconds



local rembuffer = {}

function TextSys:update(dt)
    for i, msg in ipairs(messages.objects) do
        -- update msg object
        msg.time = msg.time + dt
        if msg.time > msg.duration then
            table.insert(rembuffer, msg)
        end
    end 

    for i=1,#rembuffer do
        local m = rembuffer[i]
        messages:remove(m)
        rembuffer[i] = nil
    end
end


function TextSys:purge()
    messages:clear()
end



local function getAlpha(msg)
    --[[
        returns an opacity value (0 or 1) that determines
        the opacity of each message object.
        
        We do this so the msg objects appear to "blink" when they are
        about to disappear.
    ]]
    local tleft = msg.duration - msg.time
    
    if (tleft < BLINK_THRESHHOLD) then
        return (math.sin(tleft * (math.pi*2) / BLINK_FREQ) * 0.95 + 1.02)
    end
    return 1
end


local setColor = love.graphics.setColor
local lgprint = love.graphics.print

local BG_OFFSET = 1 -- pixels for the background offset of text

local function drawmsg(msg)
    local alpha = getAlpha(msg)
    setColor(msg.colour[1]/2 - 0.3, msg.colour[2]/2 - 0.3, msg.colour[3]/2 - 0.3, alpha)
    lgprint(msg.str, msg.x + BG_OFFSET, msg.y - BG_OFFSET, msg.rot or 0, 1, 1, msg.ox, msg.oy)
    lgprint(msg.str, msg.x - BG_OFFSET, msg.y + BG_OFFSET, msg.rot or 0, 1, 1, msg.ox, msg.oy)

    setColor(msg.colour[1], msg.colour[2], msg.colour[3], alpha)
    lgprint(msg.str, msg.x, msg.y, msg.rot or 0, 1, 1, msg.ox, msg.oy)
end


function TextSys:finalDraw()
    for i, msg in ipairs(messages.objects) do
        drawmsg(msg)
    end
end



function TextSys:spawnText(x,y,str, height, height_variance)
    --[[
        Spawns block letter text (physics blocks)
    ]]
    height = height or 0
    height_variance = height_variance or 0
    local c
    local rand = love.math.random

    local x_off = str:len() * (-LETTER_WIDTH/2)
    -- size of letters is 32, we offset by string len * -32/2
    
    str = str:lower() -- No caps
    for i = 1, str:len() do
        c = str:sub(i,i)
        assert(c,"?")
        if c ~= " " then
            local letter_ctor = EH.Ents["letter_"..tostring(c)]
            if not(letter_ctor) then  
                error("letter " .. c .. " not configured")
            end
            local letter = letter_ctor(x + x_off + i*LETTER_WIDTH, y)
            letter.pos.z = height + ((rand()-0.5)*height_variance)
            letter.grounded = false -- tell GravitySys that letter might be airborne
        end
    end
end



