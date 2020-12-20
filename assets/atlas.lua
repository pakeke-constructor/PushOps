
local Atlas = require("libs.auto_atlas.init")





local atlas = Atlas(4096,4096)--size = 4096 pixels^2
-- 99% of GPUs will support this.
-- if not.....   :/




atlas.path = "assets/sprites/"


local PROXY = { }
atlas.quads = setmetatable({},
{
    __newindex = function(t,k,v)
        assert(not PROXY[k], "This image file " ..k .. " is already in the atlas. No duplicate names allowed!")
        rawset(PROXY, k, v)
    end; __index = PROXY
})



atlas.Quads = atlas.quads


atlas.default = atlas.quads


for _, each in ipairs(love.filesystem.getDirectoryItems(
    "assets/sprites/"
)) do
    if not(each:sub(1,1) == "_") then    
        
        atlas.path = "assets/sprites/"..each.."/"
        for _, each in ipairs(love.filesystem.getDirectoryItems(atlas.path)) do
            atlas:add(each)
        end

    end
end




return atlas
