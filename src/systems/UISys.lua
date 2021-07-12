


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


local dynamicCanvas  -- Canvas that holds "fog of war", and positions n stuff
local mapCanvas




local draw = love.graphics.draw
local atlas = require("assets.atlas")

local HP_X = 16
local HP_Y = 8

local MINIMAP_X = 8
local MINIMAP_Y = 8

local MINIMAP_BORDER_WIDTH = 3

local MINIMAP_MAX_WIDTH = 94 -- in pixels
local MINIMAP_MAX_HEIGHT  = 94

local mapScale = 1

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
    if not CONSTANTS.minimap_enabled then
        return
    end

    if world.minimap then
        -- world.minimap (should be) a quad
        local quad = world.minimap
        assert(quad:type() == "Quad", "eh? bug.")
        local _,_, canvWidth, canvHeight = quad:getViewport()
        mapCanvas = love.graphics.newCanvas(canvWidth, canvHeight)
        dynamicCanvas = love.graphics.newCanvas(canvWidth, canvHeight)
        
        love.graphics.push()
        love.graphics.setCanvas(mapCanvas)
            atlas:draw(quad)
        love.graphics.setCanvas()
        love.graphics.pop()

        mapScale = getMapScale(world, wmap)
        return 
    end

    local scale = getMapScale(world, wmap)
    mapScale = scale
    local TILESIZE = CONSTANTS.TILESIZE
    local canvWidth  = math.ceil(#wmap[1] * scale * TILESIZE)
    local canvHeight = math.ceil(#wmap * scale * TILESIZE)
    mapCanvas = love.graphics.newCanvas(canvWidth, canvHeight)
    dynamicCanvas = love.graphics.newCanvas(canvWidth, canvHeight)

    love.graphics.push()
    love.graphics.setCanvas(mapCanvas)
    love.graphics.setShader()
    love.graphics.setColor(CONSTANTS.grass_colour)
    love.graphics.rectangle("fill",0,0, canvWidth, canvHeight)
    love.graphics.scale(scale)
    love.graphics.setColor(1,1,1,1)
    drawEntities()
    love.graphics.setCanvas()
    love.graphics.pop()
end


local NEW_ALPHA = 0.5


--[[

Drawing health Bar

]]


local function drawHpBar(player)
    local alpha = 1

    love.graphics.push()

    if love.keyboard.isDown("tab") and (not CONSTANTS.paused) then
        love.graphics.pop()
        return -- Don't draw HP bar
    end

    love.graphics.translate(mapCanvas:getWidth() + MINIMAP_BORDER_WIDTH + MINIMAP_X,0)
    local hp = player.hp
    tick = tick + 0.01

    local r,g,b = 0.7, 0, 0
    if player.hpBarColour then
        local col = player.hpBarColour
        r,g,b = col[1], col[2], col[3]
    end
    love.graphics.setColor(r + 0.1*sin(tick), g, b, alpha)
    love.graphics.rectangle("fill", HP_X+3, HP_Y+3, 32-6, (96-6) * (hp.hp / (hp.max_hp)))
    love.graphics.setColor(1,1,1)
    atlas:draw(atlas.Quads.hp_bar_2, HP_X, HP_Y)
    love.graphics.pop()
end





local miniMapShader = love.graphics.newShader(
    love.filesystem.read("src/misc/unique/mapshader.glsl"), nil
)



local function drawMiniMap()
    local alpha = 1
    love.graphics.push()

    if love.keyboard.isDown("tab") and (not CONSTANTS.paused) then
        alpha = NEW_ALPHA
        love.graphics.scale(3)
    end

    local BORDER_WIDTH = MINIMAP_BORDER_WIDTH
    local mmw, mmh = mapCanvas:getWidth(), mapCanvas:getHeight()
    local main_x = MINIMAP_X + BORDER_WIDTH/2
    local main_y = MINIMAP_Y + BORDER_WIDTH/2
    
    miniMapShader:send("map_x", mmw)
    miniMapShader:send("map_y", mmh)
    miniMapShader:send("colourblind", CONSTANTS.COLOURBLIND)
    miniMapShader:send("devilblind",  CONSTANTS.DEVILBLIND)
    miniMapShader:send("navyblind",   CONSTANTS.NAVYBLIND)

    love.graphics.setColor(1,1,1, alpha)
    love.graphics.setShader(miniMapShader)
    love.graphics.draw(mapCanvas, main_x, main_y)
    love.graphics.setShader()
    love.graphics.draw(dynamicCanvas, main_x, main_y)
    love.graphics.setLineWidth(BORDER_WIDTH)
    love.graphics.rectangle("line", main_x, main_y, mmw, mmh)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0,0,0, alpha)
    love.graphics.rectangle("line",MINIMAP_X,MINIMAP_Y,
                        mmw + BORDER_WIDTH, mmh + BORDER_WIDTH)
    love.graphics.rectangle("line", main_x + BORDER_WIDTH/2, main_y + BORDER_WIDTH/2,
                                mmw - BORDER_WIDTH, mmh - BORDER_WIDTH)
    love.graphics.setColor(1,1,1)

    love.graphics.pop()
end



local font = require("src.misc.unique.font")
local PAUSED = love.graphics.newText(font, "(PAUSED)")
local PAUSED_WIDTH = PAUSED:getWidth()
local PAUSED_HEIGHT = PAUSED:getHeight()
local WHITE = {1,1,1,1}
local BLACK = {0,0,0}
local YLO = {1,1,0.1}
local GRN = {0.1,1,0.1}
local BLU = {0.05,0.05,1}

function UISys:drawUI()
    -- check that a player exists
    if self.group[1] then
        drawHpBar(self.group[1]) -- Only 1 health bar supported.
    end

    if CONSTANTS.minimap_enabled then
        drawMiniMap()
    end

    if CONSTANTS.paused then
        -- Then we draw a grey screen,
        -- and info on how to unpause
        local lg = love.graphics
        lg.setColor(0,0,0,0.7)

        local w,h = lg.getWidth()/2,lg.getHeight()/2
        lg.rectangle("fill",-10,-10,w+20,h+20)

        Tools.drawText("( PAUSED )", w/2, h/16, WHITE, BLACK)
        Tools.drawText("press ESCAPE to unpause", w/2, h/16 + 40, YLO, BLACK)
        Tools.drawText("press Q to exit to menu", w/2, h/16 + 70, BLU, BLACK)
        Tools.drawText("press R to restart run", w/2, h/16 + 100, GRN, BLACK)
        Tools.drawText("Press X to exit game", w/2, h/16 + 140, BLACK, WHITE)
    end
end


local menu_map = require("src.misc.worldGen.maps.menu_map")

function UISys:keypressed(key)
    if CONSTANTS.paused then
        if key == "x" then -- quit
            love.event.quit(0)
        end

        if key == "q" then
            -- Exit to menu
            CONSTANTS.paused = false
            ccall("switchWorld",{
                x=100;y=100;
                tier=1;
                type='menu'
            }, menu_map)
        end

        if key == "r" then
            -- Restart run... hmm how should this be done
            CONSTANTS.paused = false
            ccall("restartWorld") -- Let GenerationSys handle this mess!
        end
    end

    if key == "escape" then
        -- Then we pause the game
        CONSTANTS.paused = not CONSTANTS.paused
    end
end



local Partitions = require("src.misc.unique.partition_targets")

local floor = math.floor


local function drawDynamicMap(player)
    local w, h = dynamicCanvas:getWidth(), dynamicCanvas:getHeight()
    local old_line_width = love.graphics.getLineWidth()

    love.graphics.setCanvas(dynamicCanvas)
    love.graphics.clear(0,0,0,0)

    -- Draw player position thing
    local x, y = floor(player.pos.x * mapScale), floor(player.pos.y * mapScale)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(0,0,1)
    love.graphics.line(0,y,w,y)
    love.graphics.line(x,0,x,h)
    love.graphics.circle("line", x, y, 1.5)

    -- Draw enemies
    love.graphics.setColor(1,0,0,0.2)
    local epartition = Partitions.enemy
    local ex, ey
    -- this is soooo terrible and hacky. Buttt... I don't want to use `pairs`
    -- in this function
    assert(epartition.moving_objects, "hacky code needs a rework because partition was (probably) changed")
    for _,enemy in ipairs(epartition.moving_objects.objects) do
        ex, ey = floor(enemy.pos.x * mapScale), floor(enemy.pos.y * mapScale)
        love.graphics.circle("fill", ex, ey, 5)
    end
    
    love.graphics.setColor(1,1,1,1)
    love.graphics.setCanvas()
end


function UISys:update(dt)
    --[[
        draws player position and stuff
    ]]
    --assume player is 1st entity in group
    if self.group[1] and CONSTANTS.minimap_enabled then
        local player = self.group[1]
        drawDynamicMap(player)
    end
end



function UISys:focus(focused)
    if not focused then
        CONSTANTS.paused = true
    end
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



