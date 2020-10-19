





Cyan.call("newWorld",{
    x=600,y=50,
    tier = 1,
    type = 'basic'
})

local Ent = require("src.entities._ENTITIES")



local p = Ent.player(0,0)



local DEBUG_SYS = Cyan.System()

function DEBUG_SYS
:draw()
    love.graphics.setColor(0,0,0)
    love.graphics.print(("Memory used:: " .. (math.floor(collectgarbage("count")/10)/100) .. " MB"),20,50)
    love.graphics.print(("Player speed:: %d"):format(math.floor(p.vel:len())), 20, 65)
    love.graphics.print(("FPS :: %d"):format(love.timer.getFPS( )), 20, 80)
    love.graphics.setColor(1,1,1)

end


local r = love.math.random


for i=1,7 do
    Ent.wall(r(-400,400),r(-400,400))
end

for i=1,8 do
    Ent.mushroom(
        math.random(-300, 300), math.random(-300, 300)
    )
end

local i = 0
while i < 500 do
    local x,y = math.random(-300, 300), math.random(-300,300)
    if ((x^2 + y^2)^0.5) < 300  and ((x^2 + y^2)^0.5) > 100 then
        i = i + 1
        Ent.grass(x,y)
    end
end

for i=1,30 do
    Ent.block(math.random(-100, 100), math.random(-100, 100))
end

for i=1,10 do
    Ent.enemy(math.random(-2000, 2000), math.random(-2000,2000))
end


