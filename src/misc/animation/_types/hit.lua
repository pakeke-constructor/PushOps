

local Quads = EH.Quads

-- Field init ==>
local frames = { } --overwrite this
for i=1,6 do
    table.insert(frames, Quads["hit"..tostring(i)])
end


local hitAnim = {frames=frames}


function hitAnim:play(x, y, z, frame_speed, cycles,
    colour, ent_to_track, should_hide_ent)
    getmetatable(self).__index.play(self, x, y, z, frame_speed, cycles,colour, ent_to_track, should_hide_ent)
    self.rot = love.math.random() * 2 * math.pi
end


return hitAnim

