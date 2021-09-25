
local atlas = require("assets.atlas")
local Quads = atlas.Quads

local itemflags = require("src.misc.items.itemflags")
local Items = require("src.misc.items.initialize")

local Sets = require("src.misc.unique.sset_targets")

local er1=  "item pillar not given .itemType field"


local MSG_COLOUR = {.9, .9, .9}
local DESC_COLOUR = {1,1,1}

local MSG_SHOW_TIME = 4.5 -- the time taken to show the message


local function onDraw(ent)
    assert(ent.itemType,er1)
    atlas:draw(Quads[ent.itemType], ent.pos.x, ent.pos.y - 30, nil,nil,nil, 7.5,7.5)
end

local r = love.math.random

local function emitMessage(ent)
    local x, y = ent.pos.x, ent.pos.y - 40
    local item = Items[ent.itemType]
    ccall("message", x, y, ent.itemType:gsub("_"," "):upper(), MSG_SHOW_TIME, MSG_COLOUR, 0)
    if item.description then
        ccall("message", x, y + 30, item.description or "", MSG_SHOW_TIME,
                DESC_COLOUR)
    end
end


local function onInteract(self, player, type)
    -- type is pull or push
    if not itemflags[self.itemType] then
        if not Items[self.itemType] then
            error("unknown item: "..tostring(self.itemType))
        end
        ccall("giveItem", player, self.itemType)
        ccall("sound","getitem",2,1)
        ccall("sound", "thunder")
        ccall("sound", "superbang", 0.65)

        -- Now kill all item pedestels;
        --  only 1 item allowed to get per level for this pedestal type.
        for _, interact_ent in ipairs(Sets.interact.objects)do
            if interact_ent.itemType then
                -- Then its a damn item pedestal!! kill em.
                ccall("kill", interact_ent)
            end
        end

        emitMessage(self)
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
        This field denotes the item it can give player
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

