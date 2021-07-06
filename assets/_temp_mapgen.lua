

local map = setmetatable({},
    {
        __index = function(t,k)
            t[k] = {}
            return t[k]
        end
    })


local W = 50
local H = 50

local AREA = 1

local sqrt = math.sqrt

local function toWorld(x,y)
    local w,h = love.window.getMode()
    return  (x/w)*W, (y/h)*H
end

local function toScreen(x,y)
    local w,h = love.window.getMode()
    return  (x/W)*w, (y/H)*h
end


dist = function(x, y)
    return sqrt(x*x + y*y)
end

function love.update(dt)
    if love.mouse.isDown(1) then
        local X,Y = toWorld(love.mouse.getPosition())
      
        for x=1,W do
            for y = 1,H do
                if dist(x-X,y-Y) < AREA then
                    map[y][x] = " "
                end
            end
        end
    end
end


for x=1,W do
    for y = 1,H do
        map[y][x] = "~"
    end
end


local function isNextOpen(map,x,y)
    for i=-1,1 do
        for j=-1,1 do 
            if map[y+i][x+j] == " " then
                return 1
            end
        end
    end
end

function love.keypressed(k)
    if k=="q" then        
        for x=1,W do
            for y = 1,H do
                map[y][x] = "~"
            end
        end
        return
    end
    
    for x=1,W do
    for y = 1,H do
        if isNextOpen(map,x,y) and map[y][x] == "~" then
            map[y][x] = "%"
        end
    end
    end

    for _,v in ipairs(map) do
        print(table.concat(v,""))
    end
end


local SC = love.graphics.setColor

function love.draw(dt)
    local w,h = love.window.getMode()
    w = w - 100
    h = h - 100
    love.graphics.translate(50,50)
    for x=1,W do
        for y = 1,H do
            if map[y][x] == "~" then
                SC(1,1,1)
            else
                SC(0,0,1)
            end
            love.graphics.circle("fill", (x/W)*w, (y/H)*h, 12)
        end
    end
end


