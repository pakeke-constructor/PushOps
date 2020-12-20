
local vec3 = require("libs.tools.vec3")



local pos = SuperStruct(
    {pos = vec3(0,0,0)}
)






local vel = SuperStruct(
    {vel = vec3(0,0,0)}
)

function vel:update(dt)
    self.pos = self.vel + (self.pos * dt)
end

function vel:init()
    assert(self.pos, "velocity requires position")
end






local sprite = SuperStruct(
    {image = true}
)

function sprite:init()
    assert(self.pos, "image requires position")
    self.image = love.graphics.newImage("blah.png")
end




local draw = SuperStruct()
function draw:init()
    assert(self.image)
    assert(self.pos)
end



--[[


Now, combine ::


]]

local gameObject = SuperStruct()
    :attach(pos)
    :attach(vel)
    :attach(draw)
    :attach(sprite)

local obj = gameObject()

obj:init()

