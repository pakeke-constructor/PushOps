


local SwaySys = Cyan.System("swaying", "draw")
--[[

For entities that are swaying back and forth.

]]




local sin = math.sin
local rand_choice = Tools.rand_choice


-- Speed at which entities "sway"
local speed = 3



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

function SwaySys:added(ent)
    ent.swaying.phase = rand_choice(t)
    if not ent.swaying.magnitude then
        ent.swaying.magnitude = 5
    end
end






local x = 0
function SwaySys:update(dt)
    x = x + (dt * speed)

    for indx, func in ipairs(functions) do
        values[indx] = func(x)
    end

    for _, ent in ipairs(self.group) do
        local swaying = ent.swaying
        local value = values[swaying.phase]
        local draw = ent.draw

        swaying.value = value * swaying.magnitude
        swaying.ox = (draw.w * swaying.value)
    end
end



