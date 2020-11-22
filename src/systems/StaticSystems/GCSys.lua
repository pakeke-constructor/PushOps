


--[[
    Managing the GC

    OLI::: benchmark this!!!
    Make sure you aren't slowing ur program down by fiddling with internals
    like this
]]


local gcSys = Cyan.System()


-- the max number of MB the program should take before full collection triggers
local max_megabytes = 100


local manual_gc = require("libs.NM_manual_gc.manual_gc")




function gcSys:update(dt)
    local time_budget = (2e-3) -- time spent deallocating

    manual_gc(time_budget, max_megabytes, true)
end


