

local BulletSys = Cyan.System( )


local Ents = require("src.entities")

local ccall = Cyan.call


function BulletSys:shoot(x, y, vx, vy)
    local b = Ents.bullet(x,y)
    ccall("setVel", b, vx, vy)
end


function BulletSys:shootbolt(x, y, vx, vy)
    local b = Ents.bolt(x, y)
    ccall("setVel", b, vx, vy)
end


