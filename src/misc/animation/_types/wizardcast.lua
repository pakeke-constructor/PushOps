

local Quads = EH.Quads

-- Field init ==>
local frames = { } --overwrite this
for i=1,7 do
    table.insert(frames, Quads["wizardcast"..tostring(i)])
end

return {frames=frames}


