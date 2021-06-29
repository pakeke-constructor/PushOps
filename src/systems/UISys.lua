


local UISys = Cyan.System("control", "pos")


--[[

Okay...

how am I going to do minimap?

The easy way would be to dispatch a ccall to drawSys
to draw the minimap,
however that wouldn't be very modular.

I could just take in all drawable ents and shove them
into a buffer system, then draw to the canvas directly from this file.
Yeah thats what I'll do

]]


local fogCanvas  -- Canvas that holds "fog of war"
local mapCanvas




local draw = love.graphics.draw
local atlas = require("assets.atlas")

local HP_X = 16
local HP_Y = 8

local MINIMAP_X = 8
local MINIMAP_Y = 8

local MINIMAP_BORDER_WIDTH = 4

local MINIMAP_MAX_WIDTH = 94 -- in pixels
local MINIMAP_MAX_HEIGHT  = 94


local tick = 0
local sin = math.sin




local function getMapScale(world, wmap)
    local world_width = #wmap * CONSTANTS.TILESIZE
    local world_height = #wmap[1] * CONSTANTS.TILESIZE
    local width  = world_width
    local height = world_height
    local scale = 1
    while (width > MINIMAP_MAX_HEIGHT) and (height > MINIMAP_MAX_WIDTH) do
        scale = scale - 0.00001
        width = world_width * scale
        height = world_height * scale
    end
    return scale
end







local drawEntities

function UISys:finalizeWorld(world, wmap)
    --[[
        constructs minimap
    ]]
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
    drawEntities()
    love.graphics.setCanvas()
    love.graphics.pop()
end


function UISys:heavyupdate(dt)
end


--[[

Drawing health Bar

]]


local function drawHpBar(player)
    love.graphics.push()
    love.graphics.translate(mapCanvas:getWidth() + MINIMAP_BORDER_WIDTH + MINIMAP_X,0)
    local hp = player.hp
    tick = tick + 0.01
    love.graphics.setColor( 0.7 + 0.1*sin(tick) ,0,0)
    love.graphics.rectangle("fill", HP_X+3, HP_Y+3, 32-6, (96-6) * (hp.hp / (hp.max_hp)))
    love.graphics.setColor(1,1,1)
    atlas:draw(atlas.Quads.hp_bar_2, HP_X, HP_Y)
    love.graphics.pop()
end





local miniMapShader = love.graphics.newShader(
    love.filesystem.read("src/misc/unique/mapshader.glsl"), nil
)


local function drawMiniMap()
    local BORDER_WIDTH = MINIMAP_BORDER_WIDTH
    local mmw, mmh = mapCanvas:getWidth(), mapCanvas:getHeight()
    local main_x = MINIMAP_X + BORDER_WIDTH/2
    local main_y = MINIMAP_Y + BORDER_WIDTH/2
    
    miniMapShader:send("map_x", mmw)
    miniMapShader:send("map_y", mmh)

    love.graphics.setColor(1,1,1)
    love.graphics.setShader(miniMapShader)
    love.graphics.draw(mapCanvas, main_x, main_y)
    love.graphics.setShader()
    love.graphics.setLineWidth(BORDER_WIDTH)
    love.graphics.rectangle("line", main_x, main_y, mmw, mmh)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line",MINIMAP_X,MINIMAP_Y,
                        mmw + BORDER_WIDTH, mmh + BORDER_WIDTH)
    love.graphics.rectangle("line", main_x + BORDER_WIDTH/2, main_y + BORDER_WIDTH/2,
                                mmw - BORDER_WIDTH, mmh - BORDER_WIDTH)
    love.graphics.setColor(1,1,1)
end



function UISys:drawUI()
    -- check that a player exists
    if self.group[1] then
        drawHpBar(self.group[1]) -- Only 1 health bar supported.
    end
    drawMiniMap()
end











local function order(ent_a, ent_b)
    return (ent_a.pos.y + ent_a.pos.z/2) < (ent_b.pos.y + ent_b.pos.z/2)
end



local DrawBufferSys = Cyan.System("pos", "draw")

local buffer = {}

function DrawBufferSys:added(ent)
    table.insert(buffer, ent)
end


local function drawEnt(ent)
    love.graphics.setColor(1,1,1)
    if not ent.hidden then
        if ent.trivial then
            ccall("drawTrivial", ent)
        else
            if ent.colour then
                love.graphics.setColor(ent.colour)
            end
            ccall("drawEntity", ent)
        end
    end
end


function drawEntities(canv)
    love.graphics.setShader()
    table.stable_sort(buffer, order)
    for i=1, #buffer do
        local ent = buffer[i]
        if DrawBufferSys:has(ent) then
            drawEnt(ent)
        end
        DrawBufferSys:remove(ent)
        buffer[i] = nil -- Be friendly to GC
    end
    buffer = {}
end



