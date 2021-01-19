


local Quads = EH.Quads -- shouldnt be using EH here! oh well lol

-- Field init ==>
local frames = { } --overwrite this
for i=1, 9 do
    table.insert(frames, Quads["mallow_spin"..tostring(i)])
end

return {frames=frames}

