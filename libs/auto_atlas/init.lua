
local PATH = (...):gsub('[%.%/]init','')
local binpack = require(PATH..".binpack")

local lg = love.graphics

local atlas = {}

local atlas_mt = { __index = atlas }

atlas.__new = function(_,x, y)
    local x = x or 2048
    local y = y or 2048
    return setmetatable({
        width = x, height = y,
        binpack = binpack(x, y),
        image = lg.newImage(love.image.newImageData(x, y)),
        path = "",
        default = nil
    }, atlas_mt)
end


local lg_draw = lg.draw
function atlas:draw(quad, x, y, r, sx, sy, ox, oy, kx, ky )
    lg_draw( self.image, quad, x, y, r, sx, sy, ox, oy, kx, ky )
end




function atlas:add(sprite, quad)
    if not (type(sprite) == "string") then
        assert(sprite:typeOf("Image"), " atlas:add( image, [quad] )  expected image to be of type \n Image. instead, got type:  "..tostring(type(sprite)))
    end
    lg.push( "all" )
    lg.reset()

    -- Is path.
    if type(sprite) == "string" then
        local sprite_path = self.path..sprite
        if self.type then
            if self.type:match("%.") then
                sprite_path = sprite_path..self.type
            else
                sprite_path = sprite_path.."."..self.type
            end
        end
        sprite = lg.newImage(sprite_path)
        local width,height = sprite:getWidth(), sprite:getHeight()
        local new = self.binpack:insert(width+1, height+1)
        -- Converting Image to Canvas:
        local temp_canvas = lg.newCanvas(width, height)
        lg.setCanvas(temp_canvas)
        lg.draw(sprite)
        lg.setCanvas()
        -- Canvas to ImageData:
        local img_data = temp_canvas:newImageData()
        -- ImageData w/ Image:replacePixels
        self.image:replacePixels(img_data, nil, 1, new.x, new.y)
        lg.pop()
        local ret_quad = lg.newQuad(new.x, new.y, width, height, self.width, self.height)
        if self.default then
            sprite_path = sprite_path:gsub(self.path, "")
            :gsub(".png","")
            self.default[sprite_path] = ret_quad
        end
        return ret_quad
    end

    -- Is image  +  quad.
    if quad then
        assert(quad:typeOf("Quad"), " atlas:add( image, [quad] )  expected optional arg [quad] to be of type \n quad. instead, got type:  "..tostring(type(quad)))
        local _, _, width, height = quad:getViewport()
        local new = self.binpack:insert(width+1, height+1)
        -- Converting Image to Canvas:
        local temp_canvas = lg.newCanvas(width, height)
        lg.setCanvas(temp_canvas)
        lg.draw(sprite)
        lg.setCanvas()
        local img_data = temp_canvas:newImageData()
        -- ImageData w/ Image:replacePixels
        self.image:replacePixels(img_data, nil, 1, new.x, new.y)
        lg.pop()
        return lg.newQuad(new.x, new.y, width, height, self.width, self.height)

    -- Is image.
    else
        local width, height = sprite:getWidth(), sprite:getHeight()
        local new = self.binpack:insert(width+1, height+1)
        -- Converting Image to Canvas:
        local temp_canvas = lg.newCanvas(width, height)
        lg.setCanvas(temp_canvas)
        lg.draw(sprite)
        lg.setCanvas()
        -- Canvas to ImageData:
        local img_data = temp_canvas:newImageData()
        -- ImageData w/ Image:replacePixels
        self.image:replacePixels(img_data, nil, 1, new.x, new.y)
        lg.pop()
        return lg.newQuad(new.x, new.y, width, height, self.width, self.height)
    end
end

return setmetatable(atlas, {__call = function(_, a1, a2) return atlas.__new(_, a1, a2) end})


