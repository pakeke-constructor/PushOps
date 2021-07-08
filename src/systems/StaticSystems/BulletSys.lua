

local BulletSys = Cyan.System( )


local Ents = require("src.entities")

local ccall = Cyan.call


function BulletSys:shoot(x, y, vx, vy)
    local b = Ents.bullet(x,y)
    ccall("setVel", b, vx, vy)
    ccall("sound", "pew",0.4,0.5)
end


function BulletSys:shootbolt(x, y, vx, vy)
    local b = Ents.bolt(x, y)
    ccall("setVel", b, vx, vy)
    ccall("sound", "pew", 0.3,0.7)
end


