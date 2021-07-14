
local atlas = require("assets.atlas")
local Quads = atlas.Quads

local itemflags = require("src.misc.items.itemflags")

local Sets = require("src.misc.unique.sset_targets")

local er1=  "item pillar not given .itemType field"



local function onDraw(ent)
    assert(ent.itemType,er1)
    atlas:draw(Quads[ent.itemType], ent.pos.x, ent.pos.y - 30, nil,nil,nil, 7.5,7.5)
end


local function onInteract(self, player, type)
    -- type is pull or push
    if not itemflags[self.itemType] then
        ccall("giveItem", player, self.itemType)
        ccall("sound","getitem",2,1)
        ccall("sound", "superbang",1)

        do return end
        -- Now kill all item pedestels;
        --  only 1 item allowed to get per level for this pedestal type.
        for _, interact_ent in ipairs(Sets.interact.objects)do
            if interact_ent.itemType then
                -- Then its a damn item pedestal!! kill em.
                ccall("kill", interact_ent)
            end
        end
        return true
    end
end


local function onDeath(self)
    ccall("sound","crumble",1)
    ccall("emit", "pillarbreak", self.pos.x, self.pos.y, self.pos.z, 6)
end



return function(x,y)
    --[[
        This entity should have a special field:
        .itemType = "item_name"
        This field denotes the 
    ]]
    local ip = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("image", EH.Quads.pillar2)
    :add("targetID","interact")
    :add("size",55)
    :add("onInteract", onInteract)
    EH.PHYS(ip, 7, "static")
    EH.BOB(ip)
    ip.draw.oy = 30

    ip.onDraw = onDraw
    ip.hybrid = true
    ip.onDeath = onDeath
    return ip
end

