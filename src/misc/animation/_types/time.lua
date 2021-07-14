

local Quads = EH.Quads

-- Field init ==>
local frames = {1,2,3,4,4} 

for i,v in ipairs(frames) do
    frames[i] = Quads["time"..tostring(v)]
end

return {frames=frames}

