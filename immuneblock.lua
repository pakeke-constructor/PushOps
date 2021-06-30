
--[[

physics block that is immune to splatting!

]]

local quads = {
    "spot_block",
    "spot_block2"
}
for k,v in ipairs(quads)do
    quads[k] = EH.Quads[v]
end

return function(x,y)
    local block = EH.Ents.block(x,y)
    block.image.quad = Tools.rand_choice(quads)
    block.physicsImmune = true
end


