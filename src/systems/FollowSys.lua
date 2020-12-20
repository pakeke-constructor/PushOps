


local FollowSys = Cyan.System("follow", "pos")

--[[

follow comp ::

e.follow = {
    following = e;
    frameGap = 10;   -- Follows 10 frames behind `e`.

    vectors = { };   --Set by system, used by system.
}

]]


local vec3 = math.vec3



function FollowSys:added(E)
    E.follow.vectors = {}
end



local function update(e,dt)
    local follow = e.follow
    local vecs = follow.vectors
    if not(#vecs < follow.frameGap) then
        local newvec = table.remove(vecs, 1)
        e.pos = newvec
    end
    local pos = follow.following.pos
    
    -- Gotta make a copy
    vecs[#vecs+1] = vec3(pos.x, pos.y, pos.z)
end




function FollowSys:update(dt)
    for _,e in ipairs(self.group) do
        update(e,dt)
    end
end






-- To ensure that following ents don't have physics comp.
-- This would REALLY screw things up.
local ErSys = Cyan.System("physics", "follow")


local er1 = "Entities cannot have `physics` and `follow` components!"
function ErSys:added(ent)
    error(er2)
end





