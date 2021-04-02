


local TextSys = Cyan.System()
--[[


static system responsible for spawning block text ents



]]


local LETTER_WIDTH = 28



function TextSys:spawnText(x,y,str, height)
    height = height or 0
    local c

    local x_off = str:len() * (-LETTER_WIDTH/2)
    -- size of letters is 32, we offset by string len * -32/2
    
    for i = 1, str:len() do
        c = str:sub(i,i)
        assert(c,"?")
        if c ~= " " then
            local letter_ctor = EH.Ents["letter_"..tostring(c)]
            assert(letter_ctor, "letter " .. c .. " not configured")
            local letter = letter_ctor(x + x_off + i*LETTER_WIDTH, y)
            letter.pos.z = height
        end
    end
end



