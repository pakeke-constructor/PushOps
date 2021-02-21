

local Quads = EH.Quads

-- Field init ==>
local frames = { } --overwrite this
for i=1, 6 do
    table.insert(frames, Quads["blit"..tostring(i)])
end

return {frames=frames}
