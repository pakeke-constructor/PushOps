
--[[

Block letter entities


]]


local Ents = EH.Ents


local letters = "aeghlmoprsuvkt"

for i = 1, #letters do
    local c = letters:sub(i,i)
    local name = "letter_"..c
    
    -- ahhh, luajit dont like loop closures. oh well
    local image = {
        quad = EH.Quads[name]
    }
    assert(image.quad,"fix")

    Ents[name] = function(x,y)
        return EH.FR(EH.PHYS(EH.PV(Cyan.Entity(), x, y), 10))
        :add("image",image)
        :add("pushable",true)
    end
end






-- We dont return anything here,
-- letters are placed directly into EH.entities
-- (I know, its weird.)
return function()
    error("all_letters_.lua  => you werent supposed to instantiate this....")
end

