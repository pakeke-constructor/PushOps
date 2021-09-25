



local WHITE = {1,1,1,1}

local frames = {1,2,3,2}
for i,v in ipairs(frames)do
    frames[i] = EH.Quads["firefly"..tostring(v)]
end

return function(x,y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.light = {
        height = nil; --There is a default value in lightSys
        distance = 500;
        colour = WHITE
    }

    e.animation = {
        frames=frames;
        interval=0.1
    }

    e.speed = {
        speed = 10;
        max_speed = 10
    }

    e.behaviour = {
        move={
            type="RAND";
            id=1
        }
    }

    return e
end

