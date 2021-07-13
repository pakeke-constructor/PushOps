

local Quads = EH.Quads

-- Field init ==>
local frames = {1,2,3,4,3,2,1,1} --overwrite this

for i,v in ipairs(frames) do
    table.insert(frames, Quads["blink"..tostring(i)])
end

return {frames=frames}

