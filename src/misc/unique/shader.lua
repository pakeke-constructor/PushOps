


local main_pth = "src/misc/unique/shader_main.glsl"
local mcode,e = love.filesystem.read(main_pth)
assert(mcode, e)


local light_pth = "src/misc/unique/shader_light.glsl"
local lcode,e2 = love.filesystem.read(light_pth)
assert(lcode, e2)


if CONSTANTS.TEST then
    local function check(path)
        local res, err = love.graphics.validateShader(true, path)
        assert(res, err)
    
        local res2, er2 = love.graphics.validateShader(false, path)
        assert(res2, er2)
    end
    
    check(light_pth)

    check(main_pth)
end




return {
    main = love.graphics.newShader(mcode);
    light = love.graphics.newShader(lcode)
}

