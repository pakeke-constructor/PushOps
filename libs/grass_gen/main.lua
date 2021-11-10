
love.graphics.setDefaultFilter("nearest", "nearest")

function weighted(tab)
    --[[
        tab : {
            ["foo"] = 0.1;  20% chance to pick "foo"
            ["bar"] = 0.4;  80% chance to pick "bar"
        }
    ]]

    local r
    if love then
        r = love.math.random
    else
        r = math.random
    end

    local k_order = { }
    local v_order = { }

    local SUM = 0
    for value, prob in pairs(tab) do
        SUM = SUM + prob
        table.insert(k_order, SUM)
        table.insert(v_order, value)
    end

    -- Okay, now keys should be uniformly distributed about 0 -> SUM.
    -- Return function to get a random value

    assert(#k_order > 0, "Need more options for weighted_selection!")
    assert(#v_order > 0, "Need more options for weighted_selection!")

    return function()
        local R = r() -- get random val (uniformly made double: 0 -> 1 )

        for i = 1, #k_order do
            local ke = k_order[i] / SUM
            if ke >= R then
                return v_order[i]
            end
        end

        return error("somehow, the weighted selection did not get a value. fix pls")
    end
end


local cols = {
    [{1,1,1}] = 0.65;
    [{0.9,0.9,0.9}] = 0.45;
}


local choice = weighted(cols)

local canv

local function get()
    canv = love.graphics.newCanvas(64,64)
    love.graphics.setCanvas(canv)
    love.graphics.setColor(1,1,1,1)
    for x=1,64 do
        for y=1,64 do
            love.graphics.push()
                love.graphics.setColor(choice())
                love.graphics.points(x,y)
            love.graphics.pop()
        end
    end
    love.graphics.setCanvas()
    return canv
end

get()


function love.draw()
    love.graphics.clear(0,0,0,0)
    love.graphics.push()
    love.graphics.setColor(1,1,1,1)
    love.graphics.scale(10, 10)
    love.graphics.draw(canv, 0, 0)
    love.graphics.pop()
end



for i=1,32 do
    local canv = get()
    local idata = canv:newImageData()
    local fn = tostring(i)..".png"

    local dat = idata:encode("png")
    local ok, msg = love.filesystem.write(fn, dat, dat:getSize()) 

    if not ok then
        error(msg)
    end

end



function love.keypressed(k)
    if k=="r" then load() end
    if k=="escape" then love.event.quit() end
end

