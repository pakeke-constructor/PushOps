

local Atlas = require("assets.atlas")


local frames = {}

for n=1, 7 do
    table.insert(frames, Atlas.Quads["bigpush"..tostring(n)])
end

frames.oy = -40


local q = { }



function q:draw()
    if self.finished then return end
    --    love.graphics.draw(drawable,x,y,r,sx,sy,ox,oy)

    if self.tracking then
        local pos = self.tracking.pos
        if pos then
            -- In case entity position component has been deleted
            Atlas:draw(self.frames[self.current], self.x + pos.x, (-30 + self.y + pos.y) - (self.z+pos.z)/2, 0, 1, 1, self.ox, self.oy)
            return
        end
    end

    Atlas:draw(self.frames[self.current],
        self.x, -30 + self.y - self.z/2, 0, 1, 1, self.ox, self.oy)
end

q.frames = frames


return q

