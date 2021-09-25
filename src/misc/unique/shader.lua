


local pth = "src/misc/unique/shader_final.glsl"
local code,e = love.filesystem.read(pth)
assert(code, e)


return love.graphics.newShader(code)
