

local Atlas = require("assets.atlas")


local frames = {}

for n=1, 7 do
    table.insert(frames, Atlas.Quads["shock"..tostring(n)])
end


return frames

