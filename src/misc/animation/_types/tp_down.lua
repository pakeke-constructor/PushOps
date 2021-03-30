


local Quads = EH.Quads

-- Field init ==>
local frames = { } --overwrite this
for i=1, 10 do
    table.insert(frames, Quads["tp"..tostring(i)])
end

return {frames=frames}



