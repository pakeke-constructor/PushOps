
local ShaderSys = Cyan.System()


local setShader = love.graphics.setShader
local shader = require("src.misc.unique.shader")

function ShaderSys:transform()
    setShader(shader)
end

function ShaderSys:untransform()
    setShader()
end

function ShaderSys:update(dt)
    --[[
        The rest of the sent variables can be found in
        LightSys.lua.
    ]]
    shader:send("amount", 0.07)
    shader:send("period", 2)
    shader:send("colourblind", CONSTANTS.COLOURBLIND)
    shader:send("devilblind",  CONSTANTS.DEVILBLIND) -- swaps RG channels
    shader:send("navyblind", CONSTANTS.NAVYBLIND) -- swaps RB 
end




