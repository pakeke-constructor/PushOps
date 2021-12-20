

local partition = require("src.misc.partition")


local CraftSys = Cyan.System("pos", "craft")



-- A list of all crafting materials
local craft_list = {
    "iron";
    "cast"; -- (Like a metal cast)
    "gem";
    "bottle";
    "cog";
    "glue"; -- looks like `splat`. (VERY COMMON)
    "fang";
    "skull";
    "book"
}






local recipes = {
    -- item_name = { "material", "material_2", ... }
    bull_ring = {"cast", "iron"};
    iron_potion = {"bottle", "iron"};
    pocket_watch = {"box", "cog"};
    totem = {"gem", "skull"};
    reverse_watch = {"glue", "cog"};
    pocket_watch = {"iron", "cog"};
    yellow_vial = {"glue", "bottle"};
    vampire_fang = {"fang", "gem"};
    titan_blood = {"fang", "skull"};
    mushroom_chunk = {"cast", "glue"};
    wings = {"book", "gem"};
    implosive_charm = {"skull", "cog"};
    patience_charm = {"book", "cast"};
    lantern = {"book", "iron"};
    spellbook = {"book", "gem"}
}


local craftables = {}

for k,v in pairs(recipes) do
    table.insert(craftables, k)
end




local MAX_CRAFTS = 3
-- maximum of 3 items crafted at once


local function spawn(x, y, itemname)
    -- spawns item totem
    local pillar = Ents.itempillar(x,y)
    pillar.itemType = itemname
end


local RADII = 200
local DEATH_RADII = 300


function CraftSys:craft(x, y, radius)
    local buffer = Tools.set()

    for ent in partition:iter(x,y) do
        if self:has(ent) and Tools.dist(ent.pos.x - x, ent.pos.y - y) <= radius then
            buffer:add(ent)
        end
    end

    local material_to_ent = {}

    local matbuffer = Tools.set()
    for _, ent in ipairs(buffer.objects)do
        matbuffer:add(ent.craft)
        material_to_ent[ent.craft] = ent
    end

    local ct = 0
    local cbuffer = {}
    local used_matbuffer = {}

    for _, item in ipairs(craftables) do
        if ct >= MAX_CRAFTS then
            break
        end

        local is_craftable = true
        for _, material in ipairs(recipes[item]) do
            if not matbuffer:has(material) then
                is_craftable = false
                break
            end
        end

        if is_craftable then
            for _, material in ipairs(recipes[item]) do
                table.insert(used_matbuffer, material)
            end
            ct = ct + 1
            table.insert(cbuffer, item)
        end
    end

    if #cbuffer > 0 then
        for i=1, #cbuffer do
            ccall("await", spawn, 0, x, y, cbuffer[i])
        end

        for i=1, #used_matbuffer do
            if material_to_ent[used_matbuffer[i]] then
                ccall("kill", material_to_ent[used_matbuffer[i]])
            end
            material_to_ent[used_matbuffer[i]] = nil
        end
    end
end



