


local PATH = (...)
local final_i = (...):find("%.[^%.]*$")

PATH = PATH:gsub(1, final_i)

return {
    Node = require(PATH..".node"),
    Task = require(PATH..".task").newTask
}

