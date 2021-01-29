
local ShaderSys = Cyan.System()


local setShader = love.graphics.setShader
local shader = require("src.misc.unique.shader_effect")

function ShaderSys:transform()
    setShader(shader)
end

function ShaderSys:untransform()
    setShader()
end

