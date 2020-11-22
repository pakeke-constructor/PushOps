

local SigilSys = Cyan.System("sigils", "draw", "pos")
--[[

Sigils are displayed when the entity in question is under a special effect,
e.g. a speed-boost.

But it can also be used for other stuff.
such as when an ent is being pushed, a target could appear above it (The target being a sigil)



It's probably best to refer to different types of sigils as strings, and keep
the actual sigil objects in this system.


Each file in `src.misc.sigils` represents a sigil object.
Each sigil object has (or will have) these methods:
:draw(ent), :update(ent, dt), :staticUpdate(dt), :removed(ent), and :added(ent) method.

Each sigil function takes the entity as it's first argument.

]]


local Sigil_keys = { }

local Sigils = require("src.misc.sigils.sigils")

for key, _ in pairs(Sigils)do
    table.insert(Sigil_keys, key)
end


assert(Sigils, "hello??? hm")



local function updateSigil(ent, dt)
    for _,sig in ipairs(ent.sigils) do
        Sigils[sig].update(ent, dt)
    end
end

function SigilSys:update(dt)
    for _, sig in ipairs(Sigil_keys) do
        Sigils[sig].staticUpdate(dt)
    end

    for _, ent in ipairs(self.group) do
        updateSigil(ent, dt)
    end
end





local function drawSigil(ent)
    for _,sig in ipairs(ent.sigils) do
        Sigils[sig].draw(ent)
    end
end

function SigilSys:drawEntity(ent)
    if self:has(ent) then
        drawSigil(ent)
    end
end


function SigilSys:added(ent)
    for _,v in ipairs(ent.sigils) do
        SigilSys:addSigil(ent, v)
    end
end


function SigilSys:removeSigil(ent, sigilName)
    local sigils = ent.sigils
    local len = #sigils

    for i, sig in ipairs(sigils) do
        if sig == sigilName then
            sigils[i], sigils[len] = sigils[len], nil
            Sigils[sigilName]:removed(ent)
            break
        end
    end
end


local function has(t,v)
    for i=1,#t do
        if t[i] == v then return true end
    end
    return false
end


local missing_sigil_err = "Unknown sigil string: %s"

function SigilSys:addSigil(ent, sigilName)
    assert(Sigils[sigilName], missing_sigil_err:format(sigilName))
    Sigils[sigilName]:added(ent)

    if not has(ent.sigils, sigilName) then
        table.insert(ent.sigils, sigilName)
    end
end




