


local function onInteract(self, player, type)
    -- type is pull or push

end


local function onDraw(ent)
    
end


return function(x,y)
    --[[
        This entity should have a special field:
        .itemType = "item_name"
        This field denotes the 
    ]]
    local ip = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("image", EH.Quads.pillar)
    :add("targetID","interact")
    :add("size",15)
    :add("onInteract", onInteract)
    EH.PHYS(ip, 7, "static")
    ip.draw.oy = -60

    ip.onDraw = onDraw
    ip.hybrid = true
    return ip
end

