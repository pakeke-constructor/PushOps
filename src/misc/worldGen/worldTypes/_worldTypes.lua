
--[[

`worldTypes` is a table of the form ::

{
    basic = {
        [1] = basic_T1,
        [2] = basic_T2
    },

    other = {
        [1] = other_T1,
        [2] = other_T2
    }
}
 



Note :::

It doesn't matter what the files are called in this directory!!!
All that matters is that each file is a worldType table,
and each worldType has the appropriate `tier` and `type` fields.



]]
local PATH = Tools.Path(...):gsub("%.","%/")


local Auxiliary = { }

local function req_TREE(PATH)
    for _,fname in ipairs(love.filesystem.getDirectoryItems(PATH)) do
        if fname:sub(1,1) ~= "_" then
            local proper_name = fname:gsub(".lua", "")
            fname = PATH.."/"..fname
            local info = love.filesystem.getInfo(fname)
            if info.type == "directory" then
                req_TREE(fname)
            else
                Auxiliary[proper_name] = require(fname:gsub("/","."):gsub(".lua", ""))
            end
        end
    end
end


req_TREE(PATH)



local defaultEntExclusionZones =
require(PATH:gsub("worldTypes", "").."defaultEntExclusionZones")



local EMPTY = {
    max = 0xFFFFFFFFFFFFFFFFFFFF, -- For uninitialized char spawn calls,
    function()end                 -- this table will be accessed.
}
local worldType_entity_mt = {
    __index = function(t,k)
        return EMPTY
end}




local worldTypes = { }

for _, wType in pairs(Auxiliary) do
    local type = wType.type
    local tier = wType.tier

    assert(type, "not given a type")
    assert(tier, "not given a tier")

    if not (worldTypes[type]) then
        -- If this type does not have a spot in table, put in
        worldTypes[type] = { }
    end
    
    assert(not (worldTypes[type][tier]), 
    ("duplicate worldType: type=%s tier=%d \nAssert that no worlds overwrite anything else"):format(type, tier))

    wType.entities = setmetatable(wType.entities, worldType_entity_mt)
    
    if not wType.entExclusionZones then
        wType.entExclusionZones = defaultEntExclusionZones
    end

    worldTypes[type][tier] = wType
end

return worldTypes



