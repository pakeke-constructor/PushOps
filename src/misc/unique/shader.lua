


local main_pth = "src/misc/unique/shader_main.glsl"
local mcode,e = love.filesystem.read(main_pth)
assert(mcode, e)


local light_pth = "src/misc/unique/shader_light.glsl"
local lcode,e2 = love.filesystem.read(light_pth)
assert(lcode, e2)

return {
    main = love.graphics.newShader(mcode);
    light = love.graphics.newShader(lcode)
}

