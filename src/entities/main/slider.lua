

local function getValue(e)
    return ((e.pos.x - e.sl_original_x)/128) * (e.sl_max - e.sl_min)
end

local function fromValue(e,val)
    --[[
        gives X position from value
    ]]
    return e.sl_original_x + (val / (e.sl_max - e.sl_min)) * 128
end

local function setValue(slider, val)
    ccall("setPos", slider, fromValue(slider, val), slider.sl_const_y)
end

local max = math.max
local min = math.min


local function onUpdate(e,dt)
    assert(e.sl_table)
    assert(e.sl_min)
    assert(e.sl_max)
    assert(e.sl_name)

    local orig_x = e.sl_original_x
    local x = e.pos.x
    if x < orig_x then
        ccall("setPos", e,orig_x, e.sl_const_y)
    end
    if x > orig_x + 128 then
        ccall("setPos",e, orig_x + 128, e.sl_const_y)
    end

    local y = e.pos.y
    local og_y = e.sl_const_y

    if math.abs(y-og_y) > 4 then
        ccall("setPos",e,x,og_y)
    end
    --ccall("setPos", e, max(orig_x, min(orig_x + 128, e.pos.x)), e.sl_const_y)

    local val = getValue(e)
    e.sl_table[e.sl_name] = val
end



local shape = love.physics.newCircleShape(10)


local function slider_base(x, y)
    local base= Cyan.Entity()
    :add("pos",math.vec3(x,y-25,-50))
    :add("image",{quad = EH.Quads.slider_base,ox=0,oy=14})
end


return  function(x,y)
    --[[
    slider objects have two fields added externally:

    slider.sl_table   // the slider can modify fields in this table
    slider.sl_min    // the min value the slider gives
    slider.sl_max    // the max value the slider gives
    slider.sl_name   // the name of the field to modify in `.sl_table`

    Shader objects will always start at X = 0,
    relative to the slider.
    ]]
    local slider = Cyan.Entity()
    EH.PV(slider,x,y)
    
    slider.sl_const_y = y -- Slider must stay at same y position
    slider.sl_original_x = x

    slider.image = {quad = EH.Quads.slider}

    slider.physics = {
        body = "dynamic";
        shape = shape;
        friction = 40
    }
    slider.onUpdate=onUpdate
    slider.hybrid=true

    slider.setValue = setValue

    --[[ draw slider base: ]]
    slider_base(x,y)

    return slider
end
