
local RotSys = Cyan.System("rot")


function RotSys:update(dt)
    for _,e in ipairs(self.group) do
        if e.avel then
            e.rot = (e.rot + e.avel) % (2*math.pi)
        end
    end
end




