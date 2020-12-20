

local BulletSys = Cyan.System( )


local Ents = require("src.entities")

local ccall = Cyan.call


function BulletSys:shoot(x, y, vx, vy)
    local b = Ents.bullet(x,y)

    ccall("setVel", b, vx, vy)
end


function BulletSys:mousepressed()
    ccall("shoot", 10,10,240,240)
end


