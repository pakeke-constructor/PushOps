
--[[

Block letter entities


]]


local Ents = EH.Ents

        --     abcdefghijklmnopqrstuvwxyz
local letters = "abdeghilmnoprsuvktxz"

for i = 1, #letters do
    local c = letters:sub(i,i)
    if c == " " then
        goto continue
    end
    local name = "letter_"..c
    
    assert(EH.Quads[name],"fix")

    Ents[name] = function(x,y)
        local letter = EH.Ents.block(x,y)

        local _,_, bw, bh = letter.image.quad:getViewport()
        local _,_,w,h = EH.Quads[name]:getViewport()
        assert(bw == w and bh == h, "Block letter imgs gotta be same size as physics block imgs")

        letter.image.quad = EH.Quads[name]
        letter.physicsImmune = true
        letter.bobbing.magnitude = 0.2
        letter.colour=nil
        return letter
        --[[
        return EH.FR(EH.PHYS(EH.PV(Cyan.Entity(), x, y), 10), 1.4)
        :add("image",image)
        :add("pushable",true)
        :add("bobbing", {magnitude=0.2})
        :add("targetID", "physics")
        :add("physicsImmune",true) -- so it wont be killed by splat, or by massdeletion
        ]]
    end
    ::continue::
end






-- We dont return anything here,
-- letters are placed directly into EH.entities
-- (I know, its weird.)
return function()
    error("block_letters_.lua  => you werent supposed to instantiate this....")
end

