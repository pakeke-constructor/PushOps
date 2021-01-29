

local moonshine = require("libs.NM_moonshine")

--[[
-- old code

local effect = moonshine(moonshine.effects.noise)
return effect
]]



local PATH = Tools.Path(...)

local f = io.open(PATH:gsub("%.","/").."/main_shader.glsl","r")
local code = f:read()
f:close()


return love.graphics.newShader(code)
