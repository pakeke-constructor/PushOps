
local base = {}


local Quads = require'assets.atlas'.Quads




function base:initialize()
    if self.prefix then
        --[[
            the prefix assumes that the quads follow the 
        ]]
        self.down = {}
        self.up={}
        self.left={}
        self.right={}
        for _ , i in ipairs{1,2,3,4} do
            table.insert(self.down, Quads[self.prefix.."down_"..tostring(i)])
            table.insert(self.up, Quads[self.prefix.."up_"..tostring(i)])
            table.insert(self.left, Quads[self.prefix.."left_"..tostring(i)])
            table.insert(self.right, Quads[self.prefix.."right_"..tostring(i)])
        end
    end

    assert(self.type, "Not given a type :(")
end


function base:construct(player)
    --[[
        Called when player switches to this character type
    ]]
    assert(self.up)
    assert(self.down)
    assert(self.left)
    assert(self.right)

    local motion = player.motion
    motion.up = self.up
    motion.down = self.down
    motion.left = self.left
    motion.right = self.right

    player.playerType = self.type
end



function base:destruct(player)
    --[[
        Called when player switches to another char type,
        and this one is currently active
    ]]
end



return {__index = base}

