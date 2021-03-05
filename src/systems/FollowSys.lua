




local FollowSys = Cyan.System("follow", "pos")

--[[

follow comp ::

e.follow = {
    following = e;
    distance = 10;   -- Follows 10 units behind `e`.

    detatch = function(e)
        -- called when ent detatches from following ent.
        -- (I.e. when following ent gets deleted)
    end
}

]]


local vec3 = math.vec3

local ccall = Cyan.call




local function project(e, x, y, distance)
    local ep = e.pos
    local proj_x = x - ep.x
    local proj_y = y - ep.y

    local norm = vec3(proj_x, proj_y, 0):normalize()
    norm.x = norm.x * distance
    norm.y = norm.y * distance

    ccall("setPos", e, ep.x + norm.x, ep.y + norm.y)
end




local er1 = "Ent not following an entity"

local cexists = Cyan.exists


local function update(e,dt)
    local follow = e.follow
    assert(follow.following, er1)
    if not cexists(follow.following) then
        if follow.detatch then
            follow.detatch(e)
        end
        e:remove("follow")
    else
        local edist = Tools.edist(follow.following, e)
        if edist > follow.distance then
            -- project ents position towards the following ent
            local p = follow.following.pos
            project(e, p.x, p.y, edist - follow.distance)
        end
    end
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





