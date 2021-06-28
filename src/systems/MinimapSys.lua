


local MinimapSys = Cyan.System("control", "pos")


--[[

Okay...

how am I going to do this?

The easy way would be to dispatch a ccall to drawSys
to draw the minimap,
however that wouldn't be very modular.

I could just take in all drawable ents and shove them
into a buffer system, then draw to the canvas directly from this file.
Yeah thats what I'll do

]]


local MAX_HEIGHT = 100 -- in pixels
local MAX_WIDTH  = 100



local fogCanvas  -- Canvas that holds "fog of war"
local mapCanvas



local function getMapScale(world, wmap)
    local world_width = #wmap * CONSTANTS.TILESIZE
    local world_height = #wmap[1] * CONSTANTS.TILESIZE
    local width  = world_width
    local height = world_height
    local scale = 1
    while (width > MAX_WIDTH) and (height > MAX_HEIGHT) do
        scale = scale - 0.00001
        width = world_width * scale
        height = world_height * scale
    end
    return scale
end





local heavyDraw

function MinimapSys:finalizeWorld(world, wmap)
    local scale = getMapScale(world, wmap)
    local TILESIZE = CONSTANTS.TILESIZE
    local canvWidth  = math.ceil(#wmap[1] * scale * TILESIZE)
    local canvHeight = math.ceil(#wmap * scale * TILESIZE)
    mapCanvas = love.graphics.newCanvas(canvWidth, canvHeight)
    fogCanvas = love.graphics.newCanvas(canvWidth, canvHeight)
    
    love.graphics.push()
    love.graphics.setCanvas(mapCanvas)
    love.graphics.setShader()
    love.graphics.setColor(CONSTANTS.grass_colour)
    love.graphics.rectangle("fill",0,0, canvWidth, canvHeight)
    --love.graphics.reset()
    love.graphics.scale(scale)
    love.graphics.setColor(1,1,1,1)
    heavyDraw()
    love.graphics.setCanvas()
    love.graphics.pop()
end





function MinimapSys:heavyupdate(dt)
end



function MinimapSys:drawUI()
    love.graphics.draw(mapCanvas, 60,60)
end







local function order(ent_a, ent_b)
    return (ent_a.pos.y + ent_a.pos.z/2) < (ent_b.pos.y + ent_b.pos.z/2)
end





local DrawBufferSys = Cyan.System("draw", "pos")

local buffer = {}

function DrawBufferSys:added(ent)
    table.insert(buffer, ent)
end


function heavyDraw(canv)
    table.stable_sort(buffer, order)
    for i=1, #buffer do
        local ent = buffer[i]
        ccall("drawEntity", ent)
        DrawBufferSys:remove(ent)
        buffer[i] = nil -- Be friendly to GC
    end
    buffer = {}
end



