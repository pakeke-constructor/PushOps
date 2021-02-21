
local ShockWave = {
    --[[

Shockwave objects represented as a class, with :new and :update
and :draw methods.





    ]]
}

local mt = {__index = ShockWave}

function ShockWave.new( x, y, start_rad, end_rad, thickness, time, colour )
    local sw = setmetatable({
        x = x, y = y,
        thickness = thickness,
        rad = start_rad,
        colour = colour,
        start_rad = start_rad,
        end_rad = end_rad
    }, mt)

    sw.d_rad = (end_rad - start_rad) / time
    return sw
end


function ShockWave:update(dt)
    self.rad = self.rad + (self.d_rad * dt)
    local opacity = 1-(self.rad-self.start_rad)/(self.end_rad-self.start_rad)
    self.colour[4] = opacity
    if self.d_rad < 0 then
        -- then the radius is running backwards
        if self.rad < self.end_rad then
            self.isFinished = true
        end
    else
        if self.rad > self.end_rad then
            self.isFinished = true
        end
    end
end




local setLineWidth = love.graphics.setLineWidth
local c = love.graphics.circle
local setColour = love.graphics.setColor

function ShockWave:draw()
    setColour(self.colour)
    setLineWidth(self.thickness)
    c("line", self.x, self.y, self.rad)    
end




return ShockWave.new