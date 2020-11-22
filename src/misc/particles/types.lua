

local ParticleTypes = { }


local pth = Tools.Path(...)

Tools.req_TREE(pth:gsub("%.","/") .. "/_emitters", ParticleTypes)

--[[

Particle emitter objects are NOT love2d particleSystems!!!
Each particle emitter object must abide to the following rules :::


It must have an `:emit(x, y, amount)` function.
It must have an `:isFinished() function, to check if it has finished it's emission
It must have a `:clone()` function.
It must have a `:release()` function.
It must have an `:update(dt)` function, to keep track of how long it's particles have existed for
It must have a `:draw(x, y, z)` function
It must have a `type` field that tells what type it is. (This MUST also be the file name!!!)
]]


local er1 = "Not given a required function!"

for _, emitr in pairs(ParticleTypes) do
    assert(emitr.emit, er1)
    assert(emitr.isFinished,er1)
    assert(emitr.clone, er1)
    assert(emitr.release, er1)
    assert(emitr.draw, er1)
    assert(emitr.type,er1)
end

return ParticleTypes


