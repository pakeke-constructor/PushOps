
--[[

Block letter entities


]]


local Ents = EH.Ents

        --     abcdefghijklmnopqrstuvwxyz
local letters = "adeghilmnoprsuvktxz"

for i = 1, #letters do
    local c = letters:sub(i,i)
    if c == " " then
        goto continue
    end
    local name = "letter_"..c
    
    -- ahhh, luajit dont like loop closures. oh well
    local image = {
        quad = EH.Quads[name]
    }
    assert(image.quad,"fix")

    Ents[name] = function(x,y)
        return EH.FR(EH.PHYS(EH.PV(Cyan.Entity(), x, y), 10), 1.4)
        :add("image",image)
        :add("pushable",true)
        :add("bobbing", {magnitude=0.2})
        :add("targetID", "physics")
        :add("physicsImmune",true) -- so it wont be killed by splat, or by massdeletion
    end
    ::continue::
end






-- We dont return anything here,
-- letters are placed directly into EH.entities
-- (I know, its weird.)
return function()
    error("block_letters_.lua  => you werent supposed to instantiate this....")
end

