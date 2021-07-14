

local Quads = EH.Quads

-- Field init ==>
local frames = {1,2,3,4,3,2,1,1} --overwrite this

for i,v in ipairs(frames) do
    frames[i] = Quads["blink"..tostring(v)]
end

return {frames=frames}

