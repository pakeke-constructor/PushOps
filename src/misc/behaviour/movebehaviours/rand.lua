

local RAND={}


function RAND:init(e)
    local move=e.behaviour.move
    local x,y = self.chooseRandPos(e, move.distance or self.DEFAULT_DIST)
    move.target = math.vec3(x,y,0)
    move.initialized = true
end


function RAND:update(e,dt)
    local pos = e.pos
    local move = e.behaviour.move
    if not move.initialized then
        self:init(e)
    end
    local target = move.target
    self.updateGotoTarget(e, target.x, target.y, dt)
    if self.dist(target.x - pos.x, target.y - pos.y) < 40 then
        move.initialized = false
    end
end



return setmetatable(RAND, require(Tools.Path(...)..".base"))

