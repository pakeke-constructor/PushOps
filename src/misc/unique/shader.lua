

local moonshine = require("libs.NM_moonshine")

--[[
-- old code

local effect = moonshine(moonshine.effects.noise)
return effect
]]




local pth = "src/misc/unique/shader.glsl"
local code,e = love.filesystem.read(pth)
assert(code, e)


return love.graphics.newShader(code)
