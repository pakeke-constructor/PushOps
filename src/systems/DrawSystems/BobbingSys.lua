

local BobSys = Cyan.System("bobbing", "draw")
--[[

For entities that are bobbing up and down.

]]




local sin = math.sin
local rand_choice = Tools.rand_choice


-- Speed at which entities "bob" (rads/s)
local speed = 13



-- List of different phase sin functions
local functions = {}




-- list of values for each sin function
local values = {}


-- Creating functions
for x=1, 6 do
    local offset = (x/6)*(math.pi*2)
    functions[x] = function(tick)
        return sin(offset + tick)
    end
end



local t = {1,2,3,4,5,6}

function BobSys:added(ent)
    ent.bobbing.phase = rand_choice(t)
    ent.bobbing.oy = 0
    if not ent.bobbing.magnitude then
        ent.bobbing.magnitude = 5
    end
end





local x = 0
function BobSys:update(dt)
    x = x + (dt * speed)

    for indx, func in ipairs(functions) do
        values[indx] = func(x)
    end

    for _, ent in ipairs(self.group) do
        local bobbing = ent.bobbing
        local draw = ent.draw

        local value = values[bobbing.phase]

        bobbing.value = 1  +  value * bobbing.magnitude

        bobbing.scale = (bobbing.value * bobbing.magnitude)+(1-bobbing.magnitude)
        bobbing.oy =  - ((bobbing.value-1) * draw.h * -1 * bobbing.magnitude)
    end
end



