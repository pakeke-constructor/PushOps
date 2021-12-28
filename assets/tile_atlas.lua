
local Atlas = require("libs.auto_atlas.init")



-- Size of atlas should be:
-- (64 * 6) ^ 2
-- due to having 32 distinct grass tiles.

local sze = 64*7

local tile_atlas = Atlas(sze, sze)





tile_atlas.path = "assets/tiles/"


local PROXY = setmetatable({}, {__index = function(_,n)
    error("Attempted to access unknown tile =>  " .. tostring(n))
end})

tile_atlas.quads = setmetatable({},
{
    __newindex = function(t,k,v)
        assert(not rawget(PROXY, k), "This tile file " ..k .. " is already in the tile_atlas. No duplicate names allowed!")
        rawset(PROXY, k, v)
    end; __index = PROXY
})






tile_atlas.Quads = tile_atlas.quads
tile_atlas.default = tile_atlas.quads

local tiles = {}

for _, each in ipairs(love.filesystem.getDirectoryItems(
    "assets/tiles/"
)) do
    if not(each:sub(1,1) == "_") then    
        tile_atlas:add(each)
        local new = each:gsub("%.png","")
        table.insert(tiles, new)
    end
end




return {
    atlas = tile_atlas
    ,tiles = tiles
}

