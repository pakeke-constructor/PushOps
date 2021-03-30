


local Quads = EH.Quads

-- Field init ==>
local frames = { } --overwrite this
for i=10,1,-1 do
    table.insert(frames, Quads["tp"..tostring(i)])
end

return {frames=frames}
