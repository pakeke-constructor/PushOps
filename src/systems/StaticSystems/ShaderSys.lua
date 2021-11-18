
local ShaderSys = Cyan.System()


local setShader = love.graphics.setShader
local shader = require("src.misc.unique.shader").main
local camera = require("src.misc.unique.camera")

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
    shader:send("amount", CONSTANTS.SHADER_NOISE_AMOUNT)
    shader:send("period", CONSTANTS.SHADER_NOISE_PERIOD)

    shader:send("colourblind", CONSTANTS.COLOURBLIND)
    shader:send("devilblind",  CONSTANTS.DEVILBLIND) -- swaps RG channels
    shader:send("navyblind", CONSTANTS.NAVYBLIND) -- swaps RB 
end


