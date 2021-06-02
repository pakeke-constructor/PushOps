


--[[


Hello, reader

This file is to visualize the scale of my project.
It consists of all the lua files that I am responsible for
making throughout my project. (Other people's libraries
are not shown.)











]]



local Atlas = require("libs.auto_atlas.init")
local atlas = Atlas(2048,2048)--size = 2048 pixels^2
-- 99% of GPUs will support this.
-- if not.....   :/
atlas.path = "assets/sprites/"
local PROXY = setmetatable({}, {__index = function(_,n)
    error("Attempted to access unknown quad =>  " .. tostring(n))
end})
atlas.quads = setmetatable({},
{
    __newindex = function(t,k,v)
        assert(not rawget(PROXY, k), "This image file " ..k .. " is already in the atlas. No duplicate names allowed!")
        rawset(PROXY, k, v)
    end; __index = PROXY
})
atlas.Quads = atlas.quads
atlas.default = atlas.quads
for _, each in ipairs(love.filesystem.getDirectoryItems(
    "assets/sprites/"
)) do
    if not(each:sub(1,1) == "_") then    
        atlas.path = "assets/sprites/"..each.."/"
        for _, each in ipairs(love.filesystem.getDirectoryItems(atlas.path)) do
            atlas:add(each)
        end
    end
end
return atlas
--[[
Copy pasted from love2d website
https://love2d.org/wiki/Config_Files
]]
function _G.love.conf(t)
    t.identity = nil                    -- The name of the save directory (string)
    t.appendidentity = false            -- Search files in source directory before save directory (boolean)
    t.version = "11.3"                  -- The LÖVE version this game was made for (string)
    t.console = true                    -- Attach a console (boolean, Windows only)
    t.accelerometerjoystick = true      -- Enable the accelerometer on iOS and Android by exposing it as a Joystick (boolean)
    t.externalstorage = false           -- True to save files (and read from the save directory) in external storage on Android (boolean)
    t.gammacorrect = false              -- Enable gamma-correct rendering, when supported by the system (boolean)
    t.audio.mic = false                 -- Request and use microphone capabilities in Android (boolean)
    t.audio.mixwithsystem = true        -- Keep background music playing when opening LOVE (boolean, iOS and Android only)
    t.window.title = "Push God"         -- The window title (string)
    t.window.icon = 'assets/icon.png'   -- Filepath to an image to use as the window's icon (string)
    t.window.width = 0                -- The window width (number)
    t.window.height = 0               -- The window height (number)
    t.window.borderless = false         -- Remove all border visuals from the window (boolean)
    t.window.resizable = true          -- Let the window be user-resizable (boolean)
    t.window.minwidth = 1               -- Minimum window width if the window is resizable (number)
    t.window.minheight = 1              -- Minimum window height if the window is resizable (number)
    t.window.fullscreen = false          -- Enable fullscreen (boolean)
    t.window.fullscreentype = "desktop" -- Choose between "desktop" fullscreen or "exclusive" fullscreen mode (string)
    t.window.vsync = 0                  -- Vertical sync mode (number)
    t.window.msaa = 0                   -- The number of samples to use with multi-sampled antialiasing (number)
    t.window.depth = nil                -- The number of bits per sample in the depth buffer
    t.window.stencil = nil              -- The number of bits per sample in the stencil buffer
    t.window.display = 1                -- Index of the monitor to show the window in (number)
    t.window.highdpi = false            -- Enable high-dpi mode for the window on a Retina display (boolean)
    t.window.usedpiscale = true         -- Enable automatic DPI scaling when highdpi is set to true as well (boolean)
    t.window.x = nil                    -- The x-coordinate of the window's position in the specified display (number)
    t.window.y = nil                    -- The y-coordinate of the window's position in the specified display (number)
    t.modules.audio = true              -- Enable the audio module (boolean)
    t.modules.data = true               -- Enable the data module (boolean)
    t.modules.event = true              -- Enable the event module (boolean)
    t.modules.font = true               -- Enable the font module (boolean)
    t.modules.graphics = true           -- Enable the graphics module (boolean)
    t.modules.image = true              -- Enable the image module (boolean)
    t.modules.joystick = true           -- Enable the joystick module (boolean)
    t.modules.keyboard = true           -- Enable the keyboard module (boolean)
    t.modules.math = true               -- Enable the math module (boolean)
    t.modules.mouse = true              -- Enable the mouse module (boolean)
    t.modules.physics = true            -- Enable the physics module (boolean)
    t.modules.sound = true              -- Enable the sound module (boolean)
    t.modules.system = true             -- Enable the system module (boolean)
    t.modules.thread = true             -- Enable the thread module (boolean)
    t.modules.timer = true              -- Enable the timer module (boolean), Disabling it will result 0 delta time in love.update
    t.modules.touch = true              -- Enable the touch module (boolean)
    t.modules.video = true              -- Enable the video module (boolean)
    t.modules.window = true             -- Enable the window module (boolean)
end
local utf8 = require("utf8")
local function error_printer(msg, layer)
	print((debug.traceback("Error: " .. tostring(msg), 1+(layer or 1)):gsub("\n[^\n]+$", "")))
end
function _G.love.errorhandler(msg)
	msg = tostring(msg)
	error_printer(msg, 2)
	if not love.window or not love.graphics or not love.event then
		return
	end
	if not love.graphics.isCreated() or not love.window.isOpen() then
		local success, status = pcall(love.window.setMode, 800, 600)
		if not success or not status then
			return
		end
	end
	-- Reset state.
	if love.mouse then
		love.mouse.setVisible(true)
		love.mouse.setGrabbed(false)
		love.mouse.setRelativeMode(false)
		if love.mouse.isCursorSupported() then
			love.mouse.setCursor()
		end
	end
	if love.joystick then
		-- Stop all joystick vibrations.
		for i,v in ipairs(love.joystick.getJoysticks()) do
			v:setVibration()
		end
	end
	if love.audio then love.audio.stop() end
	love.graphics.reset()
	local font = love.graphics.setNewFont(14)
	love.graphics.setColor(0, 1, 0, 1)
	local trace = debug.traceback()
	love.graphics.origin()
	local sanitizedmsg = {}
	for char in msg:gmatch(utf8.charpattern) do
		table.insert(sanitizedmsg, char)
	end
	sanitizedmsg = table.concat(sanitizedmsg)
	local err = {}
	table.insert(err, "ahhh crap man, its error time.\nIf you can, please contact Oli and show a full screenshot of this screen. TY!\n       PLATFORM : "
					..tostring(love.system.getOS() or "unknown OS"))
	table.insert(err, sanitizedmsg)
	if #sanitizedmsg ~= #msg then
		table.insert(err, "Invalid UTF-8 string in error message.")
	end
	table.insert(err, "\n")
	for l in trace:gmatch("(.-)\n") do
		if not l:match("boot.lua") then
			l = l:gsub("stack traceback:", "Traceback\n")
			table.insert(err, l)
		end
	end
	local p = table.concat(err, "\n")
	p = p:gsub("\t", "")
	p = p:gsub("%[string \"(.-)\"%]", "%1")
	local function draw()
		local pos = 70
		love.graphics.clear(0,0,0)
		love.graphics.printf(p, pos, pos, love.graphics.getWidth() - pos)
		love.graphics.present()
	end
	local fullErrorText = p
	local function copyToClipboard()
		if not love.system then return end
		love.system.setClipboardText(fullErrorText)
		p = p .. "\nCopied to clipboard!"
		draw()
	end
	if love.system then
		p = p .. "\n\nPress Ctrl+C or tap to copy this error"
	end
	return function()
		love.event.pump()
		for e, a, b, c in love.event.poll() do
			if e == "quit" then
				return 1
			elseif e == "keypressed" and a == "escape" then
				return 1
			elseif e == "keypressed" and a == "c" and love.keyboard.isDown("lctrl", "rctrl") then
				copyToClipboard()
			elseif e == "touchpressed" then
				local name = love.window.getTitle()
				if #name == 0 or name == "Untitled" then name = "Game" end
				local buttons = {"OK", "Cancel"}
				if love.system then
					buttons[3] = "Copy to clipboard"
				end
				local pressed = love.window.showMessageBox("Quit "..name.."?", "", buttons)
				if pressed == 1 then
					return 1
				elseif pressed == 3 then
					copyToClipboard()
				end
			end
		end
		draw()
		if love.timer then
			love.timer.sleep(0.1)
		end
	end
end
local s = [[
 ###################### 
########################
########################
########################
#########l##ll##########
#######l%%%%%%%%%#######
######l%%       %%l#####
#####l%%    ^    %%l####
######%   ^ ^ ^   %l####
######%   ^ ^ ^   %l####
######% ^  xMx  ^ %#####
######%   ^^@^^   %#####
######% ^  x^x  ^ %l####
######%   ^ ^ ^   %l####
######%   ^ ^ ^   %l####
#####l%%    ^    %%l####
######l%%       %%l#####
#######l%%%%%%%%%l######
########l#ll############
########################
########################
########################
 ###################### 
]]
local map = {}
for line in s:gmatch("[^\n]+") do
    local n = {}
    for i=1,line:len() do
        table.insert(n, line:sub(i,i))
    end
    table.insert(map, n)
end
return map
local PATH = (...):gsub('[%.%/]init','')
local binpack = require(PATH..".binpack")
local lg = love.graphics
local atlas = {}
local atlas_mt = { __index = atlas }
atlas.__new = function(_,x, y, maxSprites)
    maxSprites = maxSprites or 15000
    local x = x or 2048
    local y = y or 2048
    local image = lg.newImage(love.image.newImageData(x, y))
    return setmetatable({
        width = x, height = y,
        binpack = binpack(x, y),
        image = image,
        path = "",
        default = nil,
        batch = love.graphics.newSpriteBatch(image, maxSprites)
    }, atlas_mt)
end
local lg_draw = lg.draw
function atlas:nb_draw(quad, x, y, r, sx, sy, ox, oy, kx, ky )
    -- No batch draw
    lg_draw( self.image, quad, x, y, r, sx, sy, ox, oy, kx, ky )
end
function atlas:b_draw(quad, x, y, r, sx, sy, ox, oy, kx, ky )
    -- Batch draw
    self.batch:add( quad, x, y, r, sx, sy, ox, oy, kx, ky )
end
atlas.draw = atlas.nb_draw
function atlas:flush()
    if not(self.using_batch) then
        return
    end
    self.batch:flush()
    lg_draw(self.batch)
    self.batch:clear()
end
function atlas:useBatch(bool)
    --[[
        atlas:useBatch(true) -- if we want to use batches.
    ]]
    self.using_batch = bool
    if bool then
        self.draw = atlas.b_draw
    else
        self.draw = atlas.nb_draw
    end
end
function atlas:add(sprite, quad)
    if not (type(sprite) == "string") then
        assert(sprite:typeOf("Image"), " atlas:add( image, [quad] )  expected image to be of type \n Image. instead, got type:  "..tostring(type(sprite)))
    end
    lg.push( "all" )
    lg.reset()
    -- Is path.
    if type(sprite) == "string" then
        local sprite_path = self.path..sprite
        if self.type then
            if self.type:match("%.") then
                sprite_path = sprite_path..self.type
            else
                sprite_path = sprite_path.."."..self.type
            end
        end
        sprite = lg.newImage(sprite_path)
        local width,height = sprite:getWidth(), sprite:getHeight()
        local new = self.binpack:insert(width+1, height+1)
        -- Converting Image to Canvas:
        local temp_canvas = lg.newCanvas(width, height)
        lg.setCanvas(temp_canvas)
        lg.draw(sprite)
        lg.setCanvas()
        -- Canvas to ImageData:
        local img_data = temp_canvas:newImageData()
        -- ImageData w/ Image:replacePixels
        self.image:replacePixels(img_data, nil, 1, new.x, new.y)
        lg.pop()
        local ret_quad = lg.newQuad(new.x, new.y, width, height, self.width, self.height)
        if self.default then
            sprite_path = sprite_path:gsub(self.path, "")
            :gsub(".png","")
            self.default[sprite_path] = ret_quad
        end
        return ret_quad
    end
    -- Is image  +  quad.
    if quad then
        assert(quad:typeOf("Quad"), " atlas:add( image, [quad] )  expected optional arg [quad] to be of type \n quad. instead, got type:  "..tostring(type(quad)))
        local _, _, width, height = quad:getViewport()
        local new = self.binpack:insert(width+1, height+1)
        -- Converting Image to Canvas:
        local temp_canvas = lg.newCanvas(width, height)
        lg.setCanvas(temp_canvas)
        lg.draw(sprite)
        lg.setCanvas()
        local img_data = temp_canvas:newImageData()
        -- ImageData w/ Image:replacePixels
        self.image:replacePixels(img_data, nil, 1, new.x, new.y)
        lg.pop()
        return lg.newQuad(new.x, new.y, width, height, self.width, self.height)
    -- Is image.
    else
        local width, height = sprite:getWidth(), sprite:getHeight()
        local new = self.binpack:insert(width+1, height+1)
        -- Converting Image to Canvas:
        local temp_canvas = lg.newCanvas(width, height)
        lg.setCanvas(temp_canvas)
        lg.draw(sprite)
        lg.setCanvas()
        -- Canvas to ImageData:
        local img_data = temp_canvas:newImageData()
        -- ImageData w/ Image:replacePixels
        self.image:replacePixels(img_data, nil, 1, new.x, new.y)
        lg.pop()
        return lg.newQuad(new.x, new.y, width, height, self.width, self.height)
    end
end
return setmetatable(atlas, {__call = function(_, a1, a2) return atlas.__new(_, a1, a2) end})
local PATH = (...)
local final_i = (...):find("%.[^%.]*$")
PATH = PATH:gsub(1, final_i)
return {
    Node = require(PATH..".node"),
    Task = require(PATH..".task").newTask
}
local PATH = (...):gsub('%.[^%.]+$', '')
local task_lua = require(PATH..".task")
local newTask = task_lua.newTask
local NodesAndTasks = task_lua.NodesAndTasks
task_lua = nil
local Node = {
    type = "Node"
}
local parsePath
local newNode
local Node_mt = {
    __index = Node;
    __newindex = function(node,k,v)
        if k == "choose" then
            -- Then we are looking at a `choose` function
            if type(v) ~= "function" then
                error("expected function for choose, got : "..tostring(type(v)))
            end
            rawset(node,k,v)
        elseif k == "parent" then
            rawset(node,k,v)
            return -- We leave parent nodes alone
        else
            -- Else, it must be a path
            if type(v) ~= "table" then
                error("expected table for path `"..tostring(k).."`, got: " .. tostring(type(v)))
            end
            rawset(node.paths,k,v)
            parsePath(node, k)
        end
    end
}
local weakMT = {__mode = "k"}
function parsePath(node, path)
    local pathArr = node.paths[path]
    for i, task in ipairs(pathArr) do
        if type(task) == "string" then
            local taskname = task
            task = NodesAndTasks[taskname]
            if not task then
                error("unrecognized task string: "..taskname)
            end
        end
        if task.type == "Node" then
            -- Second arg means that this is a copy
            pathArr[i] = newNode(nil, task)
        elseif task.type == "Task" then
            -- Second argument means that this instance is a copy.
            pathArr[i] = newTask(nil, task)
        else
            -- unrecognized type
            error("unrecognized type passed into Node path. Only Nodes, Tasks, and/or task/node string names allowed.")
        end
        pathArr[i].parent = node
    end
    return pathArr
end
function newNode(name, copy)
    -- `copy` optional argument
    if type(name)~= "string" then
        error("BehaviourTree.Node( arg ) expected arg as type string, not "..type(name))
    end
    local node = {name = name}
    node._ent_paths = setmetatable({ }, weakMT)
    node._ent_indexes = setmetatable({ }, weakMT)
    node.parent = nil -- Parent node
    node.paths = { } -- list of paths
    node.callbacks = { }
    setmetatable(node, Node_mt)
    if copy then
        assert(copy.type == "Node", "Expected node")
        node.callbacks = copy.callbacks
        node.choose = copy.choose
        for pathname, task_arr in pairs(copy.paths) do
            local newArr = {}
            for i, t_or_n in ipairs(task_arr) do
                if t_or_n.type == "Node" then
                    -- Then its node
                    newArr[i] = newNode(nil, t_or_n)
                elseif t_or_n.type == "Task" then
                    -- else its a task
                    newArr[i] = newTask(nil, t_or_n)
                else
                    -- else... wat? Error
                    error("Attempted to copy something that wasn't node nor task")
                end
            end
            node.paths[pathname] = newArr
            parsePath(node, pathname)
        end
    end
    if name then
        assert(node, "Node is nil??")
        NodesAndTasks[name] = node
    end
    return node
end
function Node:choose()
    error("Node `".. (tostring(self.name) or '') .."` not given :choose(obj) function!")
end
function Node:_reset(ent)
    --[[
        _reset node state and child state
    ]]
    local i = self._ent_indexes[ent]
    i = i or 1
    local path = self._ent_paths[ent]
        if path then
        local current = self.paths[path][i]
        if current.type == "Node" then
            -- Then its a Node, recursive _reset
            current:_reset(ent)
        else
            -- Then its a Task, _reset as well
            current:_reset(ent)
        end
    end
    self._ent_indexes[ent] = 1
    self._ent_paths[ent] = nil
end
function Node:getPath(ent)
    return self._ent_paths[ent]
end
function Node:update(ent, dt)
    if (not self._ent_paths[ent]) then
        self._ent_indexes[ent] = 1
        self._ent_paths[ent] = self:choose(ent)
    end
    local path = self.paths[self._ent_paths[ent]]
    if not path then
        error("Unrecognized path: "..tostring(self._ent_paths[ent]))
    end
    local t_or_n = path[self._ent_indexes[ent]]
    if t_or_n.type == "Node" then
        t_or_n:update(ent, dt)
    else
        t_or_n:_update(ent, dt)
    end
end
function Node:next(ent)
    local index = self._ent_indexes[ent] + 1
    local path = self.paths[self._ent_paths[ent]]
    if index > (#path) then
        -- If the path overflows ::
        if self.parent then
            self:_reset(ent)
            self.parent:next(ent)
        else
            self:_reset(ent)
        end
    else
        self._ent_indexes[ent] = index
    end
end
function Node:_kill(ent)
    --[[
        _resets root Node
    ]]
    if self.parent then
        self.parent:_kill(ent)
    else
        self:_reset(ent)
    end
end
function Node:on(cb_name, func)
    self.callbacks[cb_name] = func
end
function Node:call(cb_name, ent, ...)
    local f = self.callbacks[cb_name]
    if f then 
        local ret = f(self, ent, ...)
        if ret then
            -- Can change path!
            self:_reset(ent)
            assert(self.paths[ret], "Path does not exist in this Node.")
            self._ent_paths[ent] = ret
        end
    end
end
return newNode
local Task = {
    type = "Task"
}
local Task_mt = {__index = Task}
local PROXY = { }
local NodesAndTasks = setmetatable({ },
{
    __newindex = function(t,k,v)
        if v == nil then
            error("This is an error with BT lib. Tell Oli!")
        end
        if PROXY[k] then
            error("Attempted to overwrite Node or task name: `".. k .."`")
        end
        if not(k:sub(1,1)=="_") then
            -- `_` at start of name denotes private name.
            PROXY[k] = v
        end
    end,
    __index = function(_,k)
        if not PROXY[k] then
            local availables = {}
            for tn,_ in pairs(PROXY) do
                table.insert(availables, tostring(tn))
            end
            local available_str = table.concat(availables, "\n")
            error("Unknown task or node:   " .. k .. "\nHere are all possible options: \n\n" .. available_str)
        end
        return PROXY[k]
    end
})
local runtimeMT = {
    __mode = "k"
    ;__index = function() return 0 end
}
local function newTask(name, copy)
    -- `copy` optional argument
    if name then
        if type(name) ~= "string" then
            error("Expected string for BT.Task( str ), got: "..type(name))
        end
    end
    local task = {name = name}
    task.runtimes = setmetatable({}, runtimeMT)
    if copy then
        task.start = copy.start
        task.update = copy.update
        task.finish = copy.finish
        task.name = "_copy_" .. copy.name
    end
    task.parent = nil -- Parent node this task belongs to
    if name then
        if not copy then
            NodesAndTasks[name] = task
        end
    end
    return setmetatable(task, Task_mt)
end
function Task:runtime(ent)
    return self.runtimes[ent]
end
function Task:_reset(ent)
    --[[
        _resets state of this task entirely
    ]]    
    if self.runtimes[ent] > 0 then
        -- This way, :finish cannot be ran twice.
        self:finish(ent)
    end
    self.runtimes[ent] = nil
end
local er_missing_par = "Task does not have a parent, oli, fix"
local closing_funcs = {
    r = function(task, ent, dt) end;
    n = function(task, ent, dt)
        -- "next" update callback
        assert(task.parent, er_missing_par)
        task:_reset(ent)
        task.parent:next(ent)
    end;
    k = function(task, ent, dt)
        -- "_kill" update callback
        assert(self.parent, er_missing_par)
        self:_reset(ent)
        self.parent:_kill(ent)
    end
}
function Task:_update(ent, dt)
    local runtime = self.runtimes[ent]
    if runtime == 0 then
        self:start(ent,dt)
    end
    self.runtimes[ent] = runtime + dt
    if not self.update then
        error("Task `" .. tostring(self.name) .. "` not given .update function")
    end
    local outcome = self:update(ent, dt)
    if not closing_funcs[outcome] then
        error("Incorrect task close. return either `r`, `k`, or `n`.")
    end
    closing_funcs[outcome](self, ent, dt)
end
function Task:finish(ent, dt)
    -- USER CALLBACK
end
function Task:start(ent, dt)
    -- USER CALLBACK
end
return {
    newTask = newTask,
    NodesAndTasks = NodesAndTasks
}
local CB = { }
local CB_mt = { __index = CB }
local array_2d_index = function(t,k) t[k] = {} return t[k] end
local Callbacks = setmetatable({}, {__index = array_2d_index})
function CB.new()
    local CB_Manager = { }
                    -- 2d array.
    CB_Manager.Callbacks = setmetatable({}, {__index = array_2d_index})
    return setmetatable(CB_Manager, CB_mt)
end
function CB:on(callback_name, func)
    table.insert(self.Callbacks[callback_name], func)
    return self --method chain
end
function CB:call(callback_name, a,b,c,d,e,f)
    for _,each in ipairs(self.Callbacks[callback_name]) do
        each(a,b,c,d,e,f)
    end
    return self -- method chain
end
return CB.new
local Array
Array = {
    __newindex = function(t, _, v)
        local len = t.len + 1
        table.insert(t,v)
        t.len = len
    end
    ;
    add = function(t, v)
        local len = t.len + 1
        table.insert(t,v)
        t.len = len
    end
}
Array.__index = Array
return function()
    return setmetatable({len = 0}, Array)
end
local PATH = (...):gsub('%.[^%.]+$', '')
local Cyan = {
}
local Entity = require(PATH..".ent")
local System = require(PATH..".system")
local WorldControl = require(PATH..".world")
-- Cyan.Entity(); entity ctor
Cyan.Entity = Entity
--Cyan.System(...); system ctor
Cyan.System = System
--[[
 core cyan management
]]
-- Depth is the call depth of a Cyan.call function.
-- It tracks the `depth` of the call so automatic flushing can be done on every root call.
local ___depth = 0
local func_backrefs = System.func_backrefs
do
    function Cyan.call(func_name, ...)
        if ___depth <= 0 then
            Cyan.flush()
            ___depth = 0
        end
        ___depth = ___depth + 1
        --[[
            Calls all systems with the given function. Alias: Cyan.emit
            @arg func @(
                The function name to be called
            )
            @arg ... @(
                Any other arguments sent in after will be passed to system.
            )
            @return Cyan @
        ]]
        local sys
        local Sys_backrefs = func_backrefs[func_name]
        for i = 1, Sys_backrefs.len do
            sys = Sys_backrefs[i]
            if sys.active then
                sys[func_name](sys, ...)
            end
        end
        ___depth = ___depth - 1 -- Depth will be zero if and ONLY IF this call was a root call. (ie called from love.update or love.draw)
    end
    Cyan.emit = Cyan.call
    local non_static_sys_list = System.non_static_systems
    -- set of all entities
    local ___all = Entity.___all
    -- flag to ensure that Cyan.flush() isnt accidentally called recursively
    local is_flush_running = false
    local ccall = Cyan.call -- shorthand
    -- Flushes all entities that need to be deleted
    function Cyan.flush()
        --[[
            Removes all entities marked for deletion.
            @return nil@
        ]]
        if is_flush_running then
            return
        end
        is_flush_running = true
        local sys
        local remove_set = Entity.___remove_set
        local remove_set_objs = remove_set.objects
        local remove_set_len = remove_set.size
        for i = 1, remove_set_len do
            local ent = remove_set_objs[i]
            -- The set of ALL entities
            ___all:remove(ent)
            for index = 1, non_static_sys_list.len do
                sys = non_static_sys_list[index]
                sys:remove(ent)
            end
        end
        remove_set:clear()
        is_flush_running = false
    end
    function Cyan.exists( entity )
        -- checks whether an entity exists, or if it has been deleted.
        return ___all:has(entity)
    end
    local temp_clear_buffer = {}
    function Cyan.clear()
        --[[
            Clears all entities
        ]]
        local tmp = temp_clear_buffer
        for _,e in ipairs(___all.objects) do
            table.insert(tmp, e)
        end
        for i=1,#tmp do
            tmp[i]:delete()
            tmp[i] = nil
        end
        assert(#tmp==0,"buffer should be cleared?")
    end
    -- This is really hacky.. this function was defined in System.lua with access
    -- the bitshift variables keeping track of how many bits are left.
    local _getFreeBits = System._cyan_getFreeBits
    rawset(System,"_cyan_getFreeBits",nil) -- this function is only needed by Cyan.
                    -- dont want to add clutter
    function Cyan.getFreeBits()
        return _getFreeBits()
    end
end
--[[
    World management
    NEEDS TESTING!!!
]]
do
    function Cyan.setWorld(name)
        assert(name, "Cyan.setWorld requires a world name as a string!")
        return WorldControl:setWorld(name, Cyan)
    end
    function Cyan.getWorld()
        return WorldControl:getWorld()
    end
    function Cyan.clearWorld(name)
        assert(name, "Cyan.clearWorld requires a world name as a string!")
        return WorldControl:clearWorld(name, Cyan)
    end
    function Cyan.newWorld(name)
        assert(name, "Cyan.newWorld requires a world name as a string!")
        return WorldControl:newWorld(name, Cyan)
    end
end
--[[
]]
-- Default world is `main`
Cyan.newWorld("main")
Cyan.setWorld("main")
return setmetatable(Cyan, {__metatable = "Defended metatable"})
--@object Entity
--[[
    Entities in Cyan only hold data.  (commonly called "Components")
    The data that an entity holds will determine what systems it gets into.
    For example, an Entity with "pos", "blah", "image", and "health" components
    would get accepted into a system accepting Entities with ("pos", "health")
    components; because it has "pos" and "health".
    You do not need to worry about adding entities to systems; it is done
    automatically.
]]
local PATH = (...):gsub('%.[^%.]+$', '')
local set = require(PATH..".sets")
local array = require(PATH..".array")
local ffi, newmask
do
    if jit and jit.status() and false then -- We can't use this because luaJIT doesn't
        ffi = require "ffi"                -- support bitops in this version.
    end
    if ffi then
        basemask = bit.tobit(ffi.new("long", 0)) -- the bit mask that is assigned to each component.
    else
        -- unfortunetely no FFI
        basemask = bit.tobit(0)
    end
end
local System = require (PATH..".system")
local comp_backrefs = System.comp_backrefs
local Entity = {
    --[[
        ___component_check is a read only field that tells
        Cyan whether to do assertions of components;
        by default is set to false.
        To set it to true, call Cyan.setComponents, and pass
        in a table of keyed-components pointing to true.
    ]]
    ___remove_set = set()
    ;
    -- A list of user-defined types for fast entity construction.
    ___types = { }
    ;
    -- A set of ALL entities
    ___all = set()
}
local Entity_mt
local er_1
do
    er_1 = "Attempted to add uninitialized component to entity.\nPlease initialize components in Cyan.components before use."
    Entity_mt = {
        __index = Entity
        ;
        __newindex = function(t, k, v)
            t:add(k, v)
        end
        ;
        -- Defend metatable
        __metatable = "Defended Metatable!!"
    }
end
local Sys_comp_bits = System.component_bits
local bit_bnot = bit.bnot
local bit_bor = bit.bor
local bit_band = bit.band
local function modmask(ent, comp_name)
    -- modifies byte mask
    ent.___mask = bit_bor(ent.___mask, Sys_comp_bits[comp_name])
end
local function demodmask(ent, comp_name)
    ent.___mask = bit_band(
        ent.___mask, bit_bnot( Sys_comp_bits[comp_name] )
    )
end
-- CTOR
function Entity:new()
    --[[
        @return Entity entity@
    ]]
    local ent = {
        ___mask = basemask * 1 -- Multiply by 1 to create memory unique copy 
                               -- (shouldnt matter for non-ffi data)
    }
    Entity.___all:add( ent )
    return setmetatable(ent, Entity_mt)
end
function Entity:has( comp_name )
    --[[
        Gets whether the entity has a component or not.
        @arg string comp_name @(
            The component name, as a string
        )
        @return bool @ True if entity has component, else false
    ]]
    return ((rawget(self, comp_name) and true) or false)
end
local comp_bits = System.component_bits
-- Adds component to entity
function Entity:add( comp_name, comp_val )
    --[[
        Adds a component to an entity and adds to new respective systems
        @arg string comp_name @ The name of the component
        @arg comp_value @ Value of the component, can be anything.
        @return self
    ]]
    assert(comp_backrefs[comp_name], er_1)
    -- modify byte mask, but only if the component is required for systems.
    if comp_bits[comp_name] then
        modmask(self, comp_name)
    end
    -- need to check before it is added.
    local has = self:has(comp_name)
    rawset(self, comp_name, comp_val)
    -- Checks if component is new, and not an overide. If so, will send to systems;
    if not has then
        self:_send_to_systems( comp_name )
    end
    return self
end
-- adds component to entity without invoking any system search.
function Entity:rawadd( comp_name, comp_value )
    --[[
        Adds a component to an entity WITHOUT adding to any systems
        @arg string comp_name @ The name of the component
        @arg comp_value @ Value of the component, can be anything.
        @return self
    ]]
    assert(comps_backrefs[comp_name], er_1)
    rawset(self, comp_name, comp_value)
    return self
end
-- Immediately destroys entity component and removes from systems.
-- (Does not account for whether it's safe or not.)
function Entity:remove( comp_name )
    --[[
        Immediately destroys entity component and removes from relevant systems.
        Does not account for whether it is safe.
        @arg string comp_name @ The name of the component to be removed
        @return self
    ]]
    for i=1, comp_backrefs[comp_name].len do
        local sys = comp_backrefs[comp_name][i]
        sys:remove(self)
    end
    self[comp_name] = nil
    demodmask(self, comp_name)
    return self
end
-- Deletes component without removing from systems
function Entity:rawremove( comp_name )
    --[[
        Immediately destroys entity component WITHOUT removing from systems.
        @arg string comp_name @ The name of the component to be removed
        @return self
    ]]
    self[comp_name] = nil
    demodmask(ent, comp_name)
    return self
end
function Entity:delete()
    --[[
        Marks the entity for deletion
        Entity will be deleted the next time Cyan.flush() is called
        @return self
    ]]
    Entity.___remove_set:add(self)
    return self
end
Entity.destroy = Entity.delete -- alias
--
-- SENDING ENT TO SYSTEMS
--
-- GETTING ENT SYSTEMS
--
do
    -- Gets all the systems the entity needs to be added to
    -- upon recieving given component
    function Entity:_get_systems( comp )
        local getted_systems = { }
        -- TODO: change this to bitops.
        for i=1, comp_backrefs[comp].len do
            local sys = comp_backrefs[comp][i]
            if sys:worthy(self) then
                table.insert(getted_systems, sys)
            end
        end
        return getted_systems
    end
    function Entity:_send_to_systems(comp)
        for i=1, comp_backrefs[comp].len do
            local sys = comp_backrefs[comp][i]
            if sys:worthy( self ) then
                -- Adds entity to system (passed all requirements)
                sys:add(self)
            end
        end
    end
    -- Gets all systems of Entity:
    -- VERY SLOW OPERATION! O(n^2)
    -- Also high space complexity; O(n) garbage-sets created.
    function Entity:_get_all_systems()
        -- TODO: change to bitops
        local systems = set()
        local comps = array()
        for comp, _ in pairs(self) do
            comps:add(comp)
        end
        for _, comp in ipairs(comps) do
            local sys_tabl = self:_get_systems(comp)
            for _, sys in ipairs(sys_tabl) do
                systems:add(sys)
            end
        end
        return systems.objects
    end
    Entity.getSystems = Entity._get_all_systems
end
return setmetatable(Entity,
    {__call = Entity.new,
    __newindex = function()
        error("main table `Entity` is read-only")
    end,
    __metatable = "Defended metatable"}
)
--@object System
--[[
    "Systems" in Cyan are objects that automatically take entities
    and apply functions to them.
    A system will only take an entity if it has all of the required
    components.
    Systems can be created using  cyan.System(...)
    Where ... is the set of components that the system will check in
    an entity before accepting it.
    Access an array of Entities in a system with System.group;
    iterate over with:
    for _, entity in ipairs(mySystem.group) do
    end
]]
local PATH = (...):gsub('%.[^%.]+$', '')
local set = require(PATH..'.sets')
local array = require(PATH..".array")
-- Bitops
local ffi, compbitbase, compbitbase_shiftnum, max_shiftnum
do
    if jit and jit.status() and false then -- We can't use this because luaJIT doesn't
        ffi = require "ffi"                -- support bitops in this version.
                            -- This means that components are limited to 32 :/
    end
    if ffi then
        compbitbase = ffi.new("long", 1) -- the bit mask that is assigned to each component.
        max_shiftnum = 63 -- max is larger as we can access a higher int precision
                          -- (This number is also the maximum number of components available.)
    else
        -- unfortunetely no FFI
        compbitbase = 1
        max_shiftnum = 31 -- max is set to lua precision of 32 bit int. :/
    end
    compbitbase_shiftnum = 1 -- number of bit shifts currently
                             -- (We start at 1 and cap at 31 for safety)
end
local System = {}
do
    -- 2d hasher that holds references to all systems (by component keyword.)
    System.comp_backrefs = setmetatable({},
        {__index = function(t,k) t[k] = array() return t[k] end}
    )
    -- 2d hasher that holds references to all systems that contain given function
    -- (same as System.backrefs, but for functions, not components)
    System.func_backrefs = setmetatable({},
        {__index = function(t,k) t[k] = array() return t[k] end}
    )
    -- A reference to all components that exist. (Or, at least components that affect what systems an entity will get into.)
    System.components = set()
    -- A reference to all the component bit objects by component kw
    System.component_bits = { }
    -- Array that holds all systems   (  arr[-1] = val to add stuff )
    System.systems = array()
    -- Arrays that holds all non-static systems.
    -- i.e. Systems that take entities.
    System.non_static_systems = array()
end
local function newComponent(comp_name)
    if compbitbase_shiftnum > max_shiftnum then
        -- TODO::  make this automatically turn off bitops instead of raising error.
        return error("Too many components. (over "..tostring(max_shiftnum)..") please reduce the number of components you are using.")
    end
    System.component_bits[comp_name] = bit.tobit(compbitbase)
    System.components:add(comp_name)
    -- Checking we haven't reached bit overflow.
    compbitbase_shiftnum = compbitbase_shiftnum + 1
    compbitbase = compbitbase * 2 -- Same as logical bit shift left by 1.
end
function System:_cyan_getFreeBits()
    --[[
        static private function, to be carried into Cyan.
            Returns the number of bit components that are
            yet to be used.
        (note that this function is deleted by Cyan as
        soon as initialization is complete. Its dumb, I know)
    ]]
    return max_shiftnum - compbitbase_shiftnum
end
local function getMask(...)
    -- ... is a list of component names.
    local mask = bit.tobit(0)
    for _, comp in ipairs({...}) do
        assert(System.component_bits[comp], "This component shoulda been initialized. Fix nerd!")
        mask = bit.bor(mask, System.component_bits[comp])
    end
    return mask
end
local System_mt = {
    --[[
    __newindex will be called whenever user does:
    function mySys:draw( ent )
        <blah yada>
    end
    ]]
    __index = System
    ;
    __newindex = function(sys, name, func)
        if type(func) == "function" then
            rawset(sys, name, func)
            -- Add to func_backrefs so can be accessed fast under Cyan.call
            System.func_backrefs[name]:add(sys)
        else
            error("Systems can only have functions added to them.")
        end
    end
    ;
    -- safety first
    __metatable = "Defended metatable"
}
local backrefs = System.comp_backrefs
function System:new( ... )--@ALIAS@ System( ... )
    --[[
        Creates a new system
        ( Same as System(...)  )
        @param string ... @(
            A set of component-strings denoting which entities to accept into system's group
        )
        @ return System system @
    ]]
    local requirement_table = {...}
    for _, comp in ipairs(requirement_table) do
        if not System.components:has(comp) then -- Initialize any new components.
            newComponent(comp)
        end
    end
    local new_sys = {
        ___requirements = requirement_table
        ;
        -- Backend group for this system.
        -- front-end access is done through ___group.objects  (thru sys.group)
        ___group = set()
        ;
        ___mask = getMask(...)
        ;
        active = true
    }
    new_sys.group = new_sys.___group.objects
    -- Adds system to required component-sets in backrefs.
    -- (for easy future access)
    for _, v in pairs(requirement_table) do
        local backref_set = backrefs[v]
        backref_set:add(new_sys)
    end
    -- Adds to system list
    System.systems[-1] = new_sys
    -- Adds to non_static_systems, only if it takes entities.
    if (#requirement_table > 0) then
        -- System takes entities -> it is non-static.
        System.non_static_systems[-1] = new_sys
    end
    return setmetatable(new_sys, System_mt)
end
local band = bit.band
function System:worthy_YES_BITOP(ent)
    -- Returns true if the entity is worthy of being added to system
    -- If jit is on, (which it should be,) this will run like lightning.
    return (band(ent.___mask, self.___mask) == self.___mask)
end
function System:worthy_NO_BITOP(ent)
    -- without bitops.
    for _, requirement in ipairs(self.___requirements) do
        -- If the system has all requirements,
        -- Add it to `getted_systems`
        if not ent[requirement] then
            return false
        end
    end
    return true
end
System.worthy = System.worthy_YES_BITOP
function System:has( ent )
    --[[
        Returns whether the system has an entity, or not.
        @arg Entity ent @ The entity to check if it's in the system
        @return bool @ True if system has the entity, nil otherwise
    ]]
    return self.___group:has(ent)
end
function System:add( ent )
    --[[
        Adds an entity to a system
        @arg Entity ent @ The entity to be added
        @return self
    ]]
    if self:has(ent) then
        return self
    end
    self:added(ent)
    self.___group:add(ent)
    return self
end
function System:remove( ent )
    --[[
        Immediately removes an entity from a system
        @arg Entity ent @ The entity to be removed
        @return self
    ]]
    if self:has(ent) then
        self:removed(ent)
        self.___group:remove(ent)
    end
    return self
end
-- Activates system
function System:activate( )
    --[[
        Activates a system
        @return self
    ]]
    self.active = true
    return self
end
function System:deactivate( )
    --[[
        Deactivates a system
        @return self
    ]]
    self.active = false
    return self
end
function System:clear()
    for _, e in ipairs(self.group)do
        self:remove(e)
    end
end
-- Callback for entity added to system
function System.added()
end
-- Callback for entity removed from system
function System.removed()
end
return setmetatable(System,
    {__call = System.new,
    __newindex = function()
        error("main table `System` is read-only")
    end,
    __metatable = "Defended Metatable"}
)
local PATH = (...):gsub('%.[^%.]+$', '')
local set = require(PATH..'.sets')
local array = require(PATH..".array")
-- World control table.
local WorldControl = {
    current_world = "NONE"
    ;
    current_world_name = "NONE"
    ;
    worlds = {}
}
function WorldControl:setWorld(name, cyan)
    --[[
        Sets current world to the world with name `name`,
        if `name` does not exist, creates a new world as `name`.
    ]]
    self.current_world = name
    self.current_world_name = name
    self.worlds[name] = self.worlds[name] or WorldControl:newWorld(name, cyan)
    local world = self.worlds[name]
    -- world.systems data structure is weird, a bit spagetti like:
    --[[
        world.systems is a table holding all system objects as keys,
        and `sets` as values. The sets correspond to this world's ___groups
        for that particular system.
    ]]
    for sys, group in pairs(world.systems) do
        sys.___group = group
    end
end
function WorldControl:newWorld(name, cyan)
    --[[
        Makes new world with name `name`
    ]]
    -- Checking for no mem leak
    do
        local num_worlds = #self.worlds + 1
        if num_worlds > 30 then
            error'You have created over 30 worlds... Are you sure you need that many? Or is this a memory leak'
        end
    end
    local world = {
        systems = {};
        types = {}
    }
    self.worlds[name] = world
    local systems = cyan.System.systems
    -- Add all systems to world
    for _, sys in ipairs(systems) do
        -- Create new group for each system.
        world.systems[sys] = set()
        -- When changed world, set this system's group to this worlds' system's group.
    end
    return name
end
function WorldControl:getWorld()
    --[[
        returns string name of world in use.
    ]]
    return self.current_world_name
end
function WorldControl:clearWorld(name, cyan)
    --[[
        Clears all system groups for this world, and envokes a flush
        Heavy function, pretty high complexity I think
    ]]
    name = name or self:getWorld()
    local world = self.worlds[name]
    assert(world, "Attempted to clear a world that didn't exist!")
    for sys, group in pairs(world.systems) do
        group:clear()
    end
    local current_world = self:getWorld()
    -- Must envoke flush under the world that is going to be flushed
    self:setWorld(name)
    cyan.flush()
    self:setWorld(current_world)
end
return setmetatable(WorldControl,
    {__newindex = function()
        error("Hey this guy is read only")
    end;
    __metatable = "topolololology"
    }
)
-- dot prod
return function(x1,y1, x2,y2)
    return (x1 * x2) + (y1 * y2)
end
local tostring = tostring
local mutstr = {}
function mutstr:len()
    return self.length
end
mutstr.sub = table.concat
function mutstr:lower()
    for i = 1, self:len() do
        self[i] = self[i]:lower()
    end
    return self
end
function mutstr:reverse()
    local len = self.length
    for i = 1, self.length do
        self[i], self[len - i] = self[len - 1], self[i]
    end
    return self
end
function mutstr:rep( num )
    for i = 1, num-1 do
    end
end
local mutstr_mt = {}
mutstr_mt.__call = function(_, str)
    local new = setmetatable({
        length = 0;
    }, mutstr_mt)
    for i = 1, str:len() do
        new[i] = str:sub(i,i)
        new.length = new.length + 1;
    end
    return new
end
mutstr_mt.__eq = function(self, oth)
    if type(oth) == "string" then
        if self:len() ~= oth:len() then
            return false
        end
        for i = 1, self:len() do
            if self[i] ~= oth:sub(i,i) then
                return false
            end
        end
        return true
    else -- must be a table.
        if self:len() ~= oth:len() then
            return false
        end
        for i = 1, self:len() do
            if self[i] ~= oth[i] then
                return false
            end
        end
        return true
    end
end
mutstr_mt.__concat = function(self, str)
    if type(str) == "string" then
        for i = 1, str:len() do
            self[i] = str:sub(i,i)
            self.length = self.length + 1;
        end
    else -- is table (mutstr)
        for i = 1, str:len() do
            self[i] = str[i]
            self.length = self.length + 1;
        end
    end
end
mutstr_mt.__tostring = function(tabl)
    return table.concat( tabl )
end
--[[
    @module spatial_partition
    partition expects all objects added to have a `x` and `y` component
NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB
NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB
NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB
NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB
NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB
NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB
NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB
NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB
NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB
NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB
NOTE !!!!!
THIS MODULE HAS BEEN MODIFIED TO SUIT PUSH_GAME !!!!!!
DO NNNOOOOTTTT EXPORT TO GITHUB
]]
-- path to file
local PATH = (...):gsub('%.[^%.]+$', '')
-- math set O(1) removal
local set = require(PATH..".sets")
local floor = math.floor
local Partition = {}
local mt = {__index = function(t,k)
    t[k] = setmetatable({}, {__index = function(te,ke)
        te[ke] = set()
        return te[ke]
    end})
    return t[k]
end}
function Partition:new(size_x, size_y)
    local new = {}
    new.size_x = size_x
    new.size_y = size_y
    new.moving_objects = set()
    for k, v in pairs(self) do
        new[k] = v
    end
    return setmetatable(new, mt)
end
function Partition:clear()
    for key, val in pairs(self) do
        if type(key) == "number" then
            self[key] = nil
        end
    end
end
function Partition:update()
    for _, obj in ipairs(self.moving_objects.objects) do
        self:updateObj(obj)
    end
end
function Partition:updateObj(obj)
    -- ___rem and ___add functions have been inlined for performance.
    self:getSet(obj):remove(obj)   -- Same as self:___rem(obj)
    self[floor(obj.pos.x/self.size_x)][floor(obj.pos.y/self.size_y)]:add(obj) -- Same as self:___add(obj)
end
function Partition:___add(obj)
    self[floor(obj.pos.x/self.size_x)][floor(obj.pos.y/self.size_y)]:add(obj)
end
function Partition:___rem(obj)
    self:getSet(obj):remove(obj)
end
function Partition:setPosition(obj, x, y)
    --[[
        Note that the user must change the x,y fields independently,
        after this function has been called
    ]]
    self:___rem(obj)
    self[floor(x/self.size_x)][floor(y/self.size_y)]:add(obj)
end
function Partition:add(obj)
    self.moving_objects:add(obj)
    self:___add(obj)
end
function Partition:remove(obj)
    self.moving_objects:remove(obj)
    self:___rem(obj)
end
function Partition:size(x,y)
    --returns the size of the cell at x, y
    return #(self[floor(x/self.size_x)][floor(y/self.size_y)].objects)
end
function Partition:frozenAdd(obj)
    -- This obj stays in a constant position.
    -- Much more efficient- use when possible
    self:___add(obj)
end
local er1 =
[[Object disappeared from recorded location in spacial partitioner.
Ensure that your spacial hasher has a cell-size that is greater than the maximum velocity of any hashed object.
]]
function Partition:getSet(obj)
    local x, y = floor(obj.pos.x/self.size_x), floor(obj.pos.y/self.size_y)
    if (x ~= x) or (y ~= y) then -- Checking for nasty NaNs.
        Tools.dump(obj, "NaN found in entity position component. Good luck mate.. youll need it\n")
        error("Not a number (NaN) found in obj " .. tostring(obj) .. ". Ensure objects don't have NaN as their x or y fields.", 2)
    end
    local set_ = self[x][y]
    -- Try for easy way out: Assume the object hasn't moved out of it's cell
    if set_:has(obj) then
        return set_, x, y
    end
    -- This is what unnessesary performance squeezing looks like. (Used to be a loop)
    -- Horizontal and vertical cells are checked first as they are the most likely case.
    set_ = self[x-1][y]
    if set_:has(obj) then
        return set_, x-1, y
    end
    set_ = self[x+1][y] 
    if set_:has(obj) then
        return set_, x+1, y
    end
    set_ = self[x][y-1]
    if set_:has(obj) then
        return set_, x, y-1
    end
    set_ = self[x][y+1]
    if set_:has(obj) then
        return set_, x, y+1
    end
    set_ = self[x-1][y-1]
    if set_:has(obj) then
        return set_, x-1, y-1
    end
    set_ = self[x-1][y+1]
    if set_:has(obj) then
        return set_, x-1, y+1
    end
    set_ = self[x+1][y-1]
    if set_:has(obj) then
        return set_, x+1, y-1
    end
    set_ = self[x+1][y+1]
    if set_:has(obj) then
        return set_, x+1, y+1
    end
    --[[
    Old code::: This is functionally equivalent to above, above is slightly quicker tho
    (Just because we can directly examine the most likely changed positions of obj first)
    for X = x-1, x+1 do
        for Y = y-1, y+1 do
            set_ = self[X][Y]
            if set_:has(obj) then
                return set_, X, Y
            end
        end
    end]]
    -- THIS IS UNIQUE TO PUSH_GAME!!! 
    -- AGAIN, DOOOO NOOOOT push this to github as a standalone!!!!!!!!!
    Tools.dump(obj, "object disappeared from partition:  \n")
    -- Object has moved further than it's cell neighbourhood boundary.
    -- Throw err
    error(er1)
end
-- An extra function that will override Partition:getSet if a call to Partition:setGetters is made.
function Partition:moddedGetSet(obj)
    local x, y = floor(self.___getx(obj)/self.size_x), floor(self.___gety(obj)/self.size_y)
    local set_ = self[x][y]
    -- Try for easy way out: Assume the object hasn't moved out of it's cell
    if set_:has(obj) then
        return set_, x, y
    end
     -- This is what unnessesary performance squeezing looks like. (Used to be a loop)
    -- Horizontal and vertical cells are checked first as they are the most likely case.
    set_ = self[x-1][y]
    if set_:has(obj) then
        return set_, x-1, y
    end
    set_ = self[x+1][y] 
    if set_:has(obj) then
        return set_, x+1, y
    end
    set_ = self[x][y-1]
    if set_:has(obj) then
        return set_, x, y-1
    end
    set_ = self[x][y+1]
    if set_:has(obj) then
        return set_, x, y+1
    end
    set_ = self[x-1][y-1]
    if set_:has(obj) then
        return set_, x-1, y-1
    end
    set_ = self[x-1][y+1]
    if set_:has(obj) then
        return set_, x-1, y+1
    end
    set_ = self[x+1][y-1]
    if set_:has(obj) then
        return set_, x+1, y-1
    end
    set_ = self[x+1][y+1]
    if set_:has(obj) then
        return set_, x+1, y+1
    end
    --[[
    Old code::: This is functionally equivalent to above, above is slightly quicker tho
    (Just because we can directly examine the most likely changed positions of obj first)
    for X = x-1, x+1 do
        for Y = y-1, y+1 do
            set_ = self[X][Y]
            if set_:has(obj) then
                return set_, X, Y
            end
        end
    end]]
    -- Object has moved further than it's cell neighbourhood boundary.
    -- Throw err
    error(er1)
end
-- An extra function that will override Partition:___add if a call to Partition:setGetters is made.
function Partition:modded____add(obj)
    self[floor(self.___getx(obj)/self.size_x)][floor(self.___gety(obj)/self.size_y)]:add(obj)
end
-- An extra function that will override Partition:update_object if a call to Partition:setGetters is made.
function Partition:moddedUpdateObj(obj)
    -- ___rem and ___add functions have been inlined for performance.
    self:getSet(obj):remove(obj)                                     -- Same as self:___rem(obj)
    self[floor(self.___getx(obj)/self.size_x)][floor(self.___gety(obj)/self.size_y)]:add(obj) -- Same as self:___add(obj)
end
function Partition:setGetters( x_getter, y_getter )
    assert(type(x_getter) == "function", "expected type function, got type:  " .. tostring(type(x_getter)))
    assert(type(y_getter) == "function", "expected type function, got type:  " .. tostring(type(y_getter)))
    self.___getx = x_getter
    self.___gety = y_getter
    error("Why/where is this code running")
    self.getSet = self.moddedGetSet
    self.___add = self.modded____add
    self.updateObj = self.moddedUpdateObj
end
-- Iteration handling... here we go
do
    -- local x, y, set_, current, X, Y, sel  <OLD VARS>
    local _ -- (tells _G we arent making globals)
    local closure_caches = { }
    -- holds a table that keeps track of the instances of loops that are currently
     -- running. This way, we can have nested loops.
    local iter
    iter = function( )
        -- `inst` is a reference to this loop instances closure environment.
        -- again, this is done so nested loops are possible.
        local inst = closure_caches[#closure_caches]
        -- If we are at end of set:
        if inst.set_.size < inst.current + 1 then
            if (inst.X-inst.x) < 1 then -- (X-x) will vary from -1 to 1. Same for (Y-y).
                inst.X = inst.X + 1
                inst.set_ = inst.sel[inst.X][inst.Y] -- change sets.
                inst.current = 0 -- reset counter
                return iter()  -- try again; iteration failed
            else
                if (inst.Y-inst.y) < 1 then
                    inst.Y = inst.Y + 1
                    inst.X = inst.x - 1 -- revert X to base case.
                    inst.set_ = inst.sel[inst.X][inst.Y] -- change sets.
                    inst.current = 0 -- reset counter
                    return iter() -- try again; iteration failed
                else -- Else, we have ended iteration, as Y and X have reached above the cell boundaries.
                    inst.set_=nil
                    inst.sel=nil -- (incase Partition is deleted, we dont want a memory leak)
                    closure_caches[#closure_caches] = nil -- pop this iteration state from stack
                    return nil
                end
            end
        else
            inst.current = inst.current + 1
            return inst.set_.objects[inst.current]
        end
    end
    -- Iterates over spacial Partition that `obj_or_x` is in. (including `obj`)
    -- If `x` and `y` are numbers, will iterate over that spacial positioning Partition.
    function Partition:iter(obj_or_x ,y_)
        local inst = { } -- The state of this iteration.
                         -- We can't use closures, because locals are shared
        table.insert(closure_caches, inst)
        if y_ then
            -- obj is a number in this scenario; equivalent to  x.
            inst.x = floor(obj_or_x/self.size_x)
            inst.y = floor(y_/self.size_y)
            inst.set_ = self[inst.x-1][inst.y-1]
            assert(inst.set_, "Problem in spacial partitioner. `set_` is nil")
        else
            _, inst.x, inst.y = self:getSet(obj_or_x)
            inst.set_ = self[inst.x-1][inst.y-1]
            assert(inst.set_, "Problem in spacial partitioner. `set_` is nil")
        end
        inst.X = inst.x-1
        inst.Y = inst.y-1
        inst.current = 0
        inst.sel = self
        return iter
    end
    --    local lx, ly, l_set_, lcurrent, lX, lY, lsel
     -- holds a table that keeps track of the instances of loops that are currently
     -- running. This way, we can have nested loops.
    local l_closure_caches = { }
    local longiter
    longiter = function( )
        local inst = l_closure_caches[#l_closure_caches]
        -- If we are at end of set:
        if inst.l_set_.size < inst.lcurrent + 1 then
            if (inst.lX-inst.lx) < 2 then -- (lX-lx) will varly from -1 to 1. Same for (lY-ly).
                inst.lX = inst.lX + 1
                inst.l_set_ = inst.lsel[inst.lX][inst.lY] -- change sets.
                inst.lcurrent = 0 -- reset counter
                return longiter()  -- try again; iteration failed
            else
                if (inst.lY-inst.ly) < 2 then
                    inst.lY = inst.lY + 1
                    inst.lX = inst.lx - 2 -- revert lX to base case.
                    inst.l_set_ = inst.lsel[inst.lX][inst.lY] -- change sets.
                    inst.lcurrent = 0 -- reset counter
                    return longiter() -- trly again; iteration failed
                else -- Else, we have ended iteration, as lY and lX have reached above the cell boundaries.
                    inst.l_set_=nil
                    inst.lsel=nil -- (incase Partition is deleted, we dont want a memorly leak)
                    l_closure_caches[#l_closure_caches]=nil --pop from stack
                    return nil
                end
            end
        else
            inst.lcurrent = inst.lcurrent + 1
            return inst.l_set_.objects[inst.lcurrent]
        end
    end
    function Partition:longiter(obj_or_x, y_)
        local inst = {} -- The state of this iteration.
                        -- We can't use closures, because locals are shared
        table.insert(l_closure_caches, inst)
        if y_ then
            -- obj is a number in this scenario; equivalent to  lx.
            inst.lx = floor(obj_or_x/self.size_x)
            inst.ly = floor(y_/self.size_y)
            inst.l_set_ = self[inst.lx-1][inst.ly-1]
        else
            _, inst.lx, inst.ly = self:getSet(obj_or_x)
            inst.l_set_ = self[inst.lx-1][inst.ly-1]
        end
        inst.lX = inst.lx-2
        inst.lY = inst.ly-2
        inst.lcurrent = 0
        inst.lsel = self
        return longiter
    end
    -- Aliases
    Partition.each = Partition.iter
    Partition.foreach = Partition.iter
    Partition.loop = Partition.iter
    Partition.longeach = Partition.longiter
    Partition.longforeach = Partition.longiter
    Partition.longloop = Partition.longiter
end
return function(size_x, size_y)
    size_x = size_x or error("A cell-size is needed to make spacial partitioner")
    size_y = size_y or size_x
    return Partition:new(size_x, size_y)
end
local deepcopy
deepcopy = function( tabl, shove )
    local new = {}
    shove = shove or {[tabl] = tabl}
    for ke, val in pairs(tabl) do
        if type(val) == "table" then
            if shove[val] then
                new[ke] = val
            else
                shove[val] = val
                new[ke] = deepcopy(val, shove)
            end
        elseif type(val) == "userdata" then
            if val.clone then
                new[ke] = val:clone() -- love2d
            else
                error "userdata cannot be deepcopied; requires a :clone() method"
            end
        else
            new[ke] = val
        end
    end
    local mt = getmetatable(tabl)
    return setmetatable(new, (mt or nil))
end
return deepcopy
local vec3 = require("libs.tools.vec3")
local pos = SuperStruct(
    {pos = vec3(0,0,0)}
)
local vel = SuperStruct(
    {vel = vec3(0,0,0)}
)
function vel:update(dt)
    self.pos = self.vel + (self.pos * dt)
end
function vel:init()
    assert(self.pos, "velocity requires position")
end
local sprite = SuperStruct(
    {image = true}
)
function sprite:init()
    assert(self.pos, "image requires position")
    self.image = love.graphics.newImage("blah.png")
end
local draw = SuperStruct()
function draw:init()
    assert(self.image)
    assert(self.pos)
end
--[[
Now, combine ::
]]
local gameObject = SuperStruct()
    :attach(pos)
    :attach(vel)
    :attach(draw)
    :attach(sprite)
local obj = gameObject()
obj:init()
local PATH = (...):gsub('%.[^%.]+$', '')
local deepcopy = require(PATH .. ".deepcopy")
local remove = function(tabl, item)
    for i, v in ipairs(tabl) do
        if v == item then
            table.remove(tabl, i)
        end
    end
end
local is_in = function(tabl, item)
    for _, v in ipairs(tabl) do
        if v == item then
            return true
        end
    end
end
local add = table.insert
-- The function name that is currently being called. This is a really unstable way of doing it but it runs fast.
-- (ie better than creating a new anony func each call)
local f_name_upvalue = nil
local function index(STRUCT, a,b,c)
    -- index function for SuperStruct objects.
    -- This function does the main work in ensuring call depth is considered
    local structs = STRUCT.___parent.___attached
    local fval
    for i=1, #structs do
        fval = structs[i][f_name_upvalue]
        if fval then
            fval(STRUCT, a,b,c)
        end
    end
    if STRUCT.___parent[f_name_upvalue] then
        STRUCT.___parent[f_name_upvalue](STRUCT, a,b,c)
    end
    return STRUCT --[[ For method chaining:
    -myStruct:method1()
    :method2()
    :method3()    
    ]]
end
local SuperStruct = {  }
local SuperStruct_mt = {
    __index = SuperStruct;
    __newindex = function(t,k,v)
        assert(type(v) == "function", "Only functions can be added to SuperStructs")
        rawset(t,k,v)
    end
}
local Obj_mt = {
    __index = function(t,k)
        f_name_upvalue = k
        return index
        --[[
            VERY VERY IMPORTANT THING TO KNOW FOR THIS::::
            When accessing functions of structs, the function MUST be called instantly.
                Eg:
                func = struct.update
                struct:draw()
                func(struct) -- Will call struct:draw() again. To see why, see `index` implementation above.
        ]]
    end
}
function SuperStruct:___new()
    -- Creates a new object from the SuperStruct.
    local new = deepcopy(self.___template or {})
    new.___parent = self
    return new
end
SuperStruct_mt.__call = SuperStruct.___new
function SuperStruct:___modify_template(otherStruct)
    local template = self.___template
    if (#otherStruct.___attached > 1) then
        error "Not allowed to attach SuperStructs with other SuperStructs attached.\nRemember: inheritance is evil! Only composition"
    end
    for k,v in pairs(otherStruct.___template) do
        if is_in(template, k) then
            error("This SuperStruct already has a key value called " .. k .. ". Duplicate keys are not allowed!")
        else
            template[k] = v
        end
    end
end
function SuperStruct:___demodify_template(otherStruct)
    local template = self.___template
    for k,_ in pairs(otherStruct.___template) do
        template[k] = nil
    end
end
function SuperStruct:attach(SS)
    add(self.___attached, SS)
    self:___modify_template(SS)
    return self
end
function SuperStruct:detach(SS)
    remove(self.___attached, SS)
    self:___demodify_template(SS)
    return self
end
return function( template, SS ) -- `SS` is an optional argument. Basically is just syntax sugar.
    SS = SS or {}
    SS.___template = setmetatable(template or {}, Obj_mt)
    SS.___attached = {}
    SS.___template.___parent = SS
    return setmetatable(SS, SuperStruct_mt)
end
local remove = function(tabl, item)
    for i, v in ipairs(tabl) do
        if v == item then
            table.remove(tabl, i)
        end
    end
end
local is_in = function(tabl, item)
    for _, v in ipairs(tabl) do
        if v == item then
            return true
        end
    end
end
local add = table.insert
local f_name_upvalue = nil
local call_all = function(STRUCT, a,b,c)
    local funcs = STRUCT.___functions[f_name_upvalue]
    for i=1, #funcs do
        funcs[i](STRUCT, a,b,c)
    end
end
local PATH = (...):gsub('%.[^%.]+$', '')
local deepcopy = require(PATH .. ".deepcopy")
local SuperStruct = {}
local SuperStruct_mt = {
    __index = SuperStruct;
    __call = function(struct)
        return struct:___new()
    end;
    __newindex = function(t,k,v)
        t.___PROXY[k] = v
        for _, chil in ipairs(t.___children) do
        end
    end
}
local SuperStruct_obj_mt = {
    __index = function(table, key)
        -- Mutable state like this is screwy, I know. This will run quick tho
        f_name_upvalue = key
        return call_all
    end
    __newindex = function()
        error("you aren't allowed to add new fields to superStruct objects. \n Should I change this?")
    end
}
--[[
    Superclass is a struct module that works with classes in a unique way.
    It is designed to make inheritance intuitive and spagetti-free.
    PLANNING :::
    Construction is the hard bit. How do you construct something when it relies on
    8 layers of ctor funcs???? Do you just force constructers to have no arguments ???
    Maybe there is no constructor; instead, when you create a struct, you specify what fields the object has.
    i.e:  local Position  =  SuperStruct { x=0, y=0 }        <-- this is probably best idea.
    The only immutable part of classes will be the initial template object!!
    ALL other struct fields must be fully mutable
]]
local array_2d_index = function(t,k) t[k] = {} return t[k] end
local function newSuperStruct( template )
    --[[
        @param template The template object this struct will be based off
        @return SuperStruct The struct that
    ]]
    local struct = {}
    struct.___attached = { } -- list of attached classes (parents)
    struct.___mt       =  SuperStruct_obj_mt -- metatable for objects
    -- 2d Array holding references to all functions
    struct.___functions = setmetatable({}, {__index = array_2d_index})
    -- template struct object.
    template = template or {}
    struct.___template = setmetatable(template, struct.___mt) -- template object
    struct.___children = { } -- list of children structs
    --[[ This table holds all the actual fields of the struct. It needs to be a proxy table for __newindex. 
        For example, if this is done:
        function MyStruct:update()
        end
        .update will be put in the ___PROXY table, and the MyStruct.update will == nil.
        The reason this is done is so if the function is modified, i.e. myStruct.update is changed,
        a warning can be sent out to all children structs to inform them that a change has been made, and for them to respond responsibly.
    ]]
    struct.___PROXY = { }
    return setmetatable(struct, SuperStruct_mt)
end
function SuperStruct:___new()
    return deepcopy( self.___template )
end
function SuperStruct:___modify_template(otherStruct)
    local template = self.___template
    for k,v in pairs(otherStruct.___template) do
        if is_in(template, k) then
            error("This SuperStruct already has a key value called " .. k .. ". Duplicate keys are not allowed!")
        else
            template[k] = v
        end
    end
end
function SuperStruct:___demodify_template(otherStruct)
    local template = self.___template
    for k,_ in pairs(otherStruct.___template) do
        template[k] = nil
    end
end
function SuperStruct:___modify_functions(otherStruct)
    local funcs = self.___functions
    for k, v in pairs(otherStruct) do
        if type(v) == "function" and not is_in(funcs[k], v) then
            add(funcs[k], v)
        end
    end
end
function SuperStruct:___demodify_functions(otherStruct)
    for k,v in pairs(otherStruct) do
        if type(v) == "function" then
            remove(self.___functions[k], v)
        end
    end
end
function SuperStruct:attach( otherStruct )
    if self == otherStruct then
        error "No... this won't work... sorry"
    end
    if is_in(otherStruct.___attached, self) then
        error "Attempted to add SuperStruct that had `self` attached to it.\nNo circular references sorry!"
    end
    add(self.___attached, otherStruct)
    add(otherStruct.___children, self)
    -- Modifying functions
    self:___modify_functions(otherStruct)
    -- Modifying template.
    self:___modify_template(otherStruct)
    return self
end
function SuperStruct:detach( otherStruct )
    remove(self.___attached, otherStruct)
    remove(otherStruct.___children, self)
    self:___demodify_template(otherStruct)
    return self
end
return newSuperStruct
return function(t)
    local ret = {}
    for i=1,#t do
        ret[i] = t[i]
    end
    return ret
end
local req_TREE
--[[
Function that automatically runs all
lua files in the given directory, 
including sub folders.
]]
function req_TREE(PATH, shover)
    local T = love.filesystem.getDirectoryItems(PATH)
    table.stable_sort(T) -- Sorts by alphabetical I think?? hopefully she'll be right
    -- (basically we just need to be consistent across different OS; because lf.getDirectoryItems isn't)
    local shover = shover or {}
    for _,fname in ipairs(T) do
        if fname:sub(1,1) ~= "_" then
            local proper_name = fname:gsub("%.lua", ""):gsub("%.fnl", "")
            fname = PATH.."/"..fname
            local info = love.filesystem.getInfo(fname)
            if info.type == "directory" then
                req_TREE(fname, shover)
            else
                local ending = fname:sub(-4,-1)
                if (ending==".lua" or ending==".fnl") then
                    -- ignoring python and glsl files
                    shover[proper_name] = require(fname:gsub("/","."):gsub("%.lua", ""):gsub("%.fnl",""))
                end
            end
        end
    end
    return shover
end
return req_TREE
local Tools = {}
Tools.set = require "libs.tools.sets"
local rand = love.math.random
local floor = math.floor
local sqrt = math.sqrt
Tools.dist = function(x, y)
    return sqrt(x*x + y*y)
end
Tools.edist = function(e1, e2)
    return (e1.pos - e2.pos):len()
end
Tools.rand_choice = function(Tools)
    return Tools[floor(rand(1, #Tools))]
end
Tools.dot = function(x1,y1,x2,y2)
    return (x1*x2) + (y1*y2)
end
Tools.Path = function(str)
    return str:gsub('%.[^%.]+$', '')
end
local this_pth = Tools.Path(...)
Tools.req_TREE = require(this_pth .. ".req_TREE")
Tools.weighted_selection = require("libs.tools.weighted_selection")
Tools.deepcopy = function( tabl, shove )
    local new = {}
    shove = shove or {[tabl] = tabl}
    for ke, val in pairs(tabl) do
        if type(val) == "table" then
            if shove[val] then
                new[ke] = val
            else
                shove[val] = val
                new[ke] = deepcopy(val, shove)
            end
        elseif type(val) == "userdata" then
            if val.clone then
                new[ke] = val:clone() -- love2d
            else
                error "userdata cannot be deepcopied; requires a :clone() method"
            end
        else
            new[ke] = val
        end
    end
    return setmetatable(new, tabl)
end
do
    local blocked=false
    local ccall = Cyan.call
    local function setClosureTrue()
        -- I don'Tools like this. But there is no other way :/
        blocked = true
        return 0
    end
    function Tools.isBlocked(x, y)
        -- returns whether the x,y position is blocked.
        ccall("boxquery",x,y, setClosureTrue)
        local ret = blocked
        blocked = false -- We start by assuming its not blocked.
        return ret        
    end
    function Tools.isIntersect(x1, y1, x2, y2)
        -- returns whether the line segment (x1,y1) -> (x2,y2)
        -- intersects with a solid fixture in the physics world.
        ccall("rayquery", x1,y1, x2,y2, setClosureTrue)
        local ret = blocked
        blocked = false
        return ret
    end
end
local getWidth, getHeight = love.graphics.getWidth, love.graphics.getHeight
local RANGE_LEIGHWAY = 300
function Tools.isOnScreen(e, cam)
    --[[
        Is the ent close to being on screen?
        -> Also- ensure you do this oli:
            Physics bodies are turned off with this function.
            its your job to ensure that behaviour trees and 
            ents applied thru MoveBehaviourSys are turned off as
            well, so we dont get idiots getting stuck in walls
    ]]
    local w,h = getWidth(), getHeight()
    local p=e.pos
    local x,y
    x,y = cam:toCameraCoords(p.x, p.y)
    return (-RANGE_LEIGHWAY < x) and (x < w+RANGE_LEIGHWAY)
    and (-RANGE_LEIGHWAY < y) and (y < h + RANGE_LEIGHWAY)
end
function Tools.distToPlayer(e, cam)
    assert(cam, "Not given camera object! Tools.distToPlayer( ent, camera ) ")
    return Tools.dist(e.pos.x - cam.x, e.pos.y - cam.y)
end
function Tools.getCameraPos(cam)
    return cam.x, cam.y
end
function Tools.assertNoDuplicateRequires()
    local cache = {}
    for k,v in pairs(package.loaded) do
        if cache[k:lower()] then
            error("DUPLICATE LUA FILE IN PACKAGE.LOADED:  "..k)
        end
        cache[k:lower()]=k
    end
end
local inspect = require("libs.NM_inspect.inspect")
-- clear dump file
io.open("T_DUMP.txt","w"):close()
function Tools.dump(e, str)
    local f = io.open("T_DUMP.txt", "a+")
    if str then
        f:write(str)
    end
    f:write("\nlua tostring::" .. tostring(e) .. "\n")
    f:write(inspect(e))
    f:close()
end
return Tools
--[[
    returns a function that returns
    a weighted selection from a table.
    Table must be of the form ::
    {
        [foo] = weight_1,
        [bar] = weight_2,
        [kek] = weight_3
    }
    And the returned function will choose a weight from
    that table appropriately.
]]
return function(tab)
    --[[
        tab : {
            ["foo"] = 0.1;  20% chance to pick "foo"
            ["bar"] = 0.4;  80% chance to pick "bar"
        }
    ]]
    local r
    if love then
        r = love.math.random
    else
        r = math.random
    end
    local k_order = { }
    local v_order = { }
    local SUM = 0
    for value, prob in pairs(tab) do
        SUM = SUM + prob
        table.insert(k_order, SUM)
        table.insert(v_order, value)
    end
    -- Okay, now keys should be uniformly distributed about 0 -> SUM.
    -- Return function to get a random value
    assert(#k_order > 0, "Need more options for weighted_selection!")
    assert(#v_order > 0, "Need more options for weighted_selection!")
    return function()
        local R = r() -- get random val (uniformly made double: 0 -> 1 )
        for i = 1, #k_order do
            local ke = k_order[i] / SUM
            if ke >= R then
                return v_order[i]
            end
        end
        return error("somehow, the weighted selection did not get a value. fix pls")
    end
end
local NODE_CALLBACKS = {
    start = true;
    update = true;
    finish = true
}
local Node_mt = {
    __index = Node,
    __newindex = function(node, ke, v)
        if NODE_CALLBACKS[ke] then
            assert(type(v) == "function", "Node: Expected type function for field `".. tostring(ke) .."`")
        else
            assert(type(v) == "table", "Node: Expected type `table` for field `".. tostring(ke) .."`")
            rawset(node,ke,v)
            node:_init_path(ke)
        end
        rawset(node,ke,v)
    end}
local Node = {}
local Nodes_proxy = {}
local Nodes = setmetatable({},
{
    __newindex = function(t,k,v)
        if rawget(Nodes_proxy,k) then
            error("Attempt to overwrite node name :: " .. k)
        end
        Nodes_proxy[k]=v
    end,
    __index = Nodes_proxy
})
local RunningTime_mt = {
    __index = function(t,k)
        t[k] = 0
        return t[k]
    end,
    __mode = "k"
}
local RESERVED_FIELDS = {
    -- Reserved field names for Node object
    next=true,
    reset=true,
    continue=true,
    run=true,
    runtime=true,
    overtime=true,
    root=true,
    parent=true,
    on=true,
    event=true,
}
local function newNode( node )
    if node.name then
        Nodes[node.name] = node
    end
    for key, _ in pairs(node) do
        if RESERVED_FIELDS[key] then
            error("Node was given protected or reserved field :: "..key)
        end
        if not NODE_CALLBACKS[key] then
            Node._init_path(node, key)
        end
    end
    node._index = 1 -- the node index that it is currently running
    node._path = nil -- the string path that it is currently running
    node._parent = nil
    node._closed_correctly = false -- Whether or not this node's update function closed correctly.
    node._ent = nil -- The current ent that is being ran
    node._dt = nil -- The last DT value passed into node
    -- table that stores the runtimes of entities upon this node.
    node._runtimes = setmetatable({}, RunningTime_mt)
    --[[
        This nodes "children" are in keyworded tables specified by
        the user.
        A common thing to do is to name the children tables
        "left" and "right", to resemble a tree.
    ]]
    setmetatable(node, Node_mt)
    return node
end
function Node:_init_path(name)
    local path = self[name]
    assert(path)
    assert(not getmetatable(path), "Objects added to Node paths must be basic arrays. See documentation")
    for i, node in ipairs(path) do
        if type(node) == "string" then
            if not Nodes[node] then
                error("Node `".. tostring(node) .."` does not exist!")
            end
            path[i] = Nodes[node]
        end
        node._parent = self
    end
end
function Node:running( run_again )
    if run_again then
        self:root():run(self._ent, self._dt)
    end
end
function Node:to(childPath, run_again)
    assert(self[childPath], "Node:to >> path `" .. childPath .. "` does not exist in this Node.")
    local cur_path = self[self._path]
    self._index = 1
    self._closed_correctly = true
    if cur_path then
        local cur_node = cur_path[self._index]
        if cur_node then
            cur_node:finish(self._ent, self._dt)
        end
    end
    self._path = childPath
    self._closed_correctly = true
    if run_again then
        self:root():run(self._ent, self._dt)
    end
end
function Node:next(run_again)
    self._closed_correctly = true
    if self._parent then
        self._parent._index = self._parent._index + 1
        if self._parent._index > #self._parent[self._path] then
            self:finish()
            self._parent._index = 1
        end
    else
        self._index = self._index + 1
        if self._index > #self[self._path] then
            self:finish()
            self._index = 1
        end
    end
    if run_again then
        self:root():run(self._ent, self._dt)
    end
end
function Node:reset(run_again)
    --[[
        resets state of the whole tree from root.
    ]]
    if self._parent then
        self:root():_reset_whole_tree()
    else
        self:_reset_whole_tree()
    end
    if run_again then
        self:root():run(self._ent, self._dt)
    end
end
function Node:root()
    if self._parent then
        return self._parent:root()
    else
        return self
    end
end
local er_missing_arg = "Missing argument! Use node:run(ent, dt) to run the behaviour tree on object `ent`."
local er_didnt_finalize = "Node `update` function did not finalize. "
function Node:run(ent, dt)
    -- Assertions
    do 
        assert(ent and dt, er_missing_arg)
        if type(ent) ~= "table" then
            error("Node:run(ent, dt) ::: arg `ent` is supposed to be table!")
        end
        if type(dt) ~= "number" then
            error("Node:run(ent, dt) ::: arg `dt` is supposed to be number!")
        end
    end
    self._ent = ent
    self._dt = dt
    if self._runtimes[ent] == 0 then
        self:start(ent,dt)
    end
    self._closed_correctly = false
    if self._path then
        self._closed_correctly = true -- This node does not have control, so leave it be.
        self[self._path][self._index]:run(ent, dt)
    else
        self:update(ent, dt)
        if not self._closed_correctly then
            error(er_didnt_finalize)
        end
    end
    self._runtimes[ent] = self._runtimes[ent] + dt
end
function Node:_reset_whole_tree()
end
function Node:runtime(e)
    return self._runtimes[e]
end
function Node:overtime(ent, time)
    return self._runtimes[e] <= time
end
function Node:parent()
    return self._parent
end
--[[
    User defined callbacks
]]
function Node:start()
end
function Node:finish()
end
return newNode
--[[
How to push to github:
git add .
git commit -m"Message here"
git push origin master
]]
_G.love.graphics.setDefaultFilter("nearest", "nearest")
-- MONKEY BUSINESS STARTS HERE !!!
setmetatable(_G, {})
do
    -- main ECS
    _G.Cyan = require "libs.Cyan.cyan"
    --[[ heres something real dumb :   
    local Ent = Cyan.Entity
    _G.Cyan.Entity = function()
        return Ent()
        -- hahahhahaha
        :add("rot", love.math.random()*2*math.pi)
        :add("avel", 0.005)
    end]]
    _G.ccall = _G.Cyan.call -- quality of life
    _G.Tools = require"libs.tools.tools"
    -- math lib additions
    _G.math.vec3  = require "libs.math.NM_vec3"
    _G.math.dot   = require "libs.math.dot"
    _G.math.roman = require "libs.math.NM_roman" -- roman numeral converter
    _G.table.copy = require "libs.tools.copy"
    _G.table.shuffle = require "libs.NM_fisher_yates_shuffle.shuffle"
    require("libs.NM_stable_sort.sort"):export() -- exports to `_G.table`
    -- Entity construction helper functions / util
    _G.EH = require 'src.entities._EH'
    _G.CONSTANTS = require"src.misc._CONSTANTS"
end
-- NO MORE MONKEY BUSINESS PAST THIS POINT !!!
setmetatable(_G, {
    __newindex = function(_,k) error("DONT MAKE GLOBALS :: " .. tostring(k)) end,
    __index = function(_,k)
        if k==nil or k=="_ENV" then
            -- Fennel uses weird _G keys in compiling.
            -- Not gonna risk monkeypatch.
            return nil
        end
        error("UNDEFINED VAR :: " .. tostring(k))
    end,
    __metatable = "defensive"
})
-- Load fennel transpiler
local fennel = require("libs.NM_fennel.fennel")
table.insert(package.loaders or package.searchers, fennel.searcher)
-- Load macros first.
require("src.misc.unique.usrMacros")
require("src.systems._SYSTEMS")
require("src.entities")
require("src.misc._MISC")
print(("We got %d bits left in compbitbase"):format(Cyan.getFreeBits()))
Tools.assertNoDuplicateRequires()
local PATH = 'src/entities/main'
local Ents = EH.entities
local function req_TREE_push(PATH, tabl)
    for _,fname in ipairs(love.filesystem.getDirectoryItems(PATH)) do
        if fname:sub(1,1) ~= "_" then
            local proper_name = fname:gsub(".lua", "")
            fname = PATH.."/"..fname
            local info = love.filesystem.getInfo(fname)
            if info.type == "directory" then
                req_TREE_push(fname, tabl)
            else
                tabl[proper_name] = require(fname:gsub("/","."):gsub(".lua", ""))
            end
        end
    end
    return tabl
end
req_TREE_push(PATH, Ents)
-- This is actually where the entities are held
return Ents.___PROXY
local shape = love.physics.newCircleShape(10)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local ai_types = { "ORBIT", "LOCKON" }
--[[
local cols = {
    {0.9,0.1, 0.1};
    {0,0.8,0.7};
    {1,0.3,1};
    {0.5,1,0.1};
    {0.8,0.9,0.2};
    {0.9,0.1,0.9}
}]]
local cols = {{0.75,1,0.75,0.8}}
local ccall = Cyan.call
local physColFunc = function(ent, oth, speed)
    EH.PC(ent,oth,speed)
end
local r = love.math.random
local function onDamage(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(1,4))
end
local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(4,7))
    ccall("emit", "smoke", p.x, p.y, p.z, r(3,5))
    EH.TOK(e,r(1,3))
end
local frames = {Quads.blob1, Quads.blob2, Quads.blob3, Quads.blob2, Quads.blob1, Quads.blob0}
return function(x,y)
    local blob = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("hp", {hp = 100, max_hp = 100})
    :add("speed", {speed = 140, max_speed = math.random(200,250)})
    :add("strength", 40)
    :add("physics", {
        shape = shape;
        body  = "dynamic";
        friction = 0.9
    })
    :add("collisions", {
        physics = physColFunc
    })
    :add("onDamage", onDamage)
    :add("onDeath", onDeath)
    :add("bobbing", {magnitude = 0.3 , value = 0})
    :add("targetID", "enemy") -- is an enemy
    blob:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player",
                orbit_tick = 0,
                orbit_speed = 0.5
            }
    })
    blob:add("animation",
    {
        frames = frames;
        interval = 0.1;
        current = 1
    })
    EH.FR(blob)
    :add("colour", Tools.rand_choice(cols))
    return blob
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
local onDeath = function(e)
    EH.TOK(e,1)
end
local colComp={
    physics = function(e,e2,s)
        if EH.PC(e,e2,s) then
            -- blah
        end
    end
}
local colour = {0.75,1,0.75}
local f = {Quads.bloblet1, Quads.bloblet2}
local speed = {
    speed = 80;
    max_speed = 100
}
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    EH.PHYS(e,7) -- Q: 'why is the bloblet so big???'
                 -- A: small bloblets are super annoying to hit, especially since
                -- they run super fast
    e.collisions = colComp
    e.targetID="enemy"
    e.speed = speed
    e.strength = 5
    e.hp = {
        hp=50;
        max_hp=50
    }
    e.onDeath=onDeath
    e.behaviour={
        move={
            type="LOCKON"; -- changing to LOCKON, ORBIT was annoying
            id="player"
        }
    };
    e.animation = {
        frames = f;
        interval= (rand()/2)+0.5
    }
    EH.BOB(e)
    e.colour = colour
    return e
end
local shape = love.physics.newCircleShape(10)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local ai_types = { "ORBIT", "LOCKON" }
--[[
local cols = {
    {0.9,0.1, 0.1};
    {0,0.8,0.7};
    {1,0.3,1};
    {0.5,1,0.1};
    {0.8,0.9,0.2};
    {0.9,0.1,0.9}
}]]
local ccall = Cyan.call
local physColFunc = function(ent, oth, speed)
    EH.PC(ent,oth,speed)
end
local r = love.math.random
local function onDamage(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(1,4))
end
local function spawnBoxBloblets(pos)
    for i=1, r(2,4) do
        EH.Ents.block(pos.x,pos.y)
    end
end
local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(4,7))
    ccall("emit", "smoke", p.x, p.y, p.z, r(3,5))
    ccall("await", spawnBoxBloblets, 0, p)
    EH.TOK(e,r(1,3))
end
local frames = {Quads.blob1, Quads.blob2, Quads.blob3, Quads.blob2, Quads.blob1, Quads.blob0}
return function(x,y)
    local blob = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("hp", {hp = 100, max_hp = 100})
    :add("speed", {speed = 140, max_speed = math.random(200,250)})
    :add("strength", 40)
    :add("physics", {
        shape = shape;
        body  = "dynamic";
        friction = 0.9
    })
    :add("collisions", {
        physics = physColFunc
    })
    :add("onDamage", onDamage)
    :add("onDeath", onDeath)
    :add("bobbing", {magnitude = 0.3 , value = 0})
    :add("targetID", "enemy") -- is an enemy
    blob:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player",
                orbit_tick = 0,
                orbit_speed = 0.5
            }
    })
    blob:add("animation",
    {
        frames = frames;
        interval = 0.1;
        current = 1
    })
    EH.FR(blob)
    local c = (r() / 5) + 0.24
    blob:add("colour", {c,c,c,0.6})
    return blob
end
--[[
Recursively splits and reduces it's transparency until it
is only made up of small blobs
]]
local blob_shape = love.physics.newCircleShape(10)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local ai_types = { "ORBIT", "LOCKON" }
local COLOURS = {
    {0.4, 0.4,  0.4,   0.7};
    {0.35,0.5,  0.35,  0.7};
    {0.3, 0.6,  0.3,   0.6};
    {0.2, 0.7,  0.2,   0.6};
    {0.2, 1.0,  0.1,   0.6}
}
local SIGILS = {"crown"}
local MAX_GENERATIONS = #COLOURS
local ccall = Cyan.call
local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED
local physColFunc = function(ent, oth, speed)
    EH.PC(ent,oth,speed)
end
local r = love.math.random
local function onDamage(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(1,4))
end
local function spawn2(pos, split_gen)
    local a = EH.Ents.boxsplitter(pos.x + 9, pos.y - 9)
    if r()<0.3 then
        EH.Ents.block(pos.x, pos.y)
    end
    local b = EH.Ents.boxsplitter(pos.x - 9, pos.y + 9)
    local sp = split_gen + 1
    b.split_generation = sp
    a.split_generation = sp
    b.colour = COLOURS[sp]
    a.colour = COLOURS[sp]
    a:remove("sigils")
    b:remove("sigils")
end
local floor = math.floor
local function spawnSmall(pos)
    EH.Ents.block(pos.x,pos.y)
    for i=1,1+floor(2*r()) do
        local r = (r()-0.5)*10
        local e = EH.Ents.bloblet(pos.x+r,pos.y-r)
        e.colour = COLOURS[#COLOURS]
        -- reduce the speed to make these little guys less annoying
        local sp = {}
        sp.max_speed = e.speed.max_speed / 2
        sp.speed = e.speed.speed / 2
        e.speed = sp
    end
end
local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(4,7))
    ccall("emit", "smoke", p.x, p.y, p.z, r(3,5))
    EH.TOK(e,1,3)
    if e.split_generation < MAX_GENERATIONS-1 then
        ccall("await", spawn2, 0, e.pos, e.split_generation)
    end
end
local frames = {Quads.blob1, Quads.blob2, Quads.blob3, Quads.blob2, Quads.blob1, Quads.blob0}
return function(x,y)
    local bsplitter = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("hp", {hp = 100, max_hp = 100})
    :add("speed", {speed = 100, max_speed = math.random(150,200)})
    :add("strength", 40)
    :add("split_generation", 1)
    :add("physics", {
        shape = blob_shape;
        body  = "dynamic";
        friction = 0.9
    })
    :add("collisions", {
        physics = physColFunc
    })
    :add("onDamage", onDamage)
    :add("onDeath", onDeath)
    :add("bobbing", {magnitude = 0.3 , value = 0})
    :add("targetID", "enemy") -- is an enemy
    bsplitter:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player",
                orbit_tick = 0,
                orbit_speed = 0.5
            }
    })
    :add("sigils",SIGILS)
    bsplitter:add("animation",
    {
        frames = frames;
        interval = 0.1;
        current = 1
    })
    EH.FR(bsplitter)
    :add("colour", COLOURS[1])
    return bsplitter
end
--[[
INFIIIIIIINITYYYYY
(This is actually really funny until it hits 4 fps)
]]
local blob_shape = love.physics.newCircleShape(10)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local ai_types = { "ORBIT", "LOCKON" }
--[[
local cols = {
    {0.9,0.1, 0.1};
    {0,0.8,0.7};
    {1,0.3,1};
    {0.5,1,0.1};
    {0.8,0.9,0.2};
    {0.9,0.1,0.9}
}]]
local cols = {{1,0.2,0.2,0.6}}
local ccall = Cyan.call
local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED
local physColFunc = function(ent, oth, speed)
    EH.PC(ent,oth,speed)
end
local r = love.math.random
local function onDamage(INF_BLOB)
    local p = INF_BLOB.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(1,4))
end
local function spawn2(pos)
    EH.Ents.INFINITE_BLOB(pos.x + 5, pos.y - 5)
    EH.Ents.INFINITE_BLOB(pos.x - 5, pos.y + 5)
end
local function onDeath(INF_BLOB)
    local p = INF_BLOB.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(4,7))
    ccall("emit", "smoke", p.x, p.y, p.z, r(3,5))
    EH.TOK(INF_BLOB,1,3)
    ccall("await", spawn2, 0, INF_BLOB.pos)
end
local frames = {Quads.blob1, Quads.blob2, Quads.blob3, Quads.blob2, Quads.blob1, Quads.blob0}
return function(x,y)
    local INFINITE_BLOB = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("text", "GOD")
    :add("vel", math.vec3(0,0,0))
    :add("hp", {hp = 100, max_hp = 100})
    :add("speed", {speed = 140, max_speed = math.random(200,250)})
    :add("strength", 40)
    :add("physics", {
        shape = blob_shape;
        body  = "dynamic";
        friction = 0.9
    })
    :add("collisions", {
        physics = physColFunc
    })
    :add("onDamage", onDamage)
    :add("onDeath", onDeath)
    :add("bobbing", {magnitude = 0.3 , value = 0})
    :add("targetID", "enemy") -- is an enemy
    INFINITE_BLOB:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player",
                orbit_tick = 0,
                orbit_speed = 0.5
            }
    })
    INFINITE_BLOB:add("animation",
    {
        frames = frames;
        interval = 0.1;
        current = 1
    })
    EH.FR(INFINITE_BLOB)
    :add("colour", Tools.rand_choice(cols))
    return INFINITE_BLOB
end
--[[
Magic bolt
(Same as bullet, but different
colour, and ignores player armour)
]]
local shape = love.physics.newCircleShape(1)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local fpsys = love.graphics.newParticleSystem(atlas.image)
--fpsys:setQuads(Quads.beet, Quads.bot, Quads.bit)
fpsys:setQuads(Quads.circ4,Quads.circ4,Quads.circ3,Quads.circ3,Quads.circ2,Quads.circ1)
fpsys:setParticleLifetime(0.2, 0.3)
--fpsys:setLinearAcceleration(0,0,200,200)
fpsys:setDirection(180)
fpsys:setSpeed(0,0)
fpsys:setEmissionRate(90)
fpsys:setSpread(math.pi/2)
fpsys:setEmissionArea("uniform", 1,1)
fpsys:setColors({0.6,0.1,0.8,1}, {0.3,0,0.4,0.8})
fpsys:setSpin(-40)
fpsys:setRotation(0, 2*math.pi)
fpsys:setRelativeRotation(false)
local _,_, pW, pH = fpsys:getQuads()[1]:getViewport( )
fpsys:setOffset(pW/2, pH/2)
local ccall = Cyan.call
local r = love.math.random
local function onDeath(e)
    -- TODO sound here
    ccall("animate", "tp_up", e.pos.x, e.pos.y, e.pos.z+40, 0.01,1,{0.3,0.02,0.4})
end
local collisionsComp = {
    physics = function(self, e, speed)
        if e.targetID=="player" then
            assert(self.strength, "not given strength")
            ccall("damage",e,self.strength)
        end
        ccall("kill",self)
    end
}
local friction_comp = {
    emitter = fpsys;
    required_vel = 0;
    amount=0
}
return function(x,y)
    local e = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("hp", {hp = 100, max_hp = 100, regen=-100/4})
    :add("size",16)
    :add("strength", 35)
    :add("friction", {
        emitter = fpsys:clone();
        required_vel = 0;
        amount=0
    })
    EH.PHYS(e,5)
    :add("draw",{oy=0})
    :add("collisions", collisionsComp)
    :add("onDeath",onDeath)
    return e
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
local COLOUR = {0.75,1,0.75,0.8}
local COLOUR_PARTICLE = {0.75, 1, 0.75, 0.4}
local COLOUR_F = {80/256,38/256,99/256,0}
local MAX_MINI_BLOBS = 16
-- This number keeps track of the number of mini blobs on the screen.
-- Its shared across all instances of `bigblob`, to ensure that not too many
-- small blobs are spawned with the `wallbreak` attack.
local num_mini_blobs = 0;
local emitter,_,pW,pH
do
    emitter=love.graphics.newParticleSystem(Atlas.image,400)
    emitter:setQuads(Quads.circ4, Quads.circ3, Quads.circ3, Quads.circ2)
    emitter:setParticleLifetime(0.7, 1.2)
    --emitter:setLinearAcceleration(0,0,200,200)
    emitter:setDirection(180)
    emitter:setSpeed(0.5,1)
    emitter:setEmissionRate(200)
    emitter:setSpread(math.pi/2)
    emitter:setColors(COLOUR_PARTICLE,COLOUR_F)
    emitter:setSpin(0,0)
    emitter:setEmissionArea("uniform", 22,12)
    emitter:setRotation(0, 2*math.pi)
    emitter:setRelativeRotation(false)
    _,_, pW, pH = emitter:getQuads()[1]:getViewport( )
    emitter:setOffset(pW/2, pH/2)
end
local function colF(e,e2,s)
    if EH.PC(e,e2,s) then
        -- TODO: noise or something
    end
end
local function spawnBloblets(e)
    for i=1,rand(2,3) do
        local w=EH.Ents.bloblet(e.pos.x + 10*(rand()-0.5), e.pos.y + 10*(rand()-0.5))
        assert(w,"???")
        w.colour=e.colour
    end
end
local function splitterOnDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, rand(4,7))
    ccall("emit", "smoke", p.x, p.y, p.z, rand(3,5))
    EH.TOK(e,1,3)
    ccall("await", spawnBloblets, 0, e)
end
local spawnLittleBlobs = function(e)
    local x,y = e.pos.x,e.pos.y
    for i=1,rand(4,5) do
        local u=EH.Ents.blob(x + 20*(rand()-0.5), y + 20*(rand()-0.5))
        u.hp.hp = 700
        u.hp.max_hp = 700
        u.onDeath = splitterOnDeath
        u.colour = COLOUR
    end
end
local onDeath = function(e)
    -- TODO: roar and stuff, big shockwave, big deal yada yada.
    -- player just killed a boss!
    ccall("await", spawnLittleBlobs, 0, e)
end
local col_comp = {
    physics=colF
}
local f={1,2,3,4,3,2} -- generate frames
for i,n in ipairs(f) do
    f[i] = Quads["bigblob"..tostring(n)]
end
local speed = {
    speed=1170;
    max_speed = 1185
}
local Tree=EH.Node("_bigblob node.")
local wallbreak_task = EH.Task("_bigblob wallbreak task")
function Tree:choose(e)
    if rand()<0.5 then
        return "wallbreak"
    end
    return "chase"
end
function wallbreak_task:start(e)
    ccall("setMoveBehaviour",e,"IDLE")
    ccall("shockwave",e.pos.x,e.pos.y,130,4,17,0.3)
end
function wallbreak_task:update(e,dt)
    if self:runtime(e)>0.6 then
        return "n"
    end
    return "r"
end
local function playerDmgFunc(e, x, y)
    if Tools.dist(e.pos.x - x, e.pos.y - y) < 120 then
        ccall("damage", e, 10)
    end
end
local function miniBlobOnDeath(e)
    num_mini_blobs = num_mini_blobs - 1
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, rand(4,7))
    ccall("emit", "smoke", p.x, p.y, p.z, rand(3,5))
    EH.TOK(e,1)
end
local function boomTime(x,y,z)
    --[[
        Creates explosion,
        spawns a capped blob
    ]]
    ccall("boom", x, y, 40, 100, 0,0, "player", 1.2)
    ccall("animate", "push", x,y+25,z, 0.03, nil, COLOUR) 
    ccall("shockwave", x, y, 4, 130, 7, 0.3)
    ccall("apply", playerDmgFunc, x, y, "player")
    ccall("sound", "boom")
    if MAX_MINI_BLOBS >= num_mini_blobs then
        local blob = EH.Ents.blob(x,y)
        blob.onDeath = miniBlobOnDeath
        num_mini_blobs = num_mini_blobs + 1
    end
end
function wallbreak_task:finish(e)
    local x,y,z = e.pos.x,e.pos.y,e.pos.z
    for i=1,rand(9,13) do -- do a random number of explosions, 9->13
        ccall("await", boomTime, i/(6+ (4*rand())), x + 300*(rand()-0.5), y + 300*(rand()-0.5), z)
    end
end
Tree.chase={
    "move::LOCKON",
    "wait::5"
}
Tree.wallbreak = {
    wallbreak_task;
    "wait::2"
}
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    EH.PHYS(e,28)
    e.friction = {
        emitter=emitter:clone();
        amount=3;
        required_vel=10
    }
    e.animation = {
        frames=f;
        interval=0.08
    }
    e.bobbing = {
        value=0;
        magnitude=0.3
    }
    e.hp={
        hp=10000;
        max_hp=10000
    }
    e.speed = speed
    e.behaviour={
        move={
            move="LOCKON";
            id="player"
        };
        tree=Tree
    }
    e.onDeath=onDeath
    e.colour=COLOUR
    e.targetID = "enemy"
    e.collisions=col_comp
end
--[[
Idea: since follow ents cant really have a physics body,
make it so there are beating hearts following the rockworm around.
If the player kills all 3 beating hearts, the worm dies.
Give good visual feedback for this; i.e, draw opaque lines towards
the worm head from the worm-hearts.
Also, make sure to have an animation of them beating. Speed up the
beating animation when there is only 1 heart left
(If the hearts are all killed really easily, make a phase-two,
where the worm spawns 3 more hearts that shoot out bullets, and the worm
splits into two or something)
]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local Entity = Cyan.Entity
local DISTANCE = 22 -- The distance between worm nodes
local MIN_LEN = 30
local MAX_LEN = 32 -- min and max lengths for worm.
local JUMP_VEL = 18000 -- velocity of worm jump
local REQ_SPEED = 120 -- required to be moving at `X` speed to initiate a jump
local Z_MIN = -(MAX_LEN * (DISTANCE+5))
local GRAVITYMOD = 0.5
local COLOUR = {0.86,0.86,0.86}
local bigrocks = {}
for x=1,3 do
    local quad_name = 'bigrock' .. tostring(x)
    table.insert(bigrocks, Quads[quad_name])
end
local function onDetatch(worm)
    -- yeah just kill em
    ccall("kill",worm)
end
local WormTree = EH.Node("_worm behaviour tree")
local wormJump = EH.Task("_worm jump node")
function wormJump:start(worm)
    worm.vel.z = JUMP_VEL
    worm.pos.z = -1
end
function wormJump:update(worm,dt)
    if worm.pos.z < 0 then
        return "n"
    end
    return "r"
end
WormTree.jump = {
    wormJump,
    "wait::5"
}
WormTree.wait = {
    "wait::1"
}
function WormTree:choose(worm)
    local targ_ent = worm.behaviour.move.target_ent
    if targ_ent then
        -- then check if we are at required speed and are moving
        -- towards the player.
        local vel = worm.vel
        local to = targ_ent.pos - worm.pos
        local proj = vel:project(to)
        if (proj + to):len() < to:len() then
            -- projection vector + worm -> target vector is less than
            -- worm -> target vector. 
            return "wait" -- So the worm is moving away from player. ret wait.
        end
        if proj:len() > REQ_SPEED then
            --[[
                yup! head worm node is moving towards the player at
                the required speed. 
                signal a jump
            ]]
            return "jump"
        end
    end
    return "wait"
end
local rand = love.math.random
local floor = math.floor
local function onSurface(e)
    -- TODO: play sound in these callbacks
    local p=e.pos
    ccall("emit","rocks", p.x,p.y,p.z, floor(rand()*4))
end
local function onGround(e)
    local p=e.pos
    ccall("emit","rocks", p.x,p.y,p.z, floor(rand()*4))
end
local function wormNodeCtor(worm)
    local wn = Entity()
    local epos=worm.pos
    wn.gravitymod = 0 -- must get pulled down; 0 gravity
    wn.rot = rand()*math.pi*2
    wn.pos = math.vec3(epos.x,epos.y,epos.z)
    wn.follow = {
        following = worm;
        distance = DISTANCE;
        onDetatch = onDetatch
    }
    local r = rand()/10
    wn.colour = {COLOUR[1]+r, COLOUR[2]+r, COLOUR[3]+r}
    wn.vel = math.vec3(0,0,0)
    wn.dig = {
        digging = false;
        z_min = Z_MIN;
        onSurface = onSurface;
        onGround = onGround
    }
    wn.rot = rand()*2*math.pi
    wn.avel = (rand()-0.5)/10
    wn.image = Tools.rand_choice(bigrocks)
    return wn
end
return function(x,y)
    --[[
        note that this entity just represents
        the head of the worm.
        There are many entities that follow behind the worm
        as constructed by wormNodeCtor
    ]]
    local worm = Entity()
    EH.PV(worm,x,y)
    local len = math.floor(love.math.random(MIN_LEN, MAX_LEN))
    -- Create big chain of worm nodes.
    local last = worm
    for x=1,len do
        last = wormNodeCtor(last)
    end
    worm.dig = {
        digging = false;
        z_min = Z_MIN;
        onSurface = onSurface;
        onGround = onGround
    }
    worm.gravitymod=GRAVITYMOD
    worm.speed = {
        speed = 230 + rand()*50;
        max_speed = 270 + rand()*50
    }
    worm.behaviour = {
        --WormTree = WormTree;
        move = {
            id="player";
            type="LOCKON"
        };
        tree=WormTree
    }
    return worm
end
--[[
Boss wizard that has a gold hat, and is extremely hard to kill.
]]
return function()
    error("bosswizard not done yet")
end
local shape = love.physics.newCircleShape(1)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local fpsys = love.graphics.newParticleSystem(atlas.image)
--fpsys:setQuads(Quads.beet, Quads.bot, Quads.bit)
fpsys:setQuads(Quads.circ4,Quads.circ3,Quads.circ2,Quads.circ1)
fpsys:setParticleLifetime(0.3, 0.4)
--fpsys:setLinearAcceleration(0,0,200,200)
fpsys:setDirection(180)
fpsys:setSpeed(0,0)
fpsys:setEmissionRate(45)
fpsys:setSpread(math.pi/2)
fpsys:setEmissionArea("uniform", 3,0)
fpsys:setColors({1,0,0}, {0.5,0,0,0.8})
fpsys:setSpin(-40)
fpsys:setRotation(0, 2*math.pi)
fpsys:setRelativeRotation(false)
local _,_, pW, pH = fpsys:getQuads()[1]:getViewport( )
fpsys:setOffset(pW/2, pH/2)
local ccall = Cyan.call
local r = love.math.random
local collisionsComp = {
    physics = function(self, e, speed)
        if e.targetID=="player" then
            if e.armour == 0 then
                error("Player armour 0?? wat")
            end
            ccall("damage",e,10/(e.armour or 1))
        end
        ccall("kill",self)
    end
}
local friction_comp = {
    emitter = fpsys;
    required_vel = 0;
    amount=0
}
return function(x,y)
    local e = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("hp", {hp = 100, max_hp = 100, regen=-100/4})
    :add("size",16)
    :add("friction", {
        emitter = fpsys:clone();
        required_vel = 0;
        amount=0
    })
    EH.PHYS(e,5)
    :add("draw",{oy=0})
    :add("collisions", collisionsComp)
    return e
end
--[[
Big, BIG lad.
Make a version of this ent who is constantly
*having 3 physics objects rotating around it.
(As a defence mechanism)
]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local cexists = Cyan.exists
local BLOCK_NUM = 5
local MAX_BLOCK_ORBIT = 60
local MIN_BLOCK_ORBIT = 50
local ORBIT_SPEED = 3
local r = love.math.random
local ii = {1,2,1,3}
local up = {}
local down = {}
local right = {}
local left = {}
local ti = table.insert
local ts = tostring
for _,i in ipairs(ii) do
    ti(up, Quads['bully_up_'..ts(i)])
    ti(down, Quads['bully_down_'..ts(i)])
    ti(right, Quads['bully_right_'..ts(i)])
    ti(left, Quads['bully_left_'..ts(i)])
end
local floor = math.floor
local spawnF = function(p)
    for i=1, floor(r()*4) do
        local x,y = r()-0.5, r()-0.5
        EH.Ents.block(p.x + x*45, p.x + y*45)
    end
end
local collisions = {
    physics = function(e,ot,s)
        if EH.PC(e,ot,s) then
            -- add noise or something here
            local p = e.pos
            ccall("shockwave", e.pos.x, e.pos.y, 20, 50, 6, 0.2)
        end
    end
}
local sin = math.sin
local cos = math.cos
local function update(e,dt)
    -- percentage of full HP
    local hp_ratio = e.hp.hp / e.hp.max_hp
    -- orbit distance
    local od = MIN_BLOCK_ORBIT + (MAX_BLOCK_ORBIT - MIN_BLOCK_ORBIT) * hp_ratio 
    local ex = e.pos.x
    local ey = e.pos.y
    e._t = (e._t + dt*ORBIT_SPEED)%(2*math.pi)
    for i=e._block_num, 1 do
        if not cexists(e.orbiting_blocks[i]) then
            e.orbiting_blocks[i] = nil
            e._block_num = e._block_num - 1  
        end
    end
    for i,bl in ipairs(e.orbiting_blocks) do
        local offset = (i*2*math.pi)/e._block_num
        local tick = e._t + offset
        local xx = ex+od*sin(tick)
        local yy = ey+od*cos(tick)
        assert(xx==xx and yy==yy, "nan spotted in boxbully")
        ccall("setPos", bl, xx, yy)
    end
end
local function onDeath(e)
    for _,bl in ipairs(e.orbiting_blocks) do
        bl.pushable = true
        bl.physicsImmune = false -- wont get splatted
    end
end
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.orbiting_blocks = {}
    e._block_num = math.floor(BLOCK_NUM + r()*2)
    for i=1, e._block_num do
        local bl = EH.Ents.block(x,y)
        bl.pushable = false
        bl.physicsImmune = true -- Immune to splats
        table.insert(e.orbiting_blocks, bl)
    end
    e._t = r()*2*math.pi -- ticker
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        current=0;
        interval=0.11;
        required_vel=1
    }
    e.onDeath = onDeath
    e.hp={
        hp=2000;
        max_hp=2000
    }
    e.speed={
        speed=105;
        max_speed=115
    }
    e.strength = 20
    e.behaviour={
        move={
            id="player";
            type="CLOCKON"
        }
    }
    e.bobbing = {
        magnitude=0.3 + r()/10;
        value=0
    }
    e.sigils = {"strength"}
    e.targetID="enemy"
    e.hybrid=true
    e.onUpdate=update
    e.collisions=collisions
    local col = (r()/2) + 0.2
    e.colour = {col,col,col}
    EH.FR(e)
    EH.PHYS(e,12)
    return e
end
--[[
Big, BIG lad.
Make a version of this ent who is constantly
carrying a shield
]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local r = love.math.random
local ii = {1,2,1,3}
local up = {}
local down = {}
local right = {}
local left = {}
local ti = table.insert
local ts = tostring
local prefix = "bully_"
for _,i in ipairs(ii) do
    ti(up, Quads[prefix..'up_'..ts(i)])
    ti(down, Quads[prefix..'down_'..ts(i)])
    ti(right, Quads[prefix..'right_'..ts(i)])
    ti(left, Quads[prefix..'left_'..ts(i)])
end
local collisions = {
    physics = function(e,ot,s)
        if EH.PC(e,ot,s) then
            -- add noise or something here
            ccall("shockwave", e.pos.x, e.pos.y, 20, 50, 6, 0.2)
        end
    end
}
local COLOUR = {
    0.65,0.9,0.65
}
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        current=0;
        interval=0.11;
        required_vel=1
    }
    e.strength = 25
    e.colour = COLOUR    
    e.speed={
        speed=120;
        max_speed=130
    }
    e.behaviour={
        move={
            id="player";
            type="CLOCKON"
        }
    }
    e.hp = {
        hp=1000;
        max_hp=1000
    }
    e.bobbing = {
        magnitude=0.3 + r()/10;
        value=0
    }
    e.targetID="enemy"
    e.collisions=collisions
    EH.FR(e)
    EH.PHYS(e,11)
    return e
end
--[[
Big, BIG lad.
Make a version of this ent who is constantly
carrying a shield
]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local r = love.math.random
local ii = {1,2,1,3}
local up = {}
local down = {}
local right = {}
local left = {}
local ti = table.insert
local ts = tostring
for _,i in ipairs(ii) do
    ti(up, Quads['bully_up_'..ts(i)])
    ti(down, Quads['bully_down_'..ts(i)])
    ti(right, Quads['bully_right_'..ts(i)])
    ti(left, Quads['bully_left_'..ts(i)])
end
local collisions = {
    physics = function(e,ot,s)
        if EH.PC(e,ot,s) then
            -- add noise or something here
            ccall("shockwave", e.pos.x, e.pos.y, 20, 50, 6, 0.2)
        end
    end
}
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        current=0;
        interval=0.11;
        required_vel=1
    }
    e.strength = 25
    e.speed={
        speed=120;
        max_speed=130
    }
    e.behaviour={
        move={
            id="player";
            type="CLOCKON"
        }
    }
    e.bobbing = {
        magnitude=0.3 + r()/10;
        value=0
    }
    e.sigils = {"strength"}
    e.targetID="enemy"
    e.collisions=collisions
    EH.FR(e)
    EH.PHYS(e,15)
    return e
end
--[[
Big, BIG lad.
Make a version of this ent who is constantly
carrying a shield
]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local r = love.math.random
local ii = {1,2,1,3}
local up = {}
local down = {}
local right = {}
local left = {}
local ti = table.insert
local ts = tostring
for _,i in ipairs(ii) do
    ti(up, Quads['spotted_bully_up_'..ts(i)])
    ti(down, Quads['spotted_bully_down_'..ts(i)])
    ti(right, Quads['spotted_bully_right_'..ts(i)])
    ti(left, Quads['spotted_bully_left_'..ts(i)])
end
local collisions = {
    physics = function(e,ot,s)
        if EH.PC(e,ot,s) then
            -- add noise or something here
            local col = e.colour
            ccall("shockwave", e.pos.x, e.pos.y, 20, 50, 6, 0.2,
                {col[1]-0.1,col[2]-0.1,col[3]-0.1})
            ccall("splat", e.pos.x, e.pos.y)
        end
    end
}
local function spawnLittles(ent)
    for i=1, math.floor(2.5 + r()) do
        EH.Ents.splatenemy(ent.pos.x + (r()-.5)*10, ent.pos.y + (r()-.5)*10)
    end
end
local function onDeath(e)
    -- rand between 2 and 3
    ccall("await", spawnLittles, 0.2, e)
end
local COLOUR = {
    0.65,0.9,0.65
}
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        current=0;
        interval=0.11;
        required_vel=1
    }
    e.strength = 25
    e.colour = COLOUR    
    e.speed={
        speed=90;
        max_speed=110
    }
    e.behaviour={
        move={
            id="player";
            type="CLOCKON"
        }
    }
    e.onDeath=onDeath
    e.hp = {
        hp=600;
        max_hp=600
    }
    e.bobbing = {
        magnitude=0.3 + r()/10;
        value=0
    }
    e.colour = CONSTANTS.SPLAT_COLOUR
    e.targetID="enemy"
    e.collisions=collisions
    EH.FR(e)
    EH.PHYS(e,15)
    return e
end
--[[
Big, BIG lad.
Make a version of this ent who is constantly
carrying a shield
]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local r = love.math.random
local ii = {1,2,1,3}
local up = {}
local down = {}
local right = {}
local left = {}
local ti = table.insert
local ts = tostring
for _,i in ipairs(ii) do
    ti(up, Quads['spotted_bully_up_'..ts(i)])
    ti(down, Quads['spotted_bully_down_'..ts(i)])
    ti(right, Quads['spotted_bully_right_'..ts(i)])
    ti(left, Quads['spotted_bully_left_'..ts(i)])
end
local collisions = {
    physics = function(e,ot,s)
        if EH.PC(e,ot,s) then
            -- TODO: add noise or something here
        end
    end
}
local function spawnLittles(ent)
    for i=1, math.floor(2.5 + r()) do
        EH.Ents.spookyenemy(ent.pos.x + (r()-.5)*10, ent.pos.y + (r()-.5)*10)
    end
end
local function onDeath(e)
    -- rand between 2 and 3
    ccall("await", spawnLittles, 0.1, e)
    for _,bl in ipairs(e.orbiting_blocks) do
        bl.pushable = true
        bl.physicsImmune = false -- wont get splatted
    end
end
local COLOUR = {
    0.43,0,0.52
}
local floor = math.floor
local spawnF = function(p)
    for i=1, floor(r()*4) do
        local x,y = r()-0.5, r()-0.5
        EH.Ents.block(p.x + x*15, p.x + y*15)
    end
end
local MAX_BLOCK_ORBIT = 55
local MIN_BLOCK_ORBIT = 50
local ORBIT_SPEED = 3
local sin = math.sin
local cos = math.cos
local function update(e,dt)
    -- percentage of full HP
    local hp_ratio = e.hp.hp / e.hp.max_hp
    -- orbit distance
    local od = MIN_BLOCK_ORBIT + (MAX_BLOCK_ORBIT - MIN_BLOCK_ORBIT) * hp_ratio 
    local ex = e.pos.x
    local ey = e.pos.y
    e._t = (e._t + dt*ORBIT_SPEED)%(2*math.pi)
    for i=e._block_num, 1 do
        if not cexists(e.orbiting_blocks[i]) then
            e.orbiting_blocks[i] = nil
            e._block_num = e._block_num - 1  
        end
    end
    for i,bl in ipairs(e.orbiting_blocks) do
        local offset = (i*2*math.pi)/e._block_num
        local tick = e._t + offset
        local xx = ex+od*sin(tick)
        local yy = ey+od*cos(tick)
        assert(xx==xx and yy==yy, "nan spotted in boxbully")
        ccall("setPos", bl, xx, yy)
    end
end
local BLOCK_NUM = 3
local FADE_DIST = 200
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.orbiting_blocks = {}
    e._block_num = math.floor(BLOCK_NUM + r()*1.9)
    for i=1, e._block_num do
        local bl = EH.Ents.spookyblock(x,y)
        bl.pushable = false
        bl.physicsImmune = true -- Immune to splats
        bl.fade = FADE_DIST
        table.insert(e.orbiting_blocks, bl)
    end
    e._t = r()*2*math.pi -- ticker
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        current=0;
        interval=0.11;
        required_vel=1
    }
    e.onDeath = onDeath
    e.hp={
        hp=2000;
        max_hp=2000
    }
    e.speed={
        speed=105;
        max_speed=115
    }
    e.strength = 20
    e.behaviour={
        move={
            id="player";
            type="CLOCKON"
        }
    }
    e.bobbing = {
        magnitude=0.3 + r()/10;
        value=0
    }
    e.targetID="enemy"
    e.hybrid=true
    e.onUpdate=update
    e.collisions=collisions
    e.colour = table.copy(COLOUR)
    e.fade = FADE_DIST
    EH.FR(e)
    EH.PHYS(e,12)
    return e
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local quad_arr = {
    "coin1","coin2","coin3","coin2"
}
for i,q in ipairs(quad_arr) do
    quad_arr[i] = Quads[q]
end
return function(x, y)
    local e = Cyan.Entity() 
    e:add("animation", {
        frames = quad_arr;
        interval = 0.3;
        current=0
    })
    e.targetID = "coin"
    EH.PV(e,x,y)
    EH.PHYS(e, 7)
    e.friction={
        required_vel=2
        ;amount=1.3
    }
    e.pushable=true
end
return function(x,y)
    --[[
        entity to keep the camera on the player's death position,
    until the level has reset.
    ]]
    --TODO:
    -- add an image for this
    return EH.PV(Cyan.Entity(),x,y)
    :add("_control_dummy", true) -- this entity does not count as a player
    :add("hp", {
        hp=0;max_hp=100
    })
    :add("speed",{
        speed=0;
        max_speed=0
    })
    :add("control",{
        canPush = false;
        canPull = false;
    })
end
local atlas = require("assets.atlas")
local grasses = {}
for i=1, 7 do
    local q = atlas.Quads["grass_"..tostring(i)]
    table.insert(grasses, q)
end
local rand_choice = Tools.rand_choice
return function(x, y)
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("draw",true)
    :add("image", {quad=rand_choice(grasses)})
    :add("swaying", {value=0, magnitude=0.2})
    :add("trivial", true ) -- for drawing
    :add("colour",{1,1,1})
end
local atlas = require("assets.atlas")
local grasses = {}
for i=1, 3 do
    local q = atlas.Quads["purp_grass_"..tostring(i)]
    table.insert(grasses, q)
end
local rand_choice = Tools.rand_choice
return function(x, y)
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("draw",true)
    :add("image", {quad=rand_choice(grasses)})
    :add("swaying", {value=0, magnitude=0.2})
    :add("trivial", true ) -- for drawing
    :add("colour",{1,1,1})
end
-- TODO make better art for this
local quads = {}
for i=1,4 do
    table.insert(quads, EH.Quads["splat"..tostring(i)])
end
return function(x,y)
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,-18))
    :add("image", {
        quad=Tools.rand_choice(quads)
    })
    :add("colour",CONSTANTS.SPLAT_COLOUR)
end
local atlas = require("assets.atlas")
local stones = {}
for i=1, 4 do
    local q = atlas.Quads["stone"..tostring(i)]
    table.insert(stones, q)
end
local rand_choice = Tools.rand_choice
return function(x, y)
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("draw",true)
    :add("image", {quad=rand_choice(stones)})
    :add("bobbing", {magnitude = 0.2, value=0})
    :add("trivial", true ) -- for drawing
    :add("colour",{1,1,1})
end
--[[
Same as enemy, but explodes into blocks upon death
and does not emit light
]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local player_shape = love.physics.newCircleShape(8)
local atlas = require "assets.atlas"
local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.bat, Quads.bot, Quads.bit)
psys:setParticleLifetime(0.4, 0.6)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(90)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({1,1,1}, {1,1,1,0})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)
local motion_down = { Quads.enemy_down_1, Quads.enemy_down_2, Quads.enemy_down_3, Quads.enemy_down_4 }
local motion_up = { Quads.enemy_up_1, Quads.enemy_up_2, Quads.enemy_up_3, Quads.enemy_up_4 }
local motion_left = { Quads.enemy_left_1, Quads.enemy_left_2, Quads.enemy_left_3, Quads.enemy_left_4 }
local motion_right = { Quads.enemy_right_1, Quads.enemy_right_2, Quads.enemy_right_3, Quads.enemy_right_4 }
local col={
    0.4,0.5,0.4
}
local r = love.math.random
local function makeBlocks(p)
    -- p is position vector
    local u = r(3,4)
    for i=1,u do
        EH.Ents.block(p.x + i*6 - u*3, p.y + i*6 - u*3)
    end
end
local onDeath = function(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(2,4))
    ccall("emit", "smoke", p.x, p.y, p.z, r(4,6))
    ccall("await", makeBlocks, 0, p)
    EH.TOK(e,1)
end
local ai_types = { "ORBIT", "LOCKON" }
local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED
local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","thud")
    end
end
local RAND_or_IDLE = {"RAND", "IDLE"}
local Tree = EH.Node '_enemy behaviour tree'
Tree.choose = function(node, e)
        return "angry" -- we removed tree, no point. `LOCKON` and `ORBIT` is just better.
end
local rand_move_task = EH.Task("_enemy move task")
rand_move_task.start = function(t,e)
    ccall("setMoveBehaviour", e, Tools.rand_choice(ai_types))
end
rand_move_task.update=function(t,e)
    return "n"
end
Tree.angry = {
    rand_move_task,
    "wait::10"
}
return function(x,y)
    local enemy = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("hp", {hp = 100, max_hp = 100})
    :add("speed", {speed = 145, max_speed = math.random(200,240)})
    :add("strength", 40)
    :add("physics", {
        shape = player_shape;
        body  = "dynamic"
    })
    :add("colour", col)
    :add("bobbing", {magnitude = 0.25 , value = 0})
    :add("friction", {
        amount = 6; -- The amount of friction given to this entity
        emitter = psys:clone();
        required_vel = 10;
    })
    :add("targetID", "enemy") -- is an enemy
    enemy:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player", -- targetting player.
                orbit_speed = 2;
                orbit_tick = 0
            };
            tree=Tree
    })
    :add("onDeath", onDeath)
    :add("collisions",{
        physics = physColFunc
    })
    enemy:add("motion",
    {
        up = motion_up;
        down = motion_down;
        left = motion_left;
        right = motion_right;
        current = 0;
        interval = 0.1;
        required_vel = 20;
    })
    return enemy
end
--[[
Just like regular enemies, but with high HP.
Tests :: passed
]]
local player_shape = love.physics.newCircleShape(8)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.bat, Quads.bot, Quads.bit)
psys:setParticleLifetime(0.4, 0.6)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(90)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({1,1,1}, {1,1,1,0})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)
local motion_down = { Quads.enemy_down_1, Quads.enemy_down_2, Quads.enemy_down_3, Quads.enemy_down_4 }
local motion_up = { Quads.enemy_up_1, Quads.enemy_up_2, Quads.enemy_up_3, Quads.enemy_up_4 }
local motion_left = { Quads.enemy_left_1, Quads.enemy_left_2, Quads.enemy_left_3, Quads.enemy_left_4 }
local motion_right = { Quads.enemy_right_1, Quads.enemy_right_2, Quads.enemy_right_3, Quads.enemy_right_4 }
local col={
    0.58,0.9,0.47
}
local ccall = Cyan.call
local r = love.math.random
local pi=math.pi
local BULLET_SPEED = 250
local function spawnAfterDeath(x,y,z)
    ccall("emit", "dust", x, y, z, r(13,18))
    local offset = r()*2
    for l=0,2 do
        local dy,dx
        dy = math.cos(((l*pi*2)/3)   +  offset)
        dx = math.sin(((l*pi*2)/3)   +  offset)
        ccall("shoot",x+30*dx,y+30*dy, dx*250, dy*250)
    end
end
--# shockwave ( x, y, start_size, end_size, thickness, time, colour=WHITE )
local onDeath = function(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(2,4))
    ccall("shockwave", p.x,p.y, 160, 3, 9, .1, {0.68,1,0.57})
    ccall("await", spawnAfterDeath, 0, p.x,p.y,p.z )
    EH.TOK(e,r(1,2))
end
local ai_types = { "ORBIT", "LOCKON" }
local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED
local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        local p =e1.pos
        ccall("emit","guts",p.x,p.y,p.z, r(8,12))
        ccall("sound", "thud")
    end
end
local RAND_or_IDLE = {"RAND", "IDLE"}
local Tree = EH.Node '_devil behaviour tree'
Tree.choose = function(node, e)
        local ret = "idle"
        if e.hp.hp < e.hp.max_hp then
            ret= "angry"
        end;
        if love.math.random() < 0.4 then
            ret = "angry" -- has a chance to be angry anyway
        end
        return ret
end
local rand_move_task = EH.Task("_devil move task")
rand_move_task.start = function(t,e)
    ccall("setMoveBehaviour", e, Tools.rand_choice(ai_types))
end
rand_move_task.update=function(t,e)
    return "n"
end
Tree.angry = {
    rand_move_task,
    "wait::10"
}
Tree.idle = {
    "move::IDLE",
    "wait::3"
}
Tree:on("damage", function(n,e)
    return "angry"
end)
return function(x,y)
    local enemy = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("sigils",{"strength"})
    :add("hp", {hp = 400, max_hp = 400})
    :add("speed", {speed = 145, max_speed = math.random(200,240)})
    :add("strength", 40)
    :add("physics", {
        shape = player_shape;
        body  = "dynamic"
    })
    :add("colour", col)
    :add("bobbing", {magnitude = 0.1 , value = 0})
    :add("friction", {
        amount = 6; -- The amount of friction given to this entity
        emitter = psys:clone();
        required_vel = 10;
    })
    :add("targetID", "enemy") -- is an enemy
    enemy:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player", -- targetting player.
                orbit_speed = 2;
                orbit_tick = 0
            };
            tree=Tree
    })
    :add("onDeath", onDeath)
    :add("collisions",{
        physics = physColFunc
    })
    enemy:add("motion",
    {
        up = motion_up;
        down = motion_down;
        left = motion_left;
        right = motion_right;
        current = 0;
        interval = 0.1;
        required_vel = 20;
    })
    :add("sigils",{"horns"})
    return enemy
end
local enemy_shape = love.physics.newCircleShape(8)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.bat, Quads.bot, Quads.bit)
psys:setParticleLifetime(0.4, 0.6)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(90)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({1,1,1}, {1,1,1,0})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)
local motion_down = { Quads.enemy_down_1, Quads.enemy_down_2, Quads.enemy_down_3, Quads.enemy_down_4 }
local motion_up = { Quads.enemy_up_1, Quads.enemy_up_2, Quads.enemy_up_3, Quads.enemy_up_4 }
local motion_left = { Quads.enemy_left_1, Quads.enemy_left_2, Quads.enemy_left_3, Quads.enemy_left_4 }
local motion_right = { Quads.enemy_right_1, Quads.enemy_right_2, Quads.enemy_right_3, Quads.enemy_right_4 }
local COLOUR={
    0.8,1,0.8
}
local ccall = Cyan.call
local r = love.math.random
local onDeath = function(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(2,4))
    ccall("emit", 'dust', e.pos.x,e.pos.y,e.pos.z, 9)
    EH.TOK(e,r(1,2))
end
local ai_types = { "ORBIT", "LOCKON" }
local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED
local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","thud")
    end
end
local RAND_or_IDLE = {"RAND", "IDLE"}
local Tree = EH.Node '_enemy behaviour tree'
Tree.choose = function(node, e)
        return "angry" -- we removed tree, no point. `LOCKON` and `ORBIT` is just better.
end
local rand_move_task = EH.Task("_enemy move task")
rand_move_task.start = function(t,e)
    ccall("setMoveBehaviour", e, Tools.rand_choice(ai_types))
end
rand_move_task.update=function(t,e)
    return "n"
end
Tree.angry = {
    rand_move_task,
    "wait::10"
}
Tree:on("damage", function(n,e)
    return "angry"
end)
return function(x,y)
    local enemy = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("hp", {hp = 100, max_hp = 100})
    :add("speed", {speed = 145, max_speed = math.random(200,240)})
    if r() < 0.3 then
        enemy:add("sigils",{"poison"})
        enemy.speed.max_speed = 300
        enemy.speed.speed = 210
    end
    enemy
    :add("strength", 40)
    :add("physics", {
        shape = enemy_shape;
        body  = "dynamic"
    })
    :add("colour", COLOUR)
    :add("bobbing", {magnitude = 0.25 , value = 0})
    :add("friction", {
        amount = 6; -- The amount of friction given to this entity
        emitter = psys:clone();
        required_vel = 10;
    })
    :add("targetID", "enemy") -- is an enemy
    enemy:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player", -- targetting player.
                orbit_speed = 2;
                orbit_tick = 0
            };
            tree=Tree
    })
    :add("onDeath", onDeath)
    :add("collisions",{
        physics = physColFunc
    })
    enemy:add("motion",
    {
        up = motion_up;
        down = motion_down;
        left = motion_left;
        right = motion_right;
        current = 0;
        interval = 0.1;
        required_vel = 20;
    })
    return enemy
end
local enemy_shape = love.physics.newCircleShape(8)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.bat, Quads.bot, Quads.bit)
psys:setParticleLifetime(0.4, 0.6)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(90)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({1,1,1}, {1,1,1,0})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)
local down = {}
local up = {}
local left = {}
local right = {}
local order = {1,2,1,4}
local ti = table.insert
local im = "spotted_enemy_"
for _,i in ipairs(order)do
    ti(up, Quads[im.."up_"..tostring(i)])
end
for _,i in ipairs(order)do
    ti(left, Quads[im.."left_"..tostring(i)])
end
for _,i in ipairs(order)do
    ti(right, Quads[im.."right_"..tostring(i)])
end
for i=1,4 do
    ti(down, Quads[im.."down_"..tostring(i)])
end
local ccall = Cyan.call
local r = love.math.random
local onDeath = function(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(2,4))
    ccall("emit", 'dust', p.x, p.y, p.z, 9)
    ccall("splat", p.x, p.y, 70)
    EH.TOK(e,r(1,2))
end
local ai_types = { "ORBIT", "LOCKON" }
local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED
local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","thud")
    end
end
local RAND_or_IDLE = {"RAND", "IDLE"}
local Tree = EH.Node '_enemy behaviour tree'
Tree.choose = function(node, e)
        return "angry" -- we removed tree, no point. `LOCKON` and `ORBIT` is just better.
end
local rand_move_task = EH.Task("_enemy move task")
rand_move_task.start = function(t,e)
    ccall("setMoveBehaviour", e, Tools.rand_choice(ai_types))
end
rand_move_task.update=function(t,e)
    return "n"
end
Tree.angry = {
    rand_move_task,
    "wait::10"
}
Tree:on("damage", function(n,e)
    return "angry"
end)
return function(x,y)
    local enemy = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("hp", {hp = 100, max_hp = 100})
    :add("speed", {speed = 145, max_speed = math.random(200,240)})
    enemy
    :add("strength", 40)
    :add("physics", {
        shape = enemy_shape;
        body  = "dynamic"
    })
    :add("colour", CONSTANTS.SPLAT_COLOUR)
    :add("bobbing", {magnitude = 0.25 , value = 0})
    :add("friction", {
        amount = 6; -- The amount of friction given to this entity
        emitter = psys:clone();
        required_vel = 10;
    })
    :add("targetID", "enemy") -- is an enemy
    enemy:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player", -- targetting player.
                orbit_speed = 2;
                orbit_tick = 0
            };
            tree=Tree
    })
    :add("onDeath", onDeath)
    :add("collisions",{
        physics = physColFunc
    })
    enemy:add("motion",
    {
        up = up;
        down = down;
        left = left;
        right = right;
        current = 0;
        interval = 0.1;
        required_vel = 20;
    })
    return enemy
end
local enemy_shape = love.physics.newCircleShape(8)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.bat, Quads.bot, Quads.bit)
psys:setParticleLifetime(0.4, 0.6)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(90)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({0.43,0,0.52,0.6}, {0.43,0,0.52,0})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)
local motion_down = { Quads.enemy_down_1, Quads.enemy_down_2, Quads.enemy_down_3, Quads.enemy_down_4 }
local motion_up = { Quads.enemy_up_1, Quads.enemy_up_2, Quads.enemy_up_3, Quads.enemy_up_4 }
local motion_left = { Quads.enemy_left_1, Quads.enemy_left_2, Quads.enemy_left_3, Quads.enemy_left_4 }
local motion_right = { Quads.enemy_right_1, Quads.enemy_right_2, Quads.enemy_right_3, Quads.enemy_right_4 }
local COLOUR={0.43,0,0.52,1}
local ccall = Cyan.call
local r = love.math.random
local onDeath = function(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(2,4))
    ccall("emit", 'dust', e.pos.x,e.pos.y,e.pos.z, 9)
    EH.TOK(e,r(1,2))
end
local ai_types = { "ORBIT", "LOCKON" }
local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED
local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","thud")
    end
end
local RAND_or_IDLE = {"RAND", "IDLE"}
local Tree = EH.Node '_enemy behaviour tree'
Tree.choose = function(node, e)
        return "angry" -- we removed tree, no point. `LOCKON` and `ORBIT` is just better.
end
local rand_move_task = EH.Task("_enemy move task")
rand_move_task.start = function(t,e)
    ccall("setMoveBehaviour", e, Tools.rand_choice(ai_types))
end
rand_move_task.update=function(t,e)
    return "n"
end
Tree.angry = {
    rand_move_task,
    "wait::10"
}
Tree:on("damage", function(n,e)
    return "angry"
end)
return function(x,y)
    local enemy = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("hp", {hp = 400, max_hp = 400})
    :add("speed", {speed = 145, max_speed = math.random(200,240)})
    :add("fade", 200)
    if r() < 0.3 then
        enemy:add("sigils",{"poison"})
        enemy.speed.max_speed = 300
        enemy.speed.speed = 210
    end
    enemy
    :add("strength", 40)
    :add("physics", {
        shape = enemy_shape;
        body  = "dynamic"
    })
    :add("colour", table.copy(COLOUR))
    :add("bobbing", {magnitude = 0.25 , value = 0})
    :add("friction", {
        amount = 6; -- The amount of friction given to this entity
        emitter = psys:clone();
        required_vel = 10;
    })
    :add("targetID", "enemy") -- is an enemy
    enemy:add("behaviour",{
            move = {
                type = Tools.rand_choice(ai_types),
                id="player", -- targetting player.
                orbit_speed = 2;
                orbit_tick = 0
            };
            tree=Tree
    })
    :add("onDeath", onDeath)
    :add("collisions",{
        physics = physColFunc
    })
    enemy:add("motion",
    {
        up = motion_up;
        down = motion_down;
        left = motion_left;
        right = motion_right;
        current = 0;
        interval = 0.1;
        required_vel = 20;
    })
    return enemy
end
--[[
Block entity that turns into an enemy when provoked
(current trigger is when player moves close)
]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local cexists = Cyan.exists
local cam = require("src.misc.unique.camera")
local HP = 1600
local SPEED = 140
local MAX_SPEED = 150
local COLOUR = {0.63,0.72,0.66}
-- animaiton component
local frames = {1,2,3,4,3,2}
for i,v in ipairs(frames) do
    frames[i] = Quads["trick_block"..tostring(v)]
end
-- motion component
local down = { Quads.enemy_down_1, Quads.enemy_down_2, Quads.enemy_down_3, Quads.enemy_down_4 }
local up = { Quads.enemy_up_1, Quads.enemy_up_2, Quads.enemy_up_3, Quads.enemy_up_4 }
local left = { Quads.enemy_left_1, Quads.enemy_left_2, Quads.enemy_left_3, Quads.enemy_left_4 }
local right = { Quads.enemy_right_1, Quads.enemy_right_2, Quads.enemy_right_3, Quads.enemy_right_4 }
local function physColFunc(e1,e2,speed)
    if e2.targetID=="player" then
        if e1.targetID=="enemy" then
            ccall("damage", e2, (e1.strength or 20))
        end
    end
    if speed > CONSTANTS.ENT_DMG_SPEED and (not e1._is_block) then
        if e1.vel then
            ccall("damage", e1, (speed - e1.vel:len()))
        else
            ccall("damage",e1,speed)
        end
        --[[
            TODO:
            sound FX and particles here!
        ]]
    end
    -- no collision, thx
end
local Tree = EH.Node("trickblock BehaviourTree")
function Tree:choose(e)
    if e._is_block then
        local d = Tools.distToPlayer(e,cam)
        if (d < 150) then
            e._is_scared = false
            return "turnIntoEnemy"
        end
    else
        if e._is_scared then
            if Tools.distToPlayer(e, cam) > 400 then
                return "turnIntoBlock"
            end
        else
            -- its not scared, its attacking
            if e.hp.hp < e.hp.max_hp/3 then
                -- I know we REALLY shouldnt be mutating the ent inside
                -- the BT like this, but im too lazy
                e._is_scared = true
                return "scared"
            end
        end
    end
    return 'wait'
end
local TE_task = EH.Task("_ turn into enemy task")
function TE_task:start(e)
    ccall("setMoveBehaviour", e, "LOCKON")
    e.speed.speed = SPEED
    e.speed.max_speed = MAX_SPEED
    e.motion = e._motion
    e:remove("animation")
    e._is_block = false
end
function TE_task:update(e)
    return'n'
end
local TB_task = EH.Task("_ turn into block task")
function TB_task:start(e)
    e.speed.speed = 0
    e.speed.max_speed = 0
    e:remove("motion")
    e.animation = e._animation
    e._is_block = true
end
function TB_task:update(e)
    return'n'
end
Tree.turnIntoEnemy = {
    -- turns into enemy
    TE_task
}
Tree.turnIntoBlock = {
    -- turns back into block when it is a safe distance from player,
    -- and regains HP
    TB_task
}
Tree.scared = {
    "move::SOLO",
    "wait::4"
}
Tree.wait={
    "wait::1"
}
local function onDeath(e)
end
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e._is_block = true --whether this entity is a block or not
        -- (unique to this ent type)
    -- note the underscores. This is done because each trickblock
    -- needs a memory unique anim/motion component. We can do it by privatizing
    -- a the fields, and have the proper one point to whatever one is being used
    e._motion = {
        up = up;
        down = down;
        left = left;
        right = right;
        current = 0;
        interval = 0.2;
        required_vel = 40
    }
    e._animation = {
        frames = frames;
        interval = 0.06;
        current=0
    }
    e.colour=COLOUR
    e.collisions = {
        physics = physColFunc
    }
    e.onDeath = onDeath
    e.animation = e._animation
    e.hp = {
        hp=HP;
        max_hp = HP
    }
    e.targetID="enemy"
    EH.PHYS(e, 8)
    EH.FR(e)
    e.pushable = true
    e.behaviour = {
        move = {
            id = "player";
            type = "LOCKON"
        };
        tree = Tree
    }
    e.speed = {
        speed=0;
        max_speed=0 -- starts off with 0 speed; blocks cannot move!
    }
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
local COLOUR = {0.85,0.85,0.95,0.8}
local GHOST_FRAMES = {}
for iii=1, 9 do
    table.insert(GHOST_FRAMES, Quads["ghost"..tostring(iii)])
end
local function physColFunc(e,oth,speed)
    if EH.PC(e,oth,speed) then
        -- TODO :
        -- make sound or something, idk. feedback!
    end
end
local function invisGhostOnDeath(e)
    ccall("emit", 'dust', e.pos.x,e.pos.y,e.pos.z, 10)
end
return function (x,y)
    --[[
        A `child` ghost that orbits around parent,
        and lives on until parent ghost dies.
        When parent ghost is angered, this ghost will attack player
    ]]
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    local spd = rand(110,200)
    e.speed = {
        speed = spd;
        max_speed = spd
    }
    EH.PHYS(e, 8)
    e.behaviour = {
        move = {
            type = "ORBIT";
            id = "player";
            orbit_speed = rand()*2;
            orbit_tick=0;
            orbit_radius = rand(20,40);
        }}
    e.animation = {
        frames = GHOST_FRAMES;
        interval = 0.05
    }
    e.targetID="enemy"
    e.onDeath = invisGhostOnDeath
    e.collisions = {
        physics = physColFunc
    }
    e.colour = COLOUR
    e.hp = {
        hp=100;
        max_hp=100
    }
    return e
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
local GHOST_COL = {0.9,0.9,1,0.9}
local GHOST_CHILD_COL = {0.9,0.9,1, 0.75}
local GHOST_CHILD_DMG = 10
local GHOST_FRAMES = {}
for iii=1, 9 do
    table.insert(GHOST_FRAMES, Quads["ghost"..tostring(iii)])
end
local function invisGhostColFunc(e,player)
    ccall("damage", player, 10)
end
local function invisGhostOnDeath(e)
    ccall("emit", 'dust', e.pos.x,e.pos.y,e.pos.z, 10)
end
local function invisGhost(x,y, parent)
    --[[
        A `child` ghost that orbits around parent,
        and lives on until parent ghost dies.
        When parent ghost is angered, this ghost will attack player
    ]]
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    local spd = rand(110,200)
    e.speed = {
        speed = spd;
        max_speed = spd
    }
    e.ghost_parent_e = parent
    e.behaviour = {
        move = {
            type = "VECORBIT"; -- We keep still until parent ghost
                            -- is unobstructed to player
            orbit_speed = rand()*2;
            orbit_tick=0;
            orbit_radius = rand(30,100);
            target = parent.pos  -- this is allowed, because VECORBIT is safely mutable
        }}
    e.animation = {
        frames = GHOST_FRAMES;
        interval = 0.05
    }
    e.onDeath = invisGhostOnDeath
    e.collisions = {
        area = {
            player = invisGhostColFunc
        }
    }
    e.colour = GHOST_CHILD_COL
    return e
end
--[[
    it was better without the child ghosts being on their own
]]
local Tree = EH.Node("_ghost behaviour tree")
Tree.angry = {
    "move::ORBIT";
    "wait::10"
}
Tree.normal = {
    "move::RAND";
    "wait::3"
}
function Tree:choose(ent)
    if ent.hp.hp < ent.hp.max_hp or rand()<0.2 then
        return "angry"
    end
    return "normal"
end
local onDeath = function(e)
    ccall("shockwave", e.pos.x,e.pos.y, 4,140,4, 0.3, {1,0.1,0.1})
    for _,u in ipairs(e.child_ghost_ents)do
        ccall("kill",u)
    end
    EH.TOK(e,rand(2,3))
end
local function pCF(e,e1,s)
    if EH.PC(e,e1,s) then
        ccall("sound","thud")
    end
end
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    EH.PHYS(e,10)
    local spd = rand(80,100)
    e.speed = {
        speed=spd;
        max_speed = spd
    }
    e.behaviour = {
        tree=Tree;
        move={
            orbit_radius = 50;
            orbit_tick = 0;
            orbit_speed = rand()*4;
            id='player'
        }
    }
    e.hp = {
        hp=400;
        max_hp=400
    }
    e.animation = {
        frames = GHOST_FRAMES;
        interval = 0.05
    }
    e.targetID = "enemy"
    e.sigils ={
        "crown"
    }
    e.child_ghost_ents = { }
    for u=1,rand(4,7)do
        -- constructing children
        table.insert(e.child_ghost_ents,
            invisGhost(x, y, e)
        )
    end
    assert(e.child_ghost_ents~=0,"?????????")
    e.collisions = {physics=pCF}
    e.onDeath=onDeath
    e.colour = GHOST_COL
end
local ccall = Cyan.call
local EH=_G.EH
return function ( x, y )
    local e = Cyan.Entity()
    --[[
    There will be 2 extra fields given here:
    ]]
    e:add("pos", math.vec3(x,y,0))
    e:add("light",{
        distance = 4;
        colour = {1,1,1,1}
    })
    return e
end
--[[
Same as Mallow, but drops physics objects on death
]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
-- motion animation 
local up,down,left,right
up={}
down={}
left={}
right={}
local ti = table.insert
for i=1,4 do
    ti(down, EH.Quads["mallow_down_"..tostring(i)])
    ti(up, EH.Quads["mallow_up_"..tostring(i)])
    ti(left, EH.Quads["mallow_left_"..tostring(i)])
    ti(right, EH.Quads["mallow_right_"..tostring(i)])
end
local COLOUR={0.3,0.5,0.3}
local atlas = EH.Atlas
local Quads= atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.beet, Quads.bat, Quads.bot)
psys:setParticleLifetime(0.4, 0.8)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(50)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({0.5,0.5,0.5})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)
local Tree = EH.Node("_mallow behaviour tree")
local Camera = require("src.misc.unique.camera")
function Tree.choose(tree, e)
    if (e.hp.hp < e.hp.max_hp) or (Tools.distToPlayer(e, Camera) < 250) then
        if rand() < 0.5 then
            --print("mallow tree: angry")
            return "angry"
        else
            return "spin"
        end
    else
        --print("mallow tree: idle")
        return "idle"
    end
end
local mallow_spin_task = EH.Task("_mallow spin task")
mallow_spin_task.start = function(t,e)
    ccall("setMoveBehaviour", e,"IDLE")
    ccall("setVel", e, 0,0)
    ccall("animate", 'mallowspin', 0,0,0, 0.1, 3, COLOUR, e, true)
end
mallow_spin_task.update=function(t,e)
    ccall("setVel",e,0,0)
    if e.hidden then
        -- Repeat until the entity is no longer hidden.
        return "r"
    else
        return "n"
    end
end
Tree.spin = {
    mallow_spin_task,
    "move::LOCKON",
    "wait::3"
}
Tree.angry = {
    "move::ORBIT",
    "wait::4"
}
Tree.idle = {
    "move::RAND",
    "wait::3"
}
local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","thud")
    end
end
local r = love.math.random
local function makeBlocks(p)
    -- p is position vector
    local u = r(5,6)
    for i=1,u do
        EH.Ents.block(p.x + i*6 - u*3, p.y + i*6 - u*3)
    end
end
local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(6,10))
    ccall("await", makeBlocks, 0, p)
    EH.TOK(e,r(4,6))
end
-- ctor
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.hp={
        hp=1700,
        max_hp=1700
    }
    e.bobbing={magnitude=0.25}
    e.speed = {speed = 90, max_speed = 100}
    e.pushable=false
    e.targetID = "enemy"
    EH.PHYS(e,7,"dynamic")
    e:add("friction", {
        amount = 6;
        emitter = psys:clone();
        required_vel = 10;
    })
    e.collisions = {
        physics = physColFunc
    }
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        current=0;
        interval=0.3;
        required_vel=1
    }
    e.onDeath = onDeath
    e.colour = COLOUR
    e.behaviour = {
        move={
            type="IDLE",
            id="player",
            orbit_tick = 0,
            orbit_speed = 1.2
        };
        tree=Tree
    }
    return e
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
local DEFAULT_SPEED = 360
local DEFAULT_MAX_SPEED = 400
local CHARGE_SPEED = 1000
local CHARGE_MAX_SPEED = 1100
local CHARGE_TIME = 1.5
local COLOUR={0.6,1,0.6}
local CHARGE_COLOUR = {1,1,1}
-- motion animation 
local up,down,left,right
up={}
down={}
left={}
right={}
local ti = table.insert
for i=1,4 do
    ti(down, EH.Quads["mallow_down_"..tostring(i)])
    ti(up, EH.Quads["mallow_up_"..tostring(i)])
    ti(left, EH.Quads["mallow_left_"..tostring(i)])
    ti(right, EH.Quads["mallow_right_"..tostring(i)])
end
local atlas = EH.Atlas
local Quads= atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.beet, Quads.bat, Quads.bot)
psys:setParticleLifetime(0.4, 0.8)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(50)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({0.5,0.5,0.5})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)
local Tree = EH.Node("cmallow behaviour tree")
local Camera = require("src.misc.unique.camera")
function Tree.choose(tree, e)
    if (e.hp.hp < e.hp.max_hp) or (Tools.distToPlayer(e, Camera) < 250) then
        if rand() < 0.5 then
            return "charge"
        else
            return "angry"
        end
    else
        return "idle"
    end
end
local cmallow_spin_task = EH.Task("_cmallow spin task")
cmallow_spin_task.start = function(t,e)
    ccall("setMoveBehaviour", e, "IDLE")
    ccall("setVel", e, 0,0)
    ccall("animate", 'mallowspin', 0,0,0, 0.04, 2, COLOUR, e, true)
end
cmallow_spin_task.update=function(t,e)
    ccall("setVel",e,0,0)
    if e.hidden then
        -- Repeat until the entity is no longer hidden.
        return "r"
    else
        return "n"
    end
end
local cmallow_charge_task = EH.Task("_cmallow charge task")
function cmallow_charge_task:start(e)
    --[[
        emits an explosion and starts charging!
    ]]
    local p = e.pos
    local x,y,z = p.x, p.y, p.z
    ccall("boom", x, y, 40, 100, 0,0, "player", 1.2)
    ccall("animate", "push", x,y+25,z, 0.03, nil, CHARGE_COLOUR) 
    ccall("shockwave", x, y, 4, 130, 7, 0.3)
    e.speed.max_speed = CHARGE_MAX_SPEED
    e.speed.speed = CHARGE_SPEED
    ccall("setMoveBehaviour", e, "LOCKON", "player")
end
function cmallow_charge_task:update(e,dt)
    if self:runtime(e)>CHARGE_TIME then
        return "n"
    end
    return "r"
end
function cmallow_charge_task:finish(e)
    ccall("shockwave", e.pos.x, e.pos.y, 180, 40, 6, 0.5, CHARGE_COLOUR)
    e.speed.max_speed = DEFAULT_MAX_SPEED
    e.speed.speed = DEFAULT_SPEED
end
Tree.charge = {
    cmallow_spin_task,
    cmallow_charge_task,
    cmallow_spin_task
}
Tree.angry = {
    "move::ORBIT",
    "wait::4"
}
Tree.idle = {
    "move::RAND",
    "wait::3"
}
local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","thud")
    end
end
local r = love.math.random
local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(6,10))
    EH.TOK(e,r(2,3))
end
-- ctor
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.hp={
        hp=1700,
        max_hp=1700
    }
    e.bobbing={magnitude=0.25}
    e.speed = {
            speed = DEFAULT_SPEED,
            max_speed = DEFAULT_MAX_SPEED}
    e.pushable=false
    e.targetID = "enemy"
    EH.PHYS(e,14,"dynamic")
    e:add("friction", {
        amount = 6;
        emitter = psys:clone();
        required_vel = 10;
    })
    :add("sigils", {"poison"})
    e.collisions = {
        physics = physColFunc
    }
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        current=0;
        interval=0.3;
        required_vel=1
    }
    e.onDeath = onDeath
    e.colour = COLOUR
    e.behaviour = {
        move={
            type="IDLE",
            id="player",
            orbit_tick = 0,
            orbit_speed = 1.2
        };
        tree=Tree
    }
    return e
end
--[[
Hell-ish version of `mallow` ent.
]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
local COLOUR={0.68,0.9,0.47}
local MINION_COLOUR = {0.78, 1, 0.6}
local BULLET_SPEED = 170
-- motion animation 
local up,down,left,right
up={}
down={}
left={}
right={}
local ti = table.insert
for i=1,4 do
    ti(down, EH.Quads["mallow_down_"..tostring(i)])
    ti(up, EH.Quads["mallow_up_"..tostring(i)])
    ti(left, EH.Quads["mallow_left_"..tostring(i)])
    ti(right, EH.Quads["mallow_right_"..tostring(i)])
end
local atlas = EH.Atlas
local Quads= atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.beet, Quads.bat, Quads.bot)
psys:setParticleLifetime(0.4, 0.8)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(50)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({0.5,0.5,0.5})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)
local Tree = EH.Node("demon behaviour tree")
local Camera = require("src.misc.unique.camera")
function Tree.choose(tree, e)
    if (e.hp.hp < e.hp.max_hp) or (Tools.distToPlayer(e, Camera) < 250) then
        if rand() < 0.5 then
            --print("mallow tree: angry")
            return "angry"
        else
            return "spin"
        end
    else
        --print("mallow tree: idle")
        return "idle"
    end
end
local mallow_spin_task = EH.Task("_demon spin task")
mallow_spin_task.start = function(t,e)
    ccall("setMoveBehaviour", e,"IDLE")
    ccall("setVel", e, 0,0)
    ccall("animate", 'mallowspin', 0,0,0, 0.1, 3, COLOUR, e, true)
end
mallow_spin_task.update=function(t,e)
    ccall("setVel",e,0,0)
    if e.hidden then
        -- Repeat until the entity is no longer hidden.
        return "r"
    else
        return "n"
    end
end
Tree.spin = {
    mallow_spin_task,
    "move::LOCKON",
    "wait::3"
}
Tree.angry = {
    "move::ORBIT",
    "wait::4"
}
Tree.idle = {
    "move::RAND",
    "wait::3"
}
local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","thud")
    end
end
local r = love.math.random
local function spawnAfterDeath(x,y,z)
    local e1=EH.Ents.mallow(x,y+5)
    local e2=EH.Ents.mallow(x,y-5)
    e1.colour = MINION_COLOUR
    e2.colour = MINION_COLOUR
    ccall("emit", "guts", x,y,z,r(13,18))
    ccall("animate", "push", x,y+25,z, 0.03)
    ccall("damage",e1,e1.hp.max_hp/2) -- Lets weaken em a bit so they aren't OP!
    ccall("damage",e2,e2.hp.max_hp/2)
end
local function spawnBullets(x,y)
    for vx=-1,1 do
        for vy=-1,1 do
            if vx~=0 or vy~=0 then
                ccall("shoot", x + vx*17, y + vy*17,
                    BULLET_SPEED*vx, BULLET_SPEED*vy)  
            end
        end
    end
end
local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(6,10))
    ccall("shockwave", p.x,p.y, 160, 3, 9, .4)
    ccall("await", spawnAfterDeath, .3, p.x,p.y,p.z)
    ccall("await", spawnBullets, 0.2, p.x, p.y)
    EH.TOK(e,r(4,6))
end
-- ctor
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.hp={
        hp=700,
        max_hp=700
    }
    e.bobbing={magnitude=0.25}
    e.speed = {speed = 90, max_speed = 100}
    e.pushable=false
    e.targetID = "enemy"
    EH.PHYS(e,7,"dynamic")
    e:add("friction", {
        amount = 6;
        emitter = psys:clone();
        required_vel = 10;
    })
    e.collisions = {
        physics = physColFunc
    }
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        current=0;
        interval=0.3;
        required_vel=1
    }
    e.onDeath = onDeath
    e.colour = COLOUR
    e.behaviour = {
        move={
            type="IDLE",
            id="player",
            orbit_tick = 0,
            orbit_speed = 1.2
        };
        tree=Tree
    }
    return e
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
-- motion animation 
local up,down,left,right
up={}
down={}
left={}
right={}
local ti = table.insert
for i=1,4 do
    ti(down, EH.Quads["mallow_down_"..tostring(i)])
    ti(up, EH.Quads["mallow_up_"..tostring(i)])
    ti(left, EH.Quads["mallow_left_"..tostring(i)])
    ti(right, EH.Quads["mallow_right_"..tostring(i)])
end
local COLOUR={0.7,1,0.7}
local atlas = EH.Atlas
local Quads= atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.beet, Quads.bat, Quads.bot)
psys:setParticleLifetime(0.4, 0.8)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(50)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({0.5,0.5,0.5})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)
local Tree = EH.Node("mallow behaviour tree")
local Camera = require("src.misc.unique.camera")
function Tree.choose(tree, e)
    if (e.hp.hp < e.hp.max_hp) or (Tools.distToPlayer(e, Camera) < 250) then
        if rand() < 0.5 then
            --print("mallow tree: angry")
            return "angry"
        else
            return "spin"
        end
    else
        return "spin"
    end
end
local mallow_spin_task = EH.Task("_mallow spin task")
mallow_spin_task.start = function(t,e)
    ccall("setMoveBehaviour", e,"IDLE")
    ccall("setVel", e, 0,0)
    ccall("animate", 'mallowspin', 0,0,0, 0.1, 3, e.colour, e, true)
end
mallow_spin_task.update=function(t,e)
    ccall("setVel",e,0,0)
    if e.hidden then
        -- Repeat until the entity is no longer hidden.
        return "r"
    else
        return "n"
    end
end
Tree.spin = {
    mallow_spin_task,
    "move::LOCKON",
    "wait::2",
    "wait::r"
}
Tree.angry = {
    "move::ORBIT",
    "wait::3",
    "wait::r"
}
local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","thud")
    end
end
local r = love.math.random
local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(6,10))
    ccall("emit", 'dust', e.pos.x,e.pos.y,e.pos.z, 15)
    EH.TOK(e,r(4,6))
end
-- ctor
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.hp={
        hp=700,
        max_hp=700
    }
    e.bobbing={magnitude=0.25}
    e.speed = {speed = 160, max_speed = 170}
    e.pushable=false
    e.targetID = "enemy"
    EH.PHYS(e,14)
    e:add("friction", {
        amount = 2;
        emitter = psys:clone();
        required_vel = 10;
    })
    e.collisions = {
        physics = physColFunc
    }
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        current=0;
        interval=0.3;
        required_vel=1
    }
    e.onDeath = onDeath
    e.colour = COLOUR
    e.behaviour = {
        move={
            type="IDLE",
            id="player",
            orbit_tick = 0,
            orbit_speed = 1.2
        };
        tree=Tree
    }
    return e
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
-- motion animation 
local up,down,left,right
up={}
down={}
left={}
right={}
local ti = table.insert
for i=1,4 do
    ti(down, EH.Quads["mallow_down_"..tostring(i)])
    ti(up, EH.Quads["mallow_up_"..tostring(i)])
    ti(left, EH.Quads["mallow_left_"..tostring(i)])
    ti(right, EH.Quads["mallow_right_"..tostring(i)])
end
local COLOUR=CONSTANTS.SPLAT_COLOUR
local atlas = EH.Atlas
local Quads= atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.beet, Quads.bat, Quads.bot)
psys:setParticleLifetime(0.4, 0.8)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(50)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({0.5,0.5,0.5})
psys:setSpin(-40,40)
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)
local Tree = EH.Node("splat mallow behaviour tree")
local Camera = require("src.misc.unique.camera")
function Tree.choose(tree, e)
    if (e.hp.hp < e.hp.max_hp) or (Tools.distToPlayer(e, Camera) < 250) then
        if rand() < 0.5 then
            --print("mallow tree: angry")
            return "angry"
        else
            return "spin"
        end
    else
        return "spin"
    end
end
local splat_spin_task = EH.Task("_splat mallow spin task")
splat_spin_task.start = function(t,e)
    e._previous_splatmallow_armour = e.armour
    e.armour = math.huge -- make invincible
    ccall("setMoveBehaviour", e,"IDLE")
    ccall("setVel", e, 0,0)
    ccall("animate", 'mallowspin', 0,0,0, 0.06, 1, e.colour, e, true)
end
splat_spin_task.update=function(t,e,dt)
    ccall("setVel",e,0,0)
    if e.hidden then
        -- Repeat until the entity is no longer hidden.
        return "r"
    else
        return "n"
    end
end
splat_spin_task.finish = function(t,e)
    if Cyan.exists(e) then
        local x, y = e.pos.x, e.pos.y
        ccall("moob", x, y, 70, 250)
        ccall("shockwave",  x, y, 160, 30, 10, 0.4, table.copy(CONSTANTS.SPLAT_COLOUR))
        ccall("splat",  x, y, 70)
        e.armour = e._previous_splatmallow_armour
    end
end
Tree.spin = {
    splat_spin_task,
    splat_spin_task,
    splat_spin_task,
    splat_spin_task,
    splat_spin_task,
    "move::LOCKON",
    "wait::1",
    "wait::r"
}
Tree.angry = {
    "move::ORBIT",
    "wait::2",
    "wait::r"
}
local physColFunc = function(e1, e2, speed)
    if EH.PC(e1,e2,speed) then
        ccall("sound","thud")
    end
end
local r = love.math.random
local function onDeath(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, r(6,10))
    ccall("emit", 'splat', e.pos.x,e.pos.y,e.pos.z, 25)
    EH.TOK(e,r(4,6))
end
-- ctor
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.hp={
        hp=700,
        max_hp=700
    }
    e.bobbing={magnitude=0.25}
    e.speed = {speed = 160, max_speed = 170}
    e.pushable=false
    e.targetID = "enemy"
    EH.PHYS(e,14)
    e:add("friction", {
        amount = 2;
        emitter = psys:clone();
        required_vel = 10;
    })
    e.collisions = {
        physics = physColFunc
    }
    e.motion = {
        up=up;
        down=down;
        left=left;
        right=right;
        current=0;
        interval=0.3;
        required_vel=1
    }
    e.onDeath = onDeath
    e.colour = table.copy(COLOUR)
    e.behaviour = {
        move={
            type="IDLE",
            id="player",
            orbit_tick = 0,
            orbit_speed = 1.2
        };
        tree=Tree
    }
    return e
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local emitter=love.graphics.newParticleSystem(Atlas.image,400)
emitter:setQuads(Quads.circ4, Quads.circ3, Quads.circ3, Quads.circ2)
emitter:setParticleLifetime(0.7, 1.2)
--emitter:setLinearAcceleration(0,0,200,200)
emitter:setDirection(180)
emitter:setSpeed(0.5,1)
emitter:setEmissionRate(200)
emitter:setSpread(math.pi/2)
emitter:setEmissionArea("uniform", 6,0)
emitter:setColors({0.6,0.6,0.6}, {0.3,0.3,0.3,0.3})
emitter:setSpin(0,0)
emitter:setEmissionArea("uniform", 22,12)
emitter:setRotation(0, 2*math.pi)
emitter:setRelativeRotation(false)
local _,_, pW, pH = emitter:getQuads()[1]:getViewport( )
emitter:setOffset(pW/2, pH/2)
local f={1,2,3,2,1,4,5,4}
for i,v in ipairs(f) do
    f[i] = Quads["bigwall"..tostring(v)]
end
local _,_,w,h=Quads.bigwall1:getViewport()
local shape = love.physics.newRectangleShape(w/1.3,h/2)
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e:add("friction",{
        emitter=emitter:clone()
    })
    e:add("animation",{
        frames=f;
        interval=0.2;
        oy=w
    })
    e.bobbing={magnitude=0.25}
    e.swaying={magnitude=0.01}
    e.physics = {
        body="dynamic";
        shape=shape
    }
    local spd=love.math.random(100,200)
    e.speed={speed=spd,spd}
    e.behaviour={
        move={
            type="RAND"
        }
    }
    return e
end
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.circ3, Quads.circ2, Quads.circ1)
    psys:setParticleLifetime(0.4, 0.5)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(180)
    psys:setSpeed(5,15)
    psys:setEmissionRate(120)
    psys:setRotation(0,math.pi*2)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 10,0)
    psys:setColors({0.3,0.3,0.3,0.5}, {0.3,0.3,0.3,0.5})
    --psys:setSpin(-40,40)
    --psys:setRotation(0, 2*math.pi)
    --psys:setRelativeRotation(false)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local _,_, w,h = Quads.block:getViewport( )
local block_shape = love.physics.newRectangleShape(w/2,h/2)
local sprites = {
    Quads.slant_block, Quads.slant_block2
}
local ccall = Cyan.call
local rand = love.math.random
local cam = require("src.misc.unique.camera")
local collisions = {
    physics = function(ent,col, speed)
    end
}
local colours = {}
for i=120,0,-5 do
    local u = (300 - i)/300
    table.insert(colours, {u,u,u})
end
return function(x,y)
    if (not x) or (not y) then error("hey! stop it") end
    local abs = math.abs
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("colour", Tools.rand_choice(colours))
    :add("physics", {
        shape = block_shape;
        body  = "dynamic"
    })
    :add("pushable",true)
    :add("bobbing", {magnitude = 0.15, value = 0})
    :add("friction", {
        emitter = psys:clone();
        required_vel = 2;
        amount = 0.9
    })
    --:add("collisions",collisions)   Turned these off for now
    :add("targetID", "physics")
    :add("image", {quad = Tools.rand_choice(sprites), oy = 20})
end
--[[
Mushroom blocks explode on impact with enemy
]]
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.circ3, Quads.circ2, Quads.circ1)
    psys:setParticleLifetime(0.4, 0.5)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(180)
    psys:setSpeed(5,15)
    psys:setEmissionRate(120)
    psys:setRotation(0,math.pi*2)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 10,0)
    psys:setColors({0.8,0.1,0.1}, {0.8,0.1,0.1,0.5})
    --psys:setSpin(-40,40)
    --psys:setRotation(0, 2*math.pi)
    --psys:setRelativeRotation(false)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local _,_, w,h = Quads.block:getViewport( )
local block_shape = love.physics.newRectangleShape(w/2,h/2)
local sprites = {
    Quads.mushroom_block
}
local function dmgEnemies(ent, x, y)
    local eX, eY = ent.pos.x, ent.pos.y
    if Tools.dist(x-eX, y-eY) < 90 then
        ccall("damage", ent, 100)
    end
end
local ccall = Cyan.call
local rand = love.math.random
local cam = require("src.misc.unique.camera")
local collisions = {
    physics = function(self, col, speed)
        if speed > CONSTANTS.ENT_DMG_SPEED and col.targetID=="enemy" then
            local x, y, z = self.pos.x, self.pos.y, self.pos.z
            ccall("boom", x, y, 100, 100)
            ccall("animate", "push", x,y+25,z, 0.06, nil, {0.8,0.1,0.1}) 
            ccall("shockwave", x, y, 14, 200, 10, 0.4)
            ccall("sound", "boom")
            ccall("apply", dmgEnemies, x, y, "enemy")
            ccall("kill", self)
        end
    end
}
local colours = {}
for i=120,0,-5 do
    local u = (300 - i)/300
    table.insert(colours, {u,u,u})
end
local function onDeath(e)
    ccall("emit", "mushroom", e.pos.x, e.pos.y, e.pos.z, 3)
end
return function(x,y)
    if (not x) or (not y) then error("hey! stop it") end
    local abs = math.abs
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("physics", {
        shape = block_shape;
        body  = "dynamic"
    })
    :add("onDeath",onDeath)
    :add("pushable",true)
    :add("bobbing", {magnitude = 0.15, value = 0})
    :add("friction", {
        emitter = psys:clone();
        required_vel = 2;
        amount = 0.9
    })
    :add("collisions",collisions)
    :add("targetID", "physics")
    :add("image", {quad = Tools.rand_choice(sprites), oy = 20})
end
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.circ3, Quads.circ3, Quads.circ2)
    psys:setParticleLifetime(0.5, 0.6)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(180)
    psys:setSpeed(5,15)
    psys:setEmissionRate(120)
    psys:setRotation(0,math.pi*2)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 10,0)
    psys:setColors({0.43,0,0.52,0.6}, {0.43,0,0.52,0})
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local _,_, w,h = Quads.block:getViewport( )
local block_shape = love.physics.newRectangleShape(w/2,h/2)
local sprites = {
    Quads.slant_block, Quads.slant_block2
}
local ccall = Cyan.call
local rand = love.math.random
local collisions = {
    physics = function(ent,col, speed)
    end
}
local COLOUR = {0.43,0,0.52}
return function(x,y)
    if (not x) or (not y) then error("hey! stop it") end
    local abs = math.abs
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("colour", table.copy(COLOUR))
    :add("physics", {
        shape = block_shape;
        body  = "dynamic"
    })
    :add("pushable",true)
    :add("fade",200)
    :add("bobbing", {magnitude = 0.15, value = 0})
    :add("friction", {
        emitter = psys:clone();
        required_vel = 2;
        amount = 0.9
    })
    --:add("collisions",collisions)   Turned these off for now
    :add("targetID", "physics")
    :add("image", {quad = Tools.rand_choice(sprites), oy = 20})
end
local player_shape = love.physics.newCircleShape(10)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local down,left,right,up
do 
    local ii = {1,2,1,3}
    up = {}
    down = {}
    right = {}
    left = {}
    local ti = table.insert
    local ts = tostring
    for _,i in ipairs(ii) do
        ti(up, Quads['bully_up_'..ts(i)])
        ti(down, Quads['bully_down_'..ts(i)])
        ti(right, Quads['bully_right_'..ts(i)])
        ti(left, Quads['bully_left_'..ts(i)])
    end
end
local ccall = Cyan.call
local rand = love.math.random
local function onDamage(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, rand(7,11))
end
return function(x,y)
    local e = Cyan.Entity()
    EH.PV(e, x,y)
    :add("acc", math.vec3(0,0,0))
    :add("hp", {
        hp = 0xffffffffffffffffff,
        max_hp = 0xffffffffffff,
        regen = 0xffffffffff,
        iframes = 0.5 -- we want iframes to be high to let player respond
    })
    :add("speed", {speed = 20, max_speed = 210})
    :add("strength", 100)
    :add("targetID", "player")
    :add("onDamage", onDamage)
    :add("pushable",true)
    :add("physics", {
        shape = player_shape;
        body  = "dynamic"
    })
    :add("bobbing", {magnitude = 0.32 , value = 0})
    EH.FR(e)
    :add("motion",
    {
        up = up;
        down = down;
        left = left;
        right = right;
        current = 0;
        interval = 0.3;
        required_vel = 120;
        sounds = {
            [2] = "footstep";
            [4] = "footstep";
            vol = 0.8;
            pitch=1;
            pitch_v = 0.2
        }
    })
    e:add("control",     {
        canPush = true;
        canPull = true;
        w = 'up';
        a = 'left';
        s = 'down';
        d = 'right';
        k = 'push';
        l = 'pull';
        i="zoomIn";
        j="zoomOut"
    })
    e:add('light',{
          colour = {1,1,1,1};
          distance = 30
    })
    :add("sigils", {"strength"})
    return e
end
local player_shape = love.physics.newCircleShape(10)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local prefix = "red_player_"
local down={}
local up={}
local left={}
local right={}
for i=1,4 do
    down[i] = Quads[prefix.."down_"..tostring(i)]
    up[i] = Quads[prefix.."up_"..tostring(i)]
    left[i] = Quads[prefix.."left_"..tostring(i)]
    right[i] = Quads[prefix.."right_"..tostring(i)]
end
local ccall = Cyan.call
local rand = love.math.random
local function onDamage(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, rand(7,11))
end
return function(x,y)
    local e = Cyan.Entity()
    EH.PV(e, x,y)
    e:add("acc", math.vec3(0,0,0))
    :add("hp", {
        hp = 100,
        max_hp = 100,
        regen = 1,
        iframes = 0.5 -- we want iframes to be high to let player respond
    })
    :add("speed", {speed = 20, max_speed = 210})
    :add("strength", 100)
    :add("targetID", "player")
    :add("onDamage", onDamage)
    :add("pushable",true)
    :add("physics", {
        shape = player_shape;
        body  = "dynamic"
    })
    :add("bobbing", {magnitude = 0.32 , value = 0})
    EH.FR(e)
    :add("motion",
    {
        up = up;
        down = down;
        left = left;
        right = right;
        current = 0;
        interval = 0.15;
        required_vel = 120;
        sounds = {
            [2] = "footstep";
            [4] = "footstep";
            vol = 0.8;
            pitch=1;
            pitch_v = 0.2
        }
    })
    e:add("control",     {
        canPush = true;
        canPull = true;
        w = 'move_up';
        a = 'move_left';
        s = 'move_down';
        d = 'move_right';
        right = 'push';
        left = 'pull';
        up = "push";
        down = "pull"
    })
    e:add('light',{
          colour = {1,1,1,1};
          distance = 5
    })
    :add("sigils", {"strength"})
    return e
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local RING_ROT_SPEED = 2
local RING_DISTANCE = 14
local PORTAL_DISTANCE = 70
local COLOUR = {0.8,1,0.8}
local OZ = -25
--[[
Base portal
]]
local ring_img_comp = {
    quad = Quads.portalring
}
local function portalRing(period_start)
    local e = Cyan.Entity()
    :add("pos", math.vec3(0,0,OZ))
    :add("vel",math.vec3())
    -- yeah we arent actually using velocity. We just need the spatial partition
    -- to be aware that this entity is moving
    :add("image", ring_img_comp)
    e._cur_portal_period = period_start
    return e
end
local function update(e, dt)
    local sin = math.sin
    local cos = math.cos
    local reset=false
    if e.portalRings[1]._cur_portal_period > math.pi*2 then
        -- reset so floating point err dont screw over and have
        -- overlap of periods
        reset=true
    end
    local pi2_3 = 2*math.pi/3
    for i, ring in ipairs(e.portalRings) do
        ring.colour = e.colour or ring.colour
        if reset then
            ring._cur_portal_period = (i-1) * pi2_3
        end
        ring._cur_portal_period = ring._cur_portal_period + dt * RING_ROT_SPEED
        local p = ring.pos
        local ox, oy = e.pos.x, e.pos.y - 40
        local new_x = ox + RING_DISTANCE * sin(ring._cur_portal_period)
        local new_y = oy + RING_DISTANCE * cos(ring._cur_portal_period)
        assert(new_x==new_x, "nan spotted")
        assert(new_y==new_y, "nan spotted")
        ring.pos.z = e.pos.z - 80
        ccall("setPos", ring, new_x, new_y)
    end
end
local function onDeath(portal)
    for _, chil in ipairs(portal.portalRings)do
        chil:delete()
    end
end
local portal_image = {
    quad = Quads.portal
}
local portalFunc = require("src.misc.unique.portal_function")
return function(x, y)
    local e = Cyan.Entity()
    e.colour = COLOUR
    e.portalRings = {}
    for i=1,3 do
        table.insert(e.portalRings, portalRing((i-1) * (math.pi*2)/3))
    end
    e.rot = 0
    e.avel = 0.007
    e:add("image",portal_image)
    e:add("pos", math.vec3(x,y,OZ))
    e.targetID = "interact"
    e.size = PORTAL_DISTANCE
    e.hybrid = true -- switched to hybrid OOP for this
    e.onUpdate = update
    e.onInteract = portalFunc
    -- portal destination
    -- this holds fields that give ccall("newWorld") info about how to gen itself
    -- (This is usually set )
    e.portalDestination = { -- this is just for example
        x = 5; -- x size
        y = 6; -- y size
        type = "NO PORTAL DESTINATION";
        tier = 1
    }
    e.portalDestination = nil -- give nil, so override is forced
    -- Spawn text entity tooltip:
    EH.Ents.goodtxt(x,y,50,"press > to use",{1,1,1},140)
    return e
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local r = love.math.random
local savedata = require("src.misc.unique.savedata")
local function playerColFunc(ent, player, dt)
    ccall("animate", "blit", ent.pos.x,ent.pos.y,ent.pos.z, 0.01, 1)
    ccall("sound", "beep", 0.35, 0.95+r()/10)
    savedata.tokens = savedata.tokens + 1
    ccall("kill",ent)
end
local f={1,2,3,4}
for i,v in ipairs(f) do
    f[i]=Quads["tok"..tostring(v)]
end
local f_rv = {4,3,2,1}
for ii,vv in ipairs(f_rv) do
    f_rv[ii]=Quads["tok"..tostring(vv)]
end
local ANIM_INTERVAL = 0.1
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.animation = {
        frames=f,
        interval = ANIM_INTERVAL
    }
    if r()<0.5 then
        -- 50% chance for animation to run backwards
        -- (gives nice variation)
        e.animation.frames = f_rv
    end
    e.speed={
        speed=300;
        max_speed=300
    }
    e.size = 2
    e.behaviour = {
        move={
            type="CLOCKON";
            id="player"
        }
    }
    e.collisions = {
        area = {
            player = playerColFunc
        }
    }
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local r = love.math.random
local function playerColFunc(ent, player, dt)
    ccall("animate", "blit", ent.pos.x,ent.pos.y,ent.pos.z, 0.01, 1)
    ccall("sound", "beep") -- TODO: change the sound of this
    ccall("kill",ent)
end
local f={1,2,3,4}
for i,v in ipairs(f) do
    f[i]=Quads["tok"..tostring(v)]
end
local f_rv = {4,3,2,1}
for ii,vv in ipairs(f_rv) do
    f_rv[ii]=Quads["tok"..tostring(vv)]
end
local ANIM_INTERVAL = 0.1
local GOLD = {222/256, 195/256, 40/256}
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e.animation = {
        frames=f,
        interval = ANIM_INTERVAL
    }
    if r()<0.5 then
        -- 50% chance for animation to run backwards
        -- (gives nice variation)
        e.animation.frames = f_rv
    end
    e.colour = GOLD
    e.speed={
        speed=250;
        max_speed=250
    }
    e.size = 10
    e.behaviour = {
        move={
            type="CLOCKON";
            id="player"
        }
    }
    e.collisions = {
        area = {
            player = playerColFunc
        }
    }
end
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
local COLOUR = {1,1,1}
local up={}
local down={}
local right={}
local left={}
local ti = table.insert
local function ins(t, dir)
    ti(t, Quads["rshroom_" .. dir .. "_1"])    
    ti(t, Quads["rshroom_" .. dir .. "_2"])    
    ti(t, Quads["rshroom_" .. dir .. "_1"])    
    ti(t, Quads["rshroom_" .. dir .. "_3"])    
end
ins(up,"up")
ins(down,"down")
ins(right,"right")
ins(left,"left")
local function physColF(e,u,sp)
    if (EH.PC(e,u,sp)) then
        -- particles and stuff here eetc.
    end
end
local function onDeath(e)
    ccall("emit", "small_mushroom", e.pos.x, e.pos.y, e.pos.z, 1)
    EH.TOK(e,1)
end
return function(x, y)
    --[[
    Todo:
    Shroom entity. 
    Explodes on contact with player
    ]]
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    :add("motion",
    {
        up=up;
        down=down;
        left=left;
        right=right;
        current = 0;
        interval = 0.12;
        required_vel = 50
    })
    :add("speed",{
        speed = 120;
        max_speed = 120
    })
    :add("collisions",{
        physics = physColF
    })
    EH.PHYS(e,6)
    EH.FR(e)
    :add("targetID","enemy")
    :add("hp",{
        hp=100;
        max_hp = 100
    })
    :add("onDeath",onDeath)
    :add("behaviour",{
        move={
            id = "player";
            type = "ORBIT";
            orbit_speed = rand()+0.5;
            orbit_tick = rand()*3;
            orbit_radius = 140 * (rand()+0.5)
        }
    })
    :add("colour",COLOUR)
end
--[[
Gives a short, temporary speed boost to the player.
-  The magnitude of the speed boost is given by ent.strength!  
-  The speed boost will last for `ent.bufftime` seconds 
]]
local BUFFTIME = 13 -- 13 seconds a good time?
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local f={}
for iii=1,5 do
    table.insert(f,Quads["rotbug"..tostring(iii)])
end
local COLOUR = {
    0.4,0.4,1,1
}
local COLOUR_CHANGE = 0.3 -- adds 0.3 blue colour to player
local cam = require 'src.misc.unique.camera'
local collisions = {
    area = {
        player = function(e,ce,dt)
            ccall("kill",e)
            assert(ce.targetID=="player", "??")
            -- speed increase is equal to `speedboost` ent's strength
            ccall("buff", ce, "speed", e.bufftime, e.strength)
            ccall("buff", ce, "tint", e.bufftime,  {1-COLOUR_CHANGE,1-COLOUR_CHANGE,1+COLOUR_CHANGE})
            -- TODO: play a sound here or somethin
            local p=e.pos
            ccall("shockwave", p.x, p.y, 10, 200, 8, 0.35,
                    {COLOUR[1],COLOUR[2],COLOUR[3]})
        end
    }
}
local SPD = {
    speed=300,max_speed=300
}
return function(x, y)
    local e = Cyan.Entity()
    EH.PV(e,x,y)
    e:add("animation",{
        frames=f;
        interval=0.1;
        current=0
    })
    :add("colour",COLOUR)
    :add("behaviour",{
        move={
            id="player";
            type="CLOCKON"
        }
    })
    :add("strength", 60)
    :add("bufftime", BUFFTIME)
    :add("collisions", collisions)
    :add("speed",SPD)
end
local atlas = require( "assets.atlas" )
local Quads = atlas.Quads
local mushes = {Quads.blue_mushroom_1, Quads.blue_mushroom_2}
local mush = mushes[1]
local _,_,w,h = mush:getViewport()
local shape = love.physics.newCircleShape(4)
local rand = love.math.random
--[[
Spawns mushroom on death
]]
local function onBoom(e,x,y, strength)
    if Tools.dist(e.pos.x-x, e.pos.y-y) < 60 and strength>1 then
        ccall("damage",e,100)
        local p = e.pos
        ccall("emit","smoke",p.x, p.y, p.z, 18)
    end
end
local function spawnMidgets(p)
    for i=1, rand(2,5)do
        local e = EH.Ents.ghost(p.x + (rand()-0.5)*30, p.y + (rand()-0.5)*30)
        e.colour = {0.4,0.4,0.8}
        e.fade = 200
    end
end
local function onDeath(e)
    local p = e.pos
    ccall("emit","smoke",p.x, p.y, p.z, 18)
    ccall("await", spawnMidgets, 0, p)
end
local BLU = {0.1,0.1,1,1}
return function(x,y)
    return Cyan.Entity( )
    :add("pos", math.vec3(x,y,0))
    :add("image", {quad = Tools.rand_choice(mushes), oy=90})
    :add("physics", {
        body = "static";
        shape = shape
    })
    :add("light", {
        colour = BLU;
        distance = 4
    })
    :add("onDeath", onDeath)
    :add("hp",{
        hp=160;
        max_hp = 160
    })
    :add("onBoom", onBoom)
    :add("bobbing",{
        magnitude = 0.15;
        value = 0
    })
end
local Quads = require("assets.atlas").Quads
local q = {Quads.pine3, Quads.pine6}
return function(x,y)
    Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("image", {quad= Tools.rand_choice(q), oy=230})
    :add("swaying", {magnitude=0.03} )
end
local Quads = require("assets.atlas").Quads
return function(x,y)
    local w = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("image", {quad = Quads.wall1})
    EH.BOB(w)
    return w
end
local _,_,w,h=EH.Quads.wall1:getViewport()
local shape = love.physics.newRectangleShape(w/1.3,h/2)
return function(x,y)
    return Cyan.Entity( )
    :add("pos", math.vec3(x,y,20))
    :add("physics", {
        body = "static";
        shape = shape
    })
end
local atlas = require( "assets.atlas" )
local Quads = atlas.Quads
local mushes = {Quads.red_mushroom_1, Quads.red_mushroom_2}
local mush = mushes[1]
local _,_,w,h = mush:getViewport()
local shape = love.physics.newCircleShape(4)
local rand = love.math.random
--[[
Spawns mushroom on death
]]
local function onBoom(e,x,y, strength)
    if Tools.dist(e.pos.x-x, e.pos.y-y) < 60 and strength>1 then
        ccall("damage",e,100)
        local p = e.pos
        ccall("emit","mushroom",p.x, p.y, p.z + 50, 2)
    end
end
local function spawnMidgets(p)
    for i=1, rand(2,5)do
        EH.Ents.shroom(p.x + (rand()-0.5)*50, p.y + (rand()-0.5)*40)
    end
    if rand()<0.7 then
        EH.Ents.mushroomblock(p.x,p.y)
    end
end
local function onDeath(e)
    local p = e.pos
    ccall("emit","mushroom",p.x, p.y, p.z + 50, 5)
    ccall("await", spawnMidgets, 0, p)
end
return function(x,y)
    return Cyan.Entity( )
    :add("pos", math.vec3(x,y,0))
    :add("image", {quad = Tools.rand_choice(mushes), oy=60})
    :add("physics", {
        body = "static";
        shape = shape
    })
    :add("onDeath", onDeath)
    :add("hp",{
        hp=160;
        max_hp = 160
    })
    :add("onBoom", onBoom)
    :add("bobbing",{
        magnitude = 0.15;
        value = 0
    })
end
--[[
]]
local Quads = require("assets.atlas").Quads
local shape = love.physics.newRectangleShape(16,16)
local q = {Quads.pillar2}
return function(x,y)
    local e = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("image", {quad= Tools.rand_choice(q), oy=40})
    :add("physics",{
        body = "static";
        shape = shape
    })
    :add("colour", {0.5,0.5,0.5})
    :add("bobbing",{
        magnitude = 0.03;
        value = 0
    })
    return e
end
--[[
]]
local Quads = require("assets.atlas").Quads
local shape = love.physics.newCircleShape(3)
local q = {Quads.pine3, Quads.pine6}
return function(x,y)
    return Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("image", {quad= Tools.rand_choice(q), oy=230})
    :add("swaying", {magnitude=0.03} )
    :add("physics",{
        body = "static";
        shape = shape
    })
    :add("bobbing",{
        magnitude = 0.01;
        value = 0
    })
end
local atlas = require( "assets.atlas" )
local Quads = atlas.Quads
local walls = {Quads.wall1,Quads.wall2}
local _,_,w,h = walls[1]:getViewport()
local shape = love.physics.newRectangleShape(w/1.3,h/2)
local ccall = Cyan.call
local COLOUR = {0.87, 0.87, 0.87}
local WALL_DMG_RANGE = 80
local dist = Tools.dist
local function onBoom(e, x,y, strength)
    local p=e.pos
    if strength > 0 and dist(x-p.x, y-p.y)<WALL_DMG_RANGE then
        ccall("emit", "wallbreak", e.pos.x, e.pos.y, e.pos.z, 1)
    end
end
return function(x,y)
    return Cyan.Entity( )
    :add("pos", math.vec3(x,y,20))
    :add("image", {quad = Tools.rand_choice(walls)})
    :add("physics", {
        body = "static";
        shape = shape
    })
    :add("colour", COLOUR)
    :add("hp",{
        hp=math.huge;
        max_hp=math.huge
    })
    :add("onBoom",onBoom)
    :add("bobbing",{
        magnitude = 0.1;
        value = 0
    })
end
local atlas = require( "assets.atlas" )
local Quads = atlas.Quads
local walls = {Quads.wall1,Quads.wall2}
local _,_,w,h = walls[1]:getViewport()
local shape = love.physics.newRectangleShape(w/1.3,h/2)
local ccall = Cyan.call
local WALL_HP = 200;
local WALL_DMG_RANGE = 80
local dist = Tools.dist
local function onBoom(e, x,y, strength)
    local p=e.pos
    if strength > 0 and dist(x-p.x, y-p.y)<WALL_DMG_RANGE then
        ccall("emit", "wallbreak", e.pos.x, e.pos.y, e.pos.z, 4)
        ccall("damage",e,101)
    end
end
local rand = love.math.random
local function spawnFunc(p)
    for i=1,rand(3,5) do
        EH.Ents.block(p.x + (rand()-0.5)*30, p.y + (rand()-0.5)*30)
    end 
end
local function onDeath(e)
    ccall("emit", "wallbreak", e.pos.x, e.pos.y, e.pos.z, 10)
    ccall("await", spawnFunc, 0, e.pos)
end
return function(x,y)
    return Cyan.Entity( )
    :add("pos", math.vec3(x,y,20))
    :add("image", {quad = Tools.rand_choice(walls)})
    :add("physics", {
        body = "static";
        shape = shape
    })
    :add("hp",{
        hp=WALL_HP;
        max_hp=WALL_HP
    })
    :add("onBoom",onBoom)
    :add("onDeath",onDeath)
end
--[[
Block letter entities
]]
local Ents = EH.Ents
        --     abcdefghijklmnopqrstuvwxyz
local letters = "adeghilmnoprsuvktxz"
for i = 1, #letters do
    local c = letters:sub(i,i)
    if c == " " then
        goto continue
    end
    local name = "letter_"..c
    -- ahhh, luajit dont like loop closures. oh well
    local image = {
        quad = EH.Quads[name]
    }
    assert(image.quad,"fix")
    Ents[name] = function(x,y)
        return EH.FR(EH.PHYS(EH.PV(Cyan.Entity(), x, y), 10), 1.4)
        :add("image",image)
        :add("pushable",true)
        :add("bobbing", {magnitude=0.2})
        :add("targetID", "physics")
        :add("physicsImmune",true) -- so it wont be killed by splat, or by massdeletion
    end
    ::continue::
end
-- We dont return anything here,
-- letters are placed directly into EH.entities
-- (I know, its weird.)
return function()
    error("block_letters_.lua  => you werent supposed to instantiate this....")
end
--[[
This is the better looking text format that (should) be used
very thouroughly throughout the project, simply
because it looks way way better.
]]
return function(x,y,z, text, colour, fade)
    --[[
        this spawns 2 entities at once.
        One text entity, and another text entity with half the colour
        behind it. 
    ]]
    assert(text and type(text)=="string", "goodtxt.lua: not given txt string properly")
    assert(colour and type(colour)=="table", "goodtxt.lua: not given colour table properly")
    local back_txt = Cyan.Entity()
    if not z then
        back_txt:add("pos",math.vec3(x+1,y+24,-50)) -- default z pos -50
    else
        back_txt:add("pos",math.vec3(x+1,y-1-(z/2),z))
    end
    back_txt:add("text",text)
    :add("colour", {colour[1]/2,colour[2]/2,colour[3]/2})
    local front_txt = Cyan.Entity()
    if not z then
        front_txt:add("pos",math.vec3(x,y+25,-50)) -- default z pos -50
    else
        front_txt:add("pos",math.vec3(x,y-(z/2),z))
    end
    front_txt:add("text", text)
    :add("colour",table.copy(colour))--memory unique copy is pretty essential here
            -- due to potential of `textfade` component
    if fade then
        back_txt.fade = fade
        front_txt.fade = fade
    end
    return nil -- This isnt an entity!!!
end
return function(x,y)
    return Cyan.Entity()
    :add("name", "love2d logo")
    :add("image", {
        quad = EH.Quads.love2d_logo
    })
    :add("pos", math.vec3(x,y,-50))
end
return function(x,y,text)
    assert(text,"expected text for ctor of txt ent")
    Cyan.Entity()
    :add("pos",math.vec3(x,y+25,-50)) -- default z pos -50
    :add("text", text)
end
local enemy_shape = love.physics.newCircleShape(8)
local atlas = require "assets.atlas"
local Quads = atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.bat, Quads.bot, Quads.bit)
    psys:setParticleLifetime(0.4, 0.6)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(180)
    psys:setSpeed(5,15)
    psys:setEmissionRate(90)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 6,0)
    psys:setColors({1,1,1}, {1,1,1,0})
    psys:setSpin(-40,40)
    psys:setRotation(0, 2*math.pi)
    psys:setRelativeRotation(false)
end
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)
local Q = EH.Quads
local up = {"up_1", "up_2"}
local down = {"down_1", "down_2"}
local left = {"left_1", "left_2"}
local right = {"right_1", "right_2"}
for i,tab in ipairs({up,down,left,right})do
    for ii, st in ipairs(tab)do
        tab[ii] = Q["wizard_"..st]
    end
end
local COLOUR={
    1,1,1
}
local BOLT_SPEED = 290
local Cam = require("src.misc.unique.camera")
local ccall = Cyan.call
local rand = love.math.random
local onDeath = function(e)
    local p = e.pos
    ccall("emit", "guts", p.x, p.y, p.z, rand(2,4))
    ccall("emit", 'dust', e.pos.x, e.pos.y,e.pos.z, 9)
    EH.TOK(e,rand(1,2))
end
local ai_types = { "ORBIT", "LOCKON" }
local ENT_DMG_SPEED = CONSTANTS.ENT_DMG_SPEED
local physColFunc = function(e1, e2, spd)
    if EH.PC(e1,e2,spd) then
        ccall("sound","thud")
    end
end
local Tree = EH.Node '_wizard behaviour tree'
local shoot = EH.Task("_wizard shoot")
function shoot:start(e)
    -- TODO: play wizard cast animation right here
    local vec = (math.vec3(Cam.x, Cam.y, 0) - e.pos)
    if vec:len() == 0 then
        return -- This should never happen tho
    end
    vec = vec:normalize()
    local dx = vec.x
    local dy = vec.y
    ccall("animate", "wizardcast", 0,0,0,
            0.04, 1, nil, e, true)
    ccall("shootbolt", e.pos.x+dx*15, e.pos.y + dy*15, dx*BOLT_SPEED, dy*BOLT_SPEED)
    ccall("shockwave", e.pos.x, e.pos.y, 4, 20, 3, 0.1, {0.4,0.05,0.6})
end
function shoot:update(e,dt)
    if not e.hidden then
        return "n"
    end
    return "r"
end
Tree.chase = {
    "move::ORBIT";
    "wait::2",
    "wait::r"
}
Tree.shoot = {
    "move::IDLE";
    shoot;
    shoot;
    shoot;
    shoot;
    shoot;
    shoot;
    "move::ORBIT";
    "wait::1",
    "wait::r"
}
Tree.choose = function(e)
    local r = rand()
    if r < 0.5 then
        return "shoot"
    end
    return "chase"
end
return function(x,y)
    local wiz = Cyan.Entity()
    :add("pos", math.vec3(x,y,0))
    :add("vel", math.vec3(0,0,0))
    :add("acc", math.vec3(0,0,0))
    :add("hp", {hp = 100, max_hp = 100})
    :add("speed", {speed = 145, max_speed = math.random(200,240)})
    :add("strength", 40)
    :add("physics", {
        shape = enemy_shape;
        body  = "dynamic"
    })
    :add("colour", COLOUR)
    :add("bobbing", {magnitude = 0.25 , value = 0})
    :add("friction", {
        amount = 6; -- The amount of friction given to this entity
        emitter = psys:clone();
        required_vel = 10;
    })
    :add("targetID", "enemy") -- is an enemy
    :add("behaviour",{
            move = {
                type = "ORBIT",
                id="player", -- targetting player.
                orbit_speed = 2;
                orbit_tick = 0
            };
            tree=Tree
    })
    :add("onDeath", onDeath)
    :add("collisions",{
        physics = physColFunc
    })
    wiz:add("motion",
    {
        up = up;
        down = down;
        left = left;
        right = right;
        current = 0;
        interval = 0.3;
        required_vel = 20;
    })
    return wiz
end
--[[
Idea: since follow ents cant really have a physics body,
make it so there are beating hearts following the rockworm around.
If the player kills all 3 beating hearts, the worm dies.
Give good visual feedback for this; i.e, draw opaque lines towards
the worm head from the worm-hearts.
Also, make sure to have an animation of them beating. Speed up the
beating animation when there is only 1 heart left
]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local Entity = Cyan.Entity
local DISTANCE = 14 -- The distance between worm nodes
local MIN_LEN = 30
local MAX_LEN = 35 -- min and max lengths for worm.
local JUMP_VEL = 5000 -- velocity of worm jump
local REQ_SPEED = 120 -- required to be moving at `X` speed to initiate a jump
local Z_MIN = -(MAX_LEN * (DISTANCE+5))
local GRAVITYMOD = 0.5
local HEART_N = 2 -- this worm has 2 hearts to kill
local rocks = {}
for x=1,4 do
    local quad_name = 'rock' .. tostring(x)
    table.insert(rocks, Quads[quad_name])
end
local function onDetatch(worm)
    -- yeah just kill em
    ccall("kill",worm)
end
local WormTree = EH.Node("_worm behaviour tree")
local wormJump = EH.Task("_worm jump node")
function wormJump:start(worm)
    worm.vel.z = JUMP_VEL
    worm.pos.z = -1
end
function wormJump:update(worm,dt)
    if worm.pos.z < 0 then
        return "n"
    end
    return "r"
end
WormTree.jump = {
    wormJump,
    "wait::5"
}
WormTree.wait = {
    "wait::1"
}
function WormTree:choose(worm)
    local targ_ent = worm.behaviour.move.target_ent
    if targ_ent then
        -- then check if we are at required speed and are moving
        -- towards the player.
        local vel = worm.vel
        local to = targ_ent.pos - worm.pos
        local proj = vel:project(to)
        if (proj + to):len() < to:len() then
            -- projection vector + worm -> target vector is less than
            -- worm -> target vector. 
            return "wait" -- So the worm is moving away from player. ret wait.
        end
        if proj:len() > REQ_SPEED then
            --[[
                yup! head worm node is moving towards the player at
                the required speed. 
                signal a jump
            ]]
            return "jump"
        end
    end
    return "wait"
end
local rand = love.math.random
local floor = math.floor
local function onSurface(e)
    -- TODO: play sound in these callbacks
    local p=e.pos
    ccall("emit","rocks", p.x,p.y,p.z, floor(rand()+0.3))
end
local function onGround(e)
    local p=e.pos
    ccall("emit","rocks", p.x,p.y,p.z, floor(rand()+0.3))
end
local function wormNodeCtor(worm)
    local wn = Entity()
    local epos=worm.pos
    wn.gravitymod = 0 -- must get pulled down; 0 gravity
    wn.pos = math.vec3(epos.x,epos.y,epos.z)
    wn.follow = {
        following = worm;
        distance = DISTANCE;
        onDetatch = onDetatch
    }
    wn.vel = math.vec3(0,0,0)
    wn.dig = {
        digging = false;
        z_min = Z_MIN;
        onSurface = onSurface;
        onGround = onGround
    }
    wn.image = Tools.rand_choice(rocks)
    return wn
end
return function(x,y)
    --[[
        note that this entity just represents
        the head of the worm.
        There are many entities that follow behind the worm
        as constructed by wormNodeCtor
    ]]
    local worm = Entity()
    EH.PV(worm,x,y)
    worm._nodes = { } -- private member containing all the worm nodes
    worm._hearts = { } -- member containing all the hearts
    local len = math.floor(love.math.random(MIN_LEN, MAX_LEN))
    -- Create big chain of worm nodes.
    local last = worm
    for x=1,len do
        last = wormNodeCtor(last)
        table.insert(worm._nodes, last)
    end
    -- must instantiate hearts after worm nodes
    for i=1,HEART_N do
        EH.Ents.wormheart(worm)
    end
    assert(#worm._hearts == HEART_N, "?? for some reason wormheart no ctor'd correctly")
    worm.dig = {
        digging = false;
        z_min = Z_MIN;
        onSurface = onSurface;
        onGround = onGround
    }
    worm.gravitymod=GRAVITYMOD
    worm.speed = {
        speed = 230 + rand()*50;
        max_speed = 270 + rand()*50
    }
    worm.behaviour = {
        --WormTree = WormTree;
        move = {
            id="player";
            type="LOCKON"
        };
        tree=WormTree
    }
    return worm
end
--[[
NOT TO BE INSTANTIATED BY WORLDGEN!
This ent works alongside worms.
It should ONLY be instantiated by worm entities, nothing else!
TODO :
Make it so the hearts gravitate towards the center of the worm,
or orbit around it or something
]]
local Atlas = require("assets.atlas")
local Quads = Atlas.Quads
local EH = EH
local BT = EH.BT
local ccall = Cyan.call
local rand = love.math.random
local cexists = Cyan.exists
local BIND_COLOUR = {0.6, 0.03, 0.08, 0.2}
local N_BINDINGS = 5
local WIDTH = 5 -- width of binding lines
local spd_cmp = {
    speed = 80;
    max_speed = 90
}
local function physColFunc(e1, e2, speed)
    if EH.PC(e1,e2,speed)then
        -- make the worm nodes spit out particles, make a sound etc.
    end
end
local drawLine = love.graphics.line
local setColour = love.graphics.setColor
local getColour = love.graphics.getColor
local getLineWidth = love.graphics.getLineWidth
local setLineWidth = love.graphics.setLineWidth
local function onDraw(ent)
    local r,g,b,a = getColour()
    setColour(BIND_COLOUR)
    local old_width = getLineWidth()
    setLineWidth(WIDTH)
    for _,node in ipairs(ent._bound_nodes) do
        local n_pos = node.pos
        if not node.hidden then
            drawLine(ent.pos.x, ent.pos.y - ent.pos.z/2, n_pos.x, n_pos.y - n_pos.z/2)
        end
    end
    setLineWidth(old_width)
    setColour(r,g,b,a)
end
local rand_choice = Tools.rand_choice
local function chooseNewNodes(ent,dt)
    --[[
        randomly chooses new worm nodes
    ]]
    local pnodes = ent._parent._nodes
    local index = ent._node_index
    local len = ent._num_bindings
    local worm_nodes = ent._bound_nodes
    local iterL = #pnodes / (2+2*rand())
    if len == 0 then return end
    for _=1, iterL do
        worm_nodes[index] = rand_choice(pnodes)
        index = (index % len) + 1
    end
    ent._node_index = index
end
local collisions = {
    physics = physColFunc
}
local function rem(tab, e)
    for i,v in ipairs(tab) do
        if v == e then
            table.remove(tab, i)
            return
        end
    end
end
local function onDeath(e)
    --[[
        put particles and stuff here, yada
    ]]
    for i=1,#e._bound_nodes do
        e._bound_nodes[i] = nil -- easier on GC
    end
    local parent = e._parent
    rem(parent._hearts, e)
    if #parent._hearts <= 0 then
        -- worm is out of hearts. kill it
        ccall("kill",parent)
    end
end
local quad_arr
do
    quad_arr = {3,2,1,1}
    for i,ii in ipairs(quad_arr)do
        quad_arr[i] = Quads["heart"..tostring(ii)]
    end
end
local er1 = "This entity is not supposed to be instantiated by worldGen!"
return function(parent, sanity_check)
    --[[
        Notice that this function does not take in (x,y) as initial
        params. This is because this entity will NEVER (or, should never) be
        instantiated akin to other entities. It should only be instantiated
        inside a worm entity ctor
    ]]
    if sanity_check then
        error(er1)
    end
    local e = Cyan.Entity()
    EH.PV(e, parent.pos.x + 50*(rand()-0.5), parent.pos.y + 50*(rand()-0.5))
    assert(parent._nodes, "All worms must have `ent._nodex` for the wormhearts to bind to")
    assert(parent._hearts, "All worms must have `ent._hearts` for the hearts to reside in")
    table.insert(parent._hearts, e)
    e._parent = parent -- private member
    e._bound_nodes = { } -- a list of worm nodes that the wormheart is currently observing.
    e._num_bindings = math.min(N_BINDINGS, #parent._nodes) -- cap at length of parent
    e._node_index = 0 -- the index in _bound_nodes that was last changed by
    --`chooseNewNodes()`.
    e.targetID = "enemy"
    e.hp = {
        hp = 1000;
        max_hp=1000
    }
    e.onDeath = onDeath
    e.animation = {
        frames = quad_arr;
        interval = 0.13;
        current = 0
    }
    e.collisions = collisions
    e.speed = spd_cmp
    e.behaviour = {
        move = {
            id = "enemy";
            type='ORBIT';
            orbit_tick = rand()*6.2;
            orbit_radius = 25;
            orbit_speed = 0.4
        }
    }
    e.behaviour.move.target_ent = parent
    EH.BOB(e, 0.18)
    EH.PHYS(e, 13)
    e.hybrid=true
    e.onDraw = onDraw
    e.onHeavyUpdate = chooseNewNodes
end
local atlas = require("assets.atlas")
local Quads= atlas.Quads
local psys = love.graphics.newParticleSystem(atlas.image)
psys:setQuads(Quads.beet, Quads.bat, Quads.bot, Quads.bit)
psys:setParticleLifetime(0.4, 0.8)
--psys:setLinearAcceleration(0,0,200,200)
psys:setDirection(180)
psys:setSpeed(5,15)
psys:setEmissionRate(90)
psys:setSpread(math.pi/2)
psys:setEmissionArea("uniform", 6,0)
psys:setColors({1,1,1}, {1,1,1,0})
psys:setRotation(0, 2*math.pi)
psys:setRelativeRotation(false)
local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
psys:setOffset(pW/2, pH/2)
return psys
local EH={
    --[[
Entity constructor helper functions.
Most of these have relatively small names,
in order to keep coding entities fast and easy and concise.
    ]]
}
local rand=love.math.random
local vec3=math.vec3
function EH.PV(e,x,y,z)
    -- position : velocity comp adding/
    e:add("pos",vec3(x,y,z or 0))
     :add("vel",vec3(0,0,0))
    return e
end
local PATH = Tools.Path(...)
local basePsys = require(PATH.."._EH.basePsys")
function EH.FR(e, amount)
    --[[
        Standard friction component
    ]]
    return e:add("friction", {
        amount = amount or 6; -- The amount of friction given to this entity
        emitter = basePsys:clone();
        required_vel = 10;
    })
end
function EH.BOB(e, mag)
    return e:add("bobbing",{
        magnitude = mag or 0.1;
        value=0
    })
end
local circleShapes = {
    -- cache circle shape (love.physics) objects
    -- so we don't construct duplicates with same radius.
}
function EH.PHYS(e, rad, type)
    -- default type: dynamic (but could be "kinematic" or "static")
    if not circleShapes[rad] then
        circleShapes[rad] = love.physics.newCircleShape(rad)
    end
    e:add("physics",{
        shape = circleShapes[rad];
        body = (type or "dynamic") -- (dynamic, static, kinematic)
    })
    return e
end
function EH.PC(e1,e2,speed)
    --[[
        default physics collision function.
        Entity takes damage from source, and damages player if applicable.
        (ONLY SHOULD BE USED BY ENEMIES!)
        Returns `true` if the collision was a hard collision,
        `false` otherwise.
    ]]
    if e2.targetID=="player" then
        if e1.targetID=="enemy" then
            ccall("damage", e2, (e1.strength or 20))
        end
    end
    if speed > CONSTANTS.ENT_DMG_SPEED and e2.targetID=="physics" then
        local armour = e1.armour or 1
        if armour <= 0 then
            Tools.dump(e1)
            error("armour is negative, you know this is scuffed. (ent dumped btw)")
        end
        if e1.vel then
            ccall("damage", e1, (speed - e1.vel:len())/armour)
        else
            ccall("damage",e1,speed/armour)
        end
        local p = e1.pos
        ccall("animate", "hit", p.x, p.y, p.z, 0.07,nil)
        return true -- Yes, the speed collision is greater than required
    end
    return false -- No, the collision speed was not enough to warrant hard collision
end
--[[
Common idiom here:
local function entColFunc( e1, e2, spd )
    if EH.PC( e1, e2, spd ) then
        ... Do stuff here, like make noise, spawn tokens, IDK.
    end
end
]]
Tools.req_TREE('src/misc/behaviour/tasks')
local PROXY = { }
EH.entities = setmetatable({___PROXY = PROXY}, {__newindex = function(t,k,v)
    if rawget(PROXY,k) then
        error("Entity file already had the name : "..k .. ". Duplicate names not allowed!")
    end
    rawset(PROXY,k,v)
end;
__index = PROXY
})
EH.Ents=EH.entities
function EH.TOK(e, amount)
    --[[
        spawns `amount` tokens around an entity.
    ]]
    local x,y = e.pos.x,e.pos.y
    for i=1,amount do
        EH.Ents.tok(x+(60*(rand()-0.5)), y+(60*(rand()-0.5)))
    end
end
local function spawnCoin(p)
    entities.coin(p.x,p.y)
end
function EH.COIN(ent, chance)
    if rand() < chance then
        ccall('await', spawnCoin, 0, ent.pos)
    end
end
EH.BT   = require("libs.BehaviourTree")
EH.Node = require("libs.BehaviourTree").Node
EH.Task = require("libs.BehaviourTree").Task
EH.Quads = require("assets.atlas").Quads
EH.Atlas = require("assets.atlas")
return EH
local Anim = {}
local Anim_mt = {__index = Anim}
--[[
Animation objects :::
Each animation object must have the following:
:play(x, y, z, frame_speed, ent_to_track=nil)     // ent_to_track allows anim object to follow an entity    
:draw()  draws animation
:update(dt)
:isFinished() check if finished animation
:clone() to clone itself
:release() to free it's individual memory
Fields:
.type     the type, must be same as filename!!!
.current    the current frame its at
.x, y, z     the position
.tracking     the entity its tracking (if any)
.frames   the entity frame quads
.frame_speed   frame speed in seconds
.time   the time spent running this frame
.len    the length of frame array
]]
-- Field init ==>
Anim.frames = { } --overwrite this
Anim.frame_speed = 0.1
Anim.time = 0 -- The time spent running this frame
Anim.x = 0
Anim.y = 0
Anim.z = 0
Anim.type = "BASE"
Anim.current = 1
Anim.tracking = nil
Anim.len = (# Anim.frames)
Anim.finished = false
Anim.ox = 10
Anim.oy = 10 -- offset X, offset Y
-- ^^^^^^ These fields are just kept for reference!!! Unused.
local floor=math.floor
local function getZIndex(y,z)
    return floor((y+z)/2)
end
local weak_mt = {__mode="kv"}
local setColour = love.graphics.setColor
local image = require("assets.atlas").image
local draw=love.graphics.draw
local cexists = Cyan.exists
function Anim:draw()
    if self.finished then return end
    --    love.graphics.draw(drawable,x,y,r,sx,sy,ox,oy)
    setColour(self.colour)
    if self.tracking then
        if (not cexists(self.tracking)) then
            -- The ent has been deleted mid-track! stop the count!
            self:finish()
            return
        end
        local pos = self.tracking.pos
        if pos then
            -- In case entity position component has been deleted
            draw(image, self.frames[self.current], self.x + pos.x, (self.y + pos.y) - (self.z+pos.z)/2, self.rot, 1, 1, self.ox, self.oy)
            return
        end
    end
    draw(image, self.frames[self.current],
        self.x, self.y - self.z/2, self.rot, 1, 1, self.ox, self.oy)
end
function Anim:update(dt)
    if self.finished then return end
    self.time = self.time + dt
    if self.time > self.frame_speed then
        self.time = 0
        self.current = self.current + 1
        if self.current > (#self.frames) then
            self.current = 1
            self.cycles = self.cycles - 1
            if self.cycles == 0 then
                self:finish( )
            end
        end
    end
end
function Anim:clone()
    local new = setmetatable({}, getmetatable(self))
    -- Allows for method overriding
    new.update=self.update
    new.draw=self.draw
    new.finish=self.finish
    new.isFinished=self.isFinished
    new.play=self.play
    new.time = 0
    new.current = 1
    new.frames = self.frames
    new.type = type
    new.frame_speed = self.frame_speed
    new.len = self.len
    new.finished = true
    new.ox = self.ox
    new.oy = self.oy
    new.ent_original_hidden = false -- was the entity being tracked originally hidden?
    return new
end
function Anim:new( type )
    self.frames = self.frames or error("animation obj "
                                        ..tostring(type)
                                        .." not given a `frames` field!")
    self.frame_speed = 0.1
    self.time = 0 -- The time spent running this frame
    self.x = 0
    self.y = 0
    self.z = 0
    self.type = type
    self.current = 1
    self.tracking = nil
    self.ent_original_hidden = false
    self.len = (#self.frames)
    self.finished = true
    self.colour = nil
    self.cycles = 1 -- how many times this AnimObj plays
    local _,_, W, H = self.frames[1]:getViewport( )
    self.ox = W/2
    self.oy = H/2
    return setmetatable(self, Anim_mt)
end
function Anim:removed(ent)
    -- for when the entity is destroyed halfway thru, and the
    -- anim object is still tracking it.
    -- future oli here, this is dumb, dont do this stuff again.
    -- In fact, dont do any weird stuff where helper objects hold entities 
    -- EVER again! its a really bad idea
    self.tracking = nil
end
function Anim:release()
    self.frames = nil
    self.tracking = nil
end
function Anim:finish()
    self.finished = true
    if self.tracking then
        self.tracking.hidden = self.ent_original_hidden
        self.tracking = nil
    end
    self.current = 1
    self.time = 0
    self.cycles = 1
end
function Anim:isFinished()
    return self.finished
end
local er_no_ent = "ccall('animate' ...), expected entity to hide, got none!"
function Anim:play(x, y, z, frame_speed, cycles,
                    colour, ent_to_track, should_hide_ent)
    if (not self.finished) then
        error("Attempted to play an animation that wasn't already finished. This is a problem with AnimationSys, not the callback itself.")
    end
    self.finished = false
    self.colour = colour
    self.frame_speed = frame_speed or self.frame_speed
    self.cycles = cycles or 1
    if ent_to_track then
        if type(ent_to_track) ~= "table" then
            error("Expected entity to track, got :: " .. tostring(type(ent_to_track)))
        end
        local e = ent_to_track
        self.ent_original_hidden = e.hidden
        if should_hide_ent then
            assert(e, er_no_ent)
            e.hidden = true
        end
        self.tracking = e
    end
    self.x = x
    self.y = y
    self.z = z
end
return Anim.new
local PTH = Tools.Path(...)
local AnimCtor = require(PTH..".anim_base")
--[[
Each lua file in `_types` should return a list of quads,
that each serve as frames for each animation object.
This file will construct each animation object 
from Anim:new( type, frames ).
]]
local AnimTypes = { }
Tools.req_TREE(PTH:gsub("%.", "/").."/_types", AnimTypes)
for typename, animObj in pairs(AnimTypes) do
    AnimTypes[typename] = AnimCtor(animObj, typename)
end
return AnimTypes
local Quads = EH.Quads
-- Field init ==>
local frames = { } --overwrite this
for i=1, 6 do
    table.insert(frames, Quads["blit"..tostring(i)])
end
return {frames=frames}
local Quads = EH.Quads
-- Field init ==>
local frames = { } --overwrite this
for i=1,6 do
    table.insert(frames, Quads["hit"..tostring(i)])
end
local hitAnim = {frames=frames}
function hitAnim:play(x, y, z, frame_speed, cycles,
    colour, ent_to_track, should_hide_ent)
    getmetatable(self).__index.play(self, x, y, z, frame_speed, cycles,colour, ent_to_track, should_hide_ent)
    self.rot = love.math.random() * 2 * math.pi
end
return hitAnim
local Quads = EH.Quads -- shouldnt be using EH here! oh well lol
-- Field init ==>
local frames = { } --overwrite this
for i=1, 9 do
    table.insert(frames, Quads["mallow_spin"..tostring(i)])
end
return {frames=frames}
local Atlas = require("assets.atlas")
local frames = {}
for n=1, 7 do
    table.insert(frames, Atlas.Quads["bigpush"..tostring(n)])
end
frames.oy = -40
local q = { }
local setColour = love.graphics.setColor
function q:draw()
    if self.finished then return end
    --    love.graphics.draw(drawable,x,y,r,sx,sy,ox,oy)
    if self.tracking then
        local pos = self.tracking.pos
        if pos then
            -- In case entity position component has been deleted
            Atlas:draw(self.frames[self.current], self.x + pos.x, (-30 + self.y + pos.y) - (self.z+pos.z)/2, 0, 1, 1, self.ox, self.oy)
            return
        end
    end
    setColour(self.colour)
    Atlas:draw(self.frames[self.current],
        self.x, -30 + self.y - self.z/2, 0, 1, 1, self.ox, self.oy)
end
q.frames = frames
return q
local Atlas = require("assets.atlas")
local frames = {}
for n=1, 7 do
    table.insert(frames, Atlas.Quads["shock"..tostring(n)])
end
return {
    frames = frames
}
local Quads = EH.Quads
-- Field init ==>
local frames = { } --overwrite this
for i=1, 10 do
    table.insert(frames, Quads["tp"..tostring(i)])
end
return {frames=frames}
local Quads = EH.Quads
-- Field init ==>
local frames = { } --overwrite this
for i=10,1,-1 do
    table.insert(frames, Quads["tp"..tostring(i)])
end
return {frames=frames}
local Quads = EH.Quads
-- Field init ==>
local frames = { } --overwrite this
for i=1,7 do
    table.insert(frames, Quads["wizardcast"..tostring(i)])
end
return {frames=frames}
local base = {}
local base_mt = {__index=base}
--[[
Base class for MoveBehaviours used in MoveBehaviourSys.
See MoveBehaviourSys for a better explanation.
Every method in this base class is actually a static method.
The MoveBehaviour itself is not affected.
]]
local dist = Tools.dist
base.dist = dist
-- The default distance ROOK and RAND will travel
base.DEFAULT_DIST = 400 
-- maximum velocity of moving obj
base.MAX_VEL = require("src.misc.partition").MAX_VEL
base.TargettedEntities = require("src.misc.behaviour.movebehaviours.targetted_entities")
local TargettedEntities = require("src.misc.behaviour.movebehaviours.targetted_entities")
local NAN_police = "NAN found!"
function base.updateGotoTarget(ent, pos_x, pos_y, dt)
    local sp = ent.pos
    local d = dist(pos_x - sp.x, pos_y - sp.y)
    if d < 0.1 then -- if d is low, don't bother
        return
    end
    local vx = ((pos_x - sp.x)/d) * ent.speed.speed * dt
    local vy = ((pos_y - sp.y)/d) * ent.speed.speed * dt
    assert(vx == vx, NAN_police)
    assert(vy == vy, NAN_police)
    --previously ccall("addVel") was used here. 
    Cyan.call("addVel", ent, vx, vy)
end
function base.controlledGotoTarget(ent, pos_x, pos_y, dt)
    local sp = ent.pos
    local d = dist(pos_x - sp.x, pos_y - sp.y)
    if d < 0.1 then -- if d is low, don't bother
        return
    end
    local vx = ((pos_x - sp.x)/d) * ent.speed.speed
    local vy = ((pos_y - sp.y)/d) * ent.speed.speed
    assert(vx == vx, NAN_police)
    assert(vy == vy, NAN_police)
    --previously ccall("addVel") was used here. 
    Cyan.call("setVel", ent, vx, vy)
end
function base.setTargEnt(ent, target_ent)
    -- Bit costly but oh well, no better way
    -- Calling with `nil` as the target_ent will simply remove the target ent
    -- appropriately
    -- This function is important as it ensures no memory leaks.
    local move = ent.behaviour.move
    if move.target_ent then
        local targ = move.target_ent
        if rawget(TargettedEntities, targ) then
            TargettedEntities[targ]:remove(ent)
            if TargettedEntities[targ].size == 0 then
                rawset(TargettedEntities, targ, nil)
            end
        end
    end
    move.target_ent = target_ent
    if target_ent then
        TargettedEntities[target_ent]:add(ent)
    end
end
local rand = love.math.random
base.rand = rand
base.rand_choice = Tools.rand_choice
function base.chooseRandPos(e,dist)
    local x,y = e.pos.x, e.pos.y
    local nx,ny
    repeat
        nx = x+(rand()-0.5)*dist*2
        ny = y+(rand()-0.5)*dist*2
    until (not Tools.isIntersect(x,y,nx,ny))
    return nx,ny
end
-- Temporary stack buffer for MoveBSystems to use
base.tmp_stack = {len=0}
function base.psh(stk, item) --Stack push
    stk.len = stk.len + 1
    stk[stk.len] = item
end
function base.pop(stk, item) -- Stack pop
    stk[stk.len] = nil
    stk.len = stk.len - 1
end
return base_mt
--[[
MoveBehaviour :: CLOCKON (concentrated lockon)
required fields:
.move = {
    id = <target id>
}
]]
local CLOCKON = { }
local Partitions = require("src.misc.unique.partition_targets")
function CLOCKON:update(e, dt)
    -- self is ent
    local move = e.behaviour.move
    if not move.initialized then
        self:init(e)
    end
    local target_ent = move.target_ent
    if not target_ent then
        return nil -- No target given, fine by me
    end
    local tp = target_ent.pos -- BUG:: for some reason, `tp` is a vector in this case
    self.controlledGotoTarget(e, tp.x, tp.y, dt)
end
function CLOCKON:init(e)
    local move = e.behaviour.move
    local id = move.id
    local targ_ent = nil
    local tmp_stack = self.tmp_stack -- temporary stack
    for ent in Partitions[id]:foreach(e.pos.x, e.pos.y) do
        self.psh(tmp_stack, ent)
    end
    local stack_len = #tmp_stack 
    local i = self.rand(stack_len)
    if stack_len ~= 0 then
        targ_ent = tmp_stack[i]
    end
    for _ = 1, stack_len do
        self.pop(tmp_stack)
    end
    assert(#tmp_stack == 0,"BUG!")
    self.setTargEnt(e, targ_ent)
    move.initialized = true
end
function CLOCKON:h_update(e)
    local move = e.behaviour.move
    local id = move.id
    local targ_ent = nil
    local tmp_stack = self.tmp_stack
    for ent in Partitions[id]:foreach(e.pos.x, e.pos.y) do
        self.psh(tmp_stack, ent)
    end
    local stack_len = #tmp_stack 
    local i = self.rand(stack_len)
    if stack_len ~= 0 then
        targ_ent = tmp_stack[i]
    end
    for _ = 1, stack_len do
        self.pop(tmp_stack)
    end
    assert(#tmp_stack==0,"BUG")
    self.setTargEnt(e, targ_ent)
end
return setmetatable(CLOCKON, require(Tools.Path(...)..".base"))
local CORBIT = {
    --[[
    MoveBehaviour :: CORBIT (concentrated orbit)
    required fields:
    .move = {
        id = <target id>
        orbit_tick = 0;
        orbit_speed = 0.2;   -- how many orbits is done per second
        orbit_radius = 60; -- the radius of which the ent will orbit around
    }
    ]]
    }
    local Partitions = require("src.misc.unique.partition_targets")
    local sin, cos = math.sin, math.cos
    local DEFAULT_RADIUS = 60
    function CORBIT:update(e, dt)
        --[[
            This function is bad as well. Is costly.
                I dont think there is way around tho
        ]]
        local move = e.behaviour.move
        if not move.initialized then
            self:init(e)
        end
        move.orbit_tick = (move.orbit_tick + move.orbit_speed * dt) % (math.pi*2)
        local target_ent = move.target_ent
        if not target_ent then
            return nil -- No target given, fine by me
        end
        local rad = move.orbit_radius or DEFAULT_RADIUS
        local tp = target_ent.pos
        self.controlledGotoTarget(e, tp.x + rad*sin(move.orbit_tick),
                                tp.y + rad*cos(move.orbit_tick),dt)
    end
    function CORBIT:init(e)
        -- field assertion
        local move = e.behaviour.move
        assert(move.orbit_tick)
        assert(move.orbit_speed)
        -- now, proper func
        local id = move.id
        local targ_ent = nil
        local tmp_stack = self.tmp_stack
        assert(e.pos)
        assert(id)
        local partition = Partitions[id]
        assert(partition,id)
        for ent in partition:foreach(e.pos.x, e.pos.y) do
            self.psh(tmp_stack, ent)
        end
        local stack_len = #tmp_stack 
        local i = self.rand(stack_len)
        if stack_len ~= 0 then
            targ_ent = tmp_stack[i]
        end
        for ii = 1, stack_len do
            self.pop(tmp_stack)
        end
        assert(#tmp_stack == 0, "caught bug!")
        self.setTargEnt(e, targ_ent)
        move.initialized = true
    end
    function CORBIT:h_update(e)
        local move = e.behaviour.move
        local id = move.id
        local targ_ent = nil
        local tmp_stack = self.tmp_stack
        assert(#tmp_stack == 0, "bug!")
        assert(id,"ent had no id")
        for ent in Partitions[id]:foreach(e.pos.x, e.pos.y) do
            self.psh(tmp_stack, ent)
        end
        local stack_len = #tmp_stack 
        local i =  self.rand(stack_len)
        if stack_len ~= 0 then
            targ_ent = tmp_stack[i]
        end
        for ii = 1, stack_len do
            self.pop(tmp_stack)
        end
        assert(#tmp_stack == 0, "bug!")
        self.setTargEnt(e, targ_ent)
    end
    return setmetatable(CORBIT, require(Tools.Path(...)..".base"))
local HIVE={}
local Partitions = require("src.misc.unique.partition_targets")
function HIVE:init(e)
    local move = e.behaviour.move
    local sum_x = 0
    local sum_y = 0
    local tot = 0
    for ent in Partitions[move.id]:foreach(e.pos.x, e.pos.y) do
        sum_x = sum_x + ent.pos.x
        sum_y = sum_y + ent.pos.y
        tot = tot + 1
    end
    if tot ~= 0 then
        move.target = math.vec3(sum_x/tot, sum_y/tot, 0)
    else
        move.target = nil
    end
    move.initialized = true
end
function HIVE:update(e,dt)
    local move = e.behaviour.move
    if not move.initialized then
        self:init(e)
    end
    local target = move.target
    if target then
        self.updateGotoTarget(e, target.x, target.y, dt)
    else
        -- If no goto target, stay still. (Behaviour tree should sort this shit out :/ )
        self.updateGotoTarget(e, e.pos.x, e.pos.y, dt)
    end
end
function HIVE:h_update(e)
    local move = e.behaviour.move
    local sum_x = 0
    local sum_y = 0
    local tot = 0
    for ent in Partitions[move.id]:foreach(e.pos.x, e.pos.y) do
        sum_x = sum_x + ent.pos.x
        sum_y = sum_y + ent.pos.y
        tot = tot + 1
    end
    if tot > 0 then
        move.target = math.vec3(sum_x/tot, sum_y/tot, 0)
    else
        move.target = nil 
    end
end
return setmetatable(HIVE, require(Tools.Path(...)..".base"))
local IDLE = {}
function IDLE:init()
end
function IDLE:update(dt)
end
return IDLE
--[[
MoveBehaviour :: LOCKON
required fields:
.move = {
    id = <target id>
}
]]
local LOCKON = { }
local Partitions = require("src.misc.unique.partition_targets")
function LOCKON:update(e, dt)
    -- self is ent
    local move = e.behaviour.move
    if not move.initialized then
        self:init(e)
    end
    local target_ent = move.target_ent
    if not target_ent then
        return nil -- No target given, fine by me
    end
    local tp = target_ent.pos -- BUG:: for some reason, `tp` is a vector in this case
    self.updateGotoTarget(e, tp.x, tp.y, dt)
end
function LOCKON:init(e)
    local move = e.behaviour.move
    local id = move.id
    local targ_ent = nil
    local tmp_stack = self.tmp_stack -- temporary stack
    for ent in Partitions[id]:foreach(e.pos.x, e.pos.y) do
        self.psh(tmp_stack, ent)
    end
    local stack_len = #tmp_stack 
    local i = self.rand(stack_len)
    if stack_len ~= 0 then
        targ_ent = tmp_stack[i]
    end
    for _ = 1, stack_len do
        self.pop(tmp_stack)
    end
    assert(#tmp_stack == 0,"BUG!")
    self.setTargEnt(e, targ_ent)
    move.initialized = true
end
function LOCKON:h_update(e)
    local move = e.behaviour.move
    local id = move.id
    local targ_ent = nil
    local tmp_stack = self.tmp_stack
    for ent in Partitions[id]:foreach(e.pos.x, e.pos.y) do
        self.psh(tmp_stack, ent)
    end
    local stack_len = #tmp_stack 
    local i = self.rand(stack_len)
    if stack_len ~= 0 then
        targ_ent = tmp_stack[i]
    end
    for _ = 1, stack_len do
        self.pop(tmp_stack)
    end
    assert(#tmp_stack==0,"BUG")
    self.setTargEnt(e, targ_ent)
end
return setmetatable(LOCKON, require(Tools.Path(...)..".base"))
local ORBIT = {
--[[
MoveBehaviour :: ORBIT
required fields:
.move = {
    id = <target id>
    orbit_tick = 0;
    orbit_speed = 0.2;   -- how many orbits is done per second
    orbit_radius = 60; -- the radius of which the ent will orbit around
}
]]
}
local Partitions = require("src.misc.unique.partition_targets")
local sin, cos = math.sin, math.cos
local DEFAULT_RADIUS = 60
function ORBIT:update(e, dt)
    --[[
        This function is bad as well. Is costly.
            I dont think there is way around tho
    ]]
    local move = e.behaviour.move
    if not move.initialized then
        self:init(e)
    end
    move.orbit_tick = (move.orbit_tick + move.orbit_speed * dt) % (math.pi*2)
    local target_ent = move.target_ent
    if not target_ent then
        return nil -- No target given, fine by me
    end
    local rad = move.orbit_radius or DEFAULT_RADIUS
    local tp = target_ent.pos
    self.updateGotoTarget(e, tp.x + rad*sin(move.orbit_tick),
                            tp.y + rad*cos(move.orbit_tick),dt)
end
function ORBIT:init(e)
    -- field assertion
    local move = e.behaviour.move
    assert(move.orbit_tick)
    assert(move.orbit_speed)
    -- now, proper func
    local id = move.id
    local targ_ent = nil
    local tmp_stack = self.tmp_stack
    assert(e.pos)
    assert(id)
    local partition = Partitions[id]
    assert(partition,id)
    for ent in partition:foreach(e.pos.x, e.pos.y) do
        self.psh(tmp_stack, ent)
    end
    local stack_len = #tmp_stack 
    local i = self.rand(stack_len)
    if stack_len ~= 0 then
        targ_ent = tmp_stack[i]
    end
    for ii = 1, stack_len do
        self.pop(tmp_stack)
    end
    assert(#tmp_stack == 0, "caught bug!")
    self.setTargEnt(e, targ_ent)
    move.initialized = true
end
function ORBIT:h_update(e)
    local move = e.behaviour.move
    local id = move.id
    local targ_ent = nil
    local tmp_stack = self.tmp_stack
    assert(#tmp_stack == 0, "bug!")
    assert(id,"ent had no id")
    for ent in Partitions[id]:foreach(e.pos.x, e.pos.y) do
        self.psh(tmp_stack, ent)
    end
    local stack_len = #tmp_stack 
    local i =  self.rand(stack_len)
    if stack_len ~= 0 then
        targ_ent = tmp_stack[i]
    end
    for ii = 1, stack_len do
        self.pop(tmp_stack)
    end
    assert(#tmp_stack == 0, "bug!")
    self.setTargEnt(e, targ_ent)
end
return setmetatable(ORBIT, require(Tools.Path(...)..".base"))
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
--[[
MoveBehaviour :: SOLO
Runs away from a random target entity in target group
required fields:
.move = {
    id = <target id>
}
]]
local SOLO = { }
local Partitions = require("src.misc.unique.partition_targets")
function SOLO:update(e, dt)
    -- self is ent
    local move = e.behaviour.move
    if not move.initialized then
        self:init(e)
    end
    local target_ent = move.target_ent
    if not target_ent then
        return nil -- No target given, fine by me
    end
    local tp = target_ent.pos
    local ep = e.pos
    self.updateGotoTarget(e, ep.x + ep.x-tp.x, ep.y + ep.y-tp.y, dt)
end
function SOLO:init(e)
    local move = e.behaviour.move
    local id = move.id
    local targ_ent = nil
    local tmp_stack = self.tmp_stack -- temporary stack
    for ent in Partitions[id]:foreach(e.pos.x, e.pos.y) do
        self.psh(tmp_stack, ent)
    end
    local stack_len = #tmp_stack 
    local i = self.rand(stack_len)
    if stack_len ~= 0 then
        targ_ent = tmp_stack[i]
    end
    for _ = 1, stack_len do
        self.pop(tmp_stack)
    end
    assert(#tmp_stack == 0,"BUG!")
    self.setTargEnt(e, targ_ent)
    move.initialized = true
end
function SOLO:h_update(e)
    local move = e.behaviour.move
    local id = move.id
    local targ_ent = nil
    local tmp_stack = self.tmp_stack
    for ent in Partitions[id]:foreach(e.pos.x, e.pos.y) do
        self.psh(tmp_stack, ent)
    end
    local stack_len = #tmp_stack 
    local i = self.rand(stack_len)
    if stack_len ~= 0 then
        targ_ent = tmp_stack[i]
    end
    for _ = 1, stack_len do
        self.pop(tmp_stack)
    end
    assert(#tmp_stack==0,"BUG")
    self.setTargEnt(e, targ_ent)
end
return setmetatable(SOLO, require(Tools.Path(...)..".base"))
--[[
This is not a MoveBehaviour!
This is a data structure ===>
This data structure keeps record of what entities are tracking other ents.
For example:
{
    [ ent1 ] = set( ent2, ent3, ent4 )
}
This tells us that `ent1` is being tracked by `ent2`, `ent3`, and `ent4`.
(The reason for using this, is because it allows us to ensure that
entities wont track destroyed entities. Having a data structure like this
allows us to do this stuff in a really nice, event driven way)
]]
return setmetatable({ },
--[[
    2d array of sets, keyed with entities that have been targetted.
    On entity deletion, all entities in the targetted set must be removed
]]
{__index = function(t,k)
    t[k] = Tools.set() return t[k]
end})
--[[
Vector based version of `LOCKON`
MoveBehaviour.
MoveBehaviour :: VECLOCKON
.move = {
    target = vec3(...)
}
]]
local VECLOCKON = { }
local Partitions = require("src.misc.unique.partition_targets")
function VECLOCKON:update(e, dt)
    -- self is ent
    local move = e.behaviour.move
    if not move.initialized then
        self:init(e)
    end
    local target_ent = move.target_ent
    if not target_ent then
        return nil -- No target given, fine by me
    end
    local tp = target_ent.pos -- BUG:: for some reason, `tp` is a vector in this case
    self.updateGotoTarget(e, tp.x, tp.y, dt)
end
function VECLOCKON:init(e)
    local move = e.behaviour.move
    move.initialized = true
end
return setmetatable(VECLOCKON, require(Tools.Path(...)..".base"))
--[[
Vector based version of `ORBIT`
MoveBehaviour.
MoveBehaviour :: VECORBIT
.move = {
    target = vec3(...)
    orbit_tick = 0;
    orbit_speed = 0.2;   -- how many orbits is done per second
    orbit_radius = 60; -- the radius of which the ent will orbit around
}
]]
local sin, cos = math.sin, math.cos
local DEFAULT_RADIUS = 60
local VECORBIT = { }
function VECORBIT:update(e, dt)
    local move = e.behaviour.move
    if not move.initialized then
        self:init(e)
    end
    move.orbit_tick = (move.orbit_tick + move.orbit_speed * dt) % (math.pi*2)
    local target = move.target
    if not target then
        return nil -- No target given, fine by me. don't move the ent
    end
    local rad = move.orbit_radius or DEFAULT_RADIUS
    self.updateGotoTarget(e, target.x + rad*sin(move.orbit_tick),
                            target.y + rad*cos(move.orbit_tick), dt)
end
function VECORBIT:init(e)
    -- field assertion
    local move = e.behaviour.move
    assert(move.orbit_tick)
    assert(move.orbit_speed)
    move.initialized = true
end
return setmetatable(VECORBIT, require(Tools.Path(...)..".base"))
local B=require'libs.BehaviourTree'
local task = B.Task("boom")
task.run=function(t,e)
        local strength = 15 -- default is 15
        if e.strength then
            strength = e.strength
        end
        Cyan.call("boom", e.pos.x, e.pos.y, strength)
        return "n"
end
local B=require'libs.BehaviourTree'
local task = B.Task'moob'
task.run=function(t,e)
    local strength = 15 -- default is 15
    if e.strength then
        strength = e.strength
    end
    Cyan.call("moob", e.pos.x, e.pos.y, strength)
    return "n"
end
local BT = require("libs.BehaviourTree")
local ccall=Cyan.call
local tab = {"IDLE","ROOK","LOCKON","ORBIT","RAND","SOLO",
            "CORBIT","CLOCKON","VECORBIT","VECLOCKON"}
local f = function() return "n" end
for _,t in ipairs(tab) do
    local task = BT.Task("move::"..t)
    -- We dont need to do xtra permutations for targetIDs,
    -- because targetID can be changed at runtime no problemo.
    task.start = function(T, e)
        assert(e.behaviour, "you made mistake")
        assert(e.behaviour.move, "you made mistake")
        ccall("setMoveBehaviour", e, t, e.behaviour.move.id)
    end
    task.update = f;
end
local B=require'libs.BehaviourTree'
local er_no_hp = "Entity had no HP, how were you expecting to kill it??"
local task = B.Task("suiy")
task.run=function(t,e)
    assert(e.hp, er_no_hp)
    Cyan.call("damage", e, 0xfffffffffff)
    return "n"
end
--[[
wait tasks, 1 -> 10.
wait1 --> wait 1 second
wait2 --> wait 2 seconds
wait3 --> wait 3 seconds
...
etc etc.
...
wait10 --> wait 10 seconds
]]
local B=require'libs.BehaviourTree'
local ccall = Cyan.call
for N = 1, 10 do
    name = "wait::"..tostring(N)
    local task = B.Task(name)
    task.start = function(t,e)
    end
    task.update = function(t, e, dt)
        local ret
        if t:runtime(e)>N then
            ret= "n"
        else
            ret="r"
        end
        return ret
    end
    task.finish = function(t,e)
    end
end
-- also add a wait::r task that waits a small time, usually like 0.5 seconds
-- (But with a max of 2 seconds )
local _wait_r = B.Task("wait::r")
local rand = love.math.random
_wait_r.update=function(t,e,dt)
    local ret
    if (rand()*2) >  t:runtime(e) then
        ret= "n"
    else
        ret="r"
    end
    return ret
end
local speedChanges = setmetatable({
    -- [ ent ] = speed_change
},{__mode="kv"})
local cexists = Cyan.exists
return {
    buff = function(e, amount)
        speedChanges[e] = amount
        local spd = e.speed;
        -- Just give it a whole new table. Its (probably) very safe
        -- (definitely safer than alternative anyway lol)
        e.speed = {
            speed = spd.speed + amount,
            max_speed = spd.max_speed + amount
        }
    end;
    debuff = function(e)
        local am = speedChanges[e]
        if not am then
            return
        end
        if cexists(e) then
            e.speed.max_speed = e.speed.max_speed - am
            e.speed.speed = e.speed.speed - am
        end
    end
} 
local oldColours = setmetatable({
    -- [ ent ] = colour
},{__mode="k"})
local cexists = Cyan.exists
return {
    buff = function(e, col)
        oldColours[e] = e.colour
        e.colour = col
    end;
    debuff = function(e)
        local col = oldColours[e]
        if not col then
            -- either the ent has been GC'd, 
            -- OR the ent had no colour to begin with.
            -- default to white
            col = {1,1,1,1}
        end
        if cexists(e) then
            e.colour = col
        end
    end
} 
local path = Tools.Path(...)
local shover = {}
shover = Tools.req_TREE(path:gsub("%.","/").."/bufflist", shover)
return shover
--[[ ]]
Cyan.call("newWorld",{
    x=100,y=100,
    tier = 1,
    type = 'menu'
}, require("src.misc.worldGen.menu"))
--]]
--[[
local gladmap = require("gladiator_map")
ccall("newWorld",{
    x = #gladmap[1];
    y = #gladmap;
    tier=1;
    type="gladiator"
}, gladmap)
--]]
local rand = love.math.random
local Ents = require("src.entities")
local cam = require("src.misc.unique.camera")
local Atlas = require("assets.atlas")
local DEBUG_SYS = Cyan.System()
local lg = love.graphics
function DEBUG_SYS:keypressed(k)
    if k=='p' then
        CONSTANTS.paused = not CONSTANTS.paused
    end
    if k == "e" then
        ccall("emit",("blue_mushroom"),cam.x,cam.y, 0, 2)
    end
end
function DEBUG_SYS:draw()
    lg.setColor(1,1,1)
    lg.push()
    lg.reset()
    love.graphics.rectangle("fill", 5, 95, 150, 40)
    lg.setColor(0,0,0)
    love.graphics.print("FPS: ".. tostring(love.timer.getFPS()), 10,100)
    love.graphics.print(("MEM USAGE: %d"):format(tostring(collectgarbage("count"))), 10, 120)
    lg.pop()
end
--[[
local tick = 0
local sin = function(x)
    return math.abs(math.sin(x))
end
function DEBUG_SYS:update(dt)
    tick = (tick + dt*3) % (2*math.pi)
    CONSTANTS.grass_colour = {sin(tick + 1), sin(tick + 2), sin(tick +3)}
end
]]
local ccall=Cyan.call
function DEBUG_SYS:mousepressed()
end
local PATH = Tools.Path(...)
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
--[[
"Oli, why aren't you using __index inheritance for this?"
-> Because each emitter is effectively a class. (__init__ => :clone).
Multiple inheritence is definitely possible but not something I want
to mess with rn
]]
local er1 = "Not given a required function!"
for k, emitr in pairs(ParticleTypes) do    
    assert(emitr.emit, er1)
    assert(emitr.isFinished,er1)
    assert(emitr.clone, er1)
    assert(emitr.release, er1)
    assert(emitr.draw, er1)
    assert(emitr.type,er1)
end
return ParticleTypes
--[[
This... is really trash.
Use an animation for teleportation
]]
local atlas = require "assets.atlas"
local Quads = atlas.Quads
-- This emitter's ParticleSystems must not have particles that survive for
-- any longer than this!
local MAX_PARTICLE_TIME = 0.4
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.bot)
    psys:setParticleLifetime(0.35, MAX_PARTICLE_TIME)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(-400,-350)
    psys:setEmissionRate(0)
    psys:setSpread(0)
    psys:setEmissionArea("normal", 10,20)
    psys:setColors({1,1,1,0.5},{1,1,1}, {1,1,1},{1,1,1,0.5})
    psys:setSpin(0,0)
    psys:setRotation(0,0)
    psys:setRelativeRotation(false)
    psys:setLinearAcceleration(0, 0)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local PS1 = psys:clone()
PS1:setQuads(Quads.beam)
--PS1:setSpeed(-1000,-300)
local PS2 = psys:clone()
PS2:setQuads(Quads.bigbeam)
local psyses = {
    PS1, PS2
}
local emitter
emitter = {
    psyses = psyses,
    type = "beam",
    runtime = 0
}
emitter.mt = {__index = emitter}
local ceil = math.ceil
local rand = math.random
function emitter:emit(x,y,n)
    for i, ps in ipairs(self.psyses) do
        ps:emit(n)
    end
end
function emitter:clone()
    local tab = setmetatable({
        psyses = {};
        runtime = 0;
        mt = self.mt
    }, self.mt)
    for i,ps in ipairs(psyses)do
        table.insert(tab.psyses, ps:clone())
    end
    return tab
end
local draw = love.graphics.draw
function emitter:draw(x,y,z)
    for i,ps in ipairs(self.psyses) do
        draw(ps, x,(y - z/2)-200)
    end
end
function emitter:update(dt)
    for i,ps in ipairs(self.psyses) do
        ps:update(dt)
    end
    self.runtime = self.runtime + dt
end
function emitter:isFinished()
    return self.runtime > MAX_PARTICLE_TIME
end
function emitter:release()
    for k,ps in ipairs(self.psyses)do
        ps:release()
    end
end
return emitter
local atlas = require "assets.atlas"
local Quads = atlas.Quads
-- This emitter's ParticleSystems must not have particles that survive for
-- any longer than this!
local MAX_PARTICLE_TIME = 1
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.bot)
    psys:setParticleLifetime(0.6, MAX_PARTICLE_TIME)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(60,70)
    psys:setEmissionRate(0)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 6,40)
    psys:setColors({1,1,1}, {1,1,1,0.5})
    psys:setSpin(0,0)
    psys:setRotation(-2*math.pi, 2*math.pi)
    psys:setRelativeRotation(false)
    psys:setLinearAcceleration(0, 250)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local psyses = {}
do
    --[[
        This bit of code is for loading the quads,
        and creating particleSystems out of each of them
    ]]
    local ps_quads = {} -- these are the quads that get emitted:
    for i=1, 8 do
        local quad = "blue_mushroom_particle"..tostring(i)
        table.insert(ps_quads, quad)
    end
    for i,str in ipairs(ps_quads) do
        if str == "NULL CHECK" then
            error("Did you forget to name the quads in `ps_quads`?")
        end
        local quad = Quads[str]
        assert(quad, "undefined quad :: ".. str)
        local newps = psys:clone()
        newps:setQuads(quad)
        table.insert(psyses, newps)
    end
end
local emitter
emitter = {
    psyses = psyses,
    type = "blue_mushroom",
    runtime = 0
}
emitter.mt = {__index = emitter}
local ceil = math.ceil
local rand = math.random
function emitter:emit(x,y,n)
    for i, ps in ipairs(self.psyses) do
        ps:emit(n)
    end
end
function emitter:clone()
    local tab = setmetatable({
        psyses = {};
        runtime = 0;
        mt = self.mt
    }, self.mt)
    for i,ps in ipairs(psyses)do
        table.insert(tab.psyses, ps:clone())
    end
    return tab
end
local draw = love.graphics.draw
function emitter:draw(x,y,z)
    for i,ps in ipairs(self.psyses) do
        draw(ps, x,y - z/2)
    end
end
function emitter:update(dt)
    for i,ps in ipairs(self.psyses) do
        ps:update(dt)
    end
    self.runtime = self.runtime + dt
end
function emitter:isFinished()
    return self.runtime > MAX_PARTICLE_TIME
end
function emitter:release()
    for k,ps in ipairs(self.psyses)do
        ps:release()
    end
end
return emitter
local atlas = require "assets.atlas"
local Quads = atlas.Quads
-- This emitter's ParticleSystems must not have particles that survive for
-- any longer than this!
local MAX_PARTICLE_TIME = 1
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.circ4, Quads.circ3, Quads.circ2, Quads.circ1)
    psys:setParticleLifetime(0.6, MAX_PARTICLE_TIME)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(60,70)
    psys:setEmissionRate(0)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 6,12)
    psys:setColors({1,1,1}, {1,1,1,0.2})
    psys:setSpin(0,0)
    psys:setRotation(-2*math.pi, 2*math.pi)
    psys:setRelativeRotation(false)
    psys:setLinearAcceleration(0, 250)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local psyses = {psys}
local emitter
emitter = {
    psyses = {},
    type = "dust",
    runtime = 0
}
emitter.mt = {__index = emitter}
local ceil = math.ceil
local rand = math.random
function emitter:emit(x,y,n)
    for i, ps in ipairs(self.psyses) do
        ps:emit(n)
    end
end
function emitter:clone()
    local tab = setmetatable({
        psyses = {};
        runtime = 0;
        mt = self.mt
    }, self.mt)
    for i,ps in ipairs(psyses)do
        table.insert(tab.psyses, ps:clone())
    end
    return tab
end
local draw = love.graphics.draw
function emitter:draw(x,y,z)
    for i,ps in ipairs(self.psyses) do
        draw(ps, x,y - z/2)
    end
end
function emitter:update(dt)
    for i,ps in ipairs(self.psyses) do
        ps:update(dt)
    end
    self.runtime = self.runtime + dt
end
function emitter:isFinished()
    return self.runtime > MAX_PARTICLE_TIME
end
function emitter:release()
    for k,ps in ipairs(self.psyses)do
        ps:release()
    end
end
return emitter
local atlas = require "assets.atlas"
local Quads = atlas.Quads
-- This emitter's ParticleSystems must not have particles that survive for
-- any longer than this!
local MAX_PARTICLE_TIME = 0.65
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.gut1)
    psys:setParticleLifetime(0.5, MAX_PARTICLE_TIME)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(50,55)
    psys:setEmissionRate(0)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 6,6)
    psys:setColors({1,1,1}, {1,0.5,0.5,0.5})
    psys:setSpin(-10,10)
    psys:setRotation(-2*math.pi, 2*math.pi)
    psys:setRelativeRotation(true)
    psys:setLinearAcceleration(0, 250)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local psyses = {}
do
    for i=1, 7 do
        local str = "gutb"..tostring(i)
        local quad = Quads[str]
        assert(quad, "wat??")
        local newps = psys:clone()
        newps:setQuads(quad)
        table.insert(psyses, newps)
    end
end
local emitter
emitter = {
    psyses = {},
    type = "guts",
    runtime = 0
}
emitter.mt = {__index = emitter}
local ceil = math.ceil
local rand = math.random
function emitter:emit(x,y,n)
    for i, v in ipairs(self.psyses) do
        -- random modifier :: some guts aren't emitted
        if rand() < 0.5 then
            v:emit(n/2)
        end
    end
end
function emitter:clone()
    local tab = setmetatable({
        psyses = {};
        runtime = 0;
        mt = self.mt
    }, self.mt)
    for i,ps in ipairs(psyses)do
        table.insert(tab.psyses, ps:clone())
    end
    return tab
end
local draw = love.graphics.draw
function emitter:draw(x,y,z)
    for i,ps in ipairs(self.psyses) do
        draw(ps, x,y - z/2)
    end
end
function emitter:update(dt)
    for i,ps in ipairs(self.psyses) do
        ps:update(dt)
    end
    self.runtime = self.runtime + dt
end
function emitter:isFinished()
    return self.runtime > MAX_PARTICLE_TIME
end
function emitter:release()
    for k,ps in ipairs(self.psyses)do
        ps:release()
    end
end
return emitter
local atlas = require "assets.atlas"
local Quads = atlas.Quads
-- This emitter's ParticleSystems must not have particles that survive for
-- any longer than this!
local MAX_PARTICLE_TIME = 1
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.bot)
    psys:setParticleLifetime(0.6, MAX_PARTICLE_TIME)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(60,70)
    psys:setEmissionRate(0)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 23,23)
    psys:setColors({1,1,1}, {1,1,1,0.5})
    psys:setSpin(0,0)
    psys:setRotation(-2*math.pi, 2*math.pi)
    psys:setRelativeRotation(false)
    psys:setLinearAcceleration(0, 250)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local psyses = {}
do
    --[[
        This bit of code is for loading the quads,
        and creating particleSystems out of each of them
    ]]
    local ps_quads = {} -- these are the quads that get emitted:
    for i=1, 8 do
        local quad = "red_mushroom_particle"..tostring(i)
        table.insert(ps_quads, quad)
    end
    for i,str in ipairs(ps_quads) do
        if str == "NULL CHECK" then
            error("Did you forget to name the quads in `ps_quads`?")
        end
        local quad = Quads[str]
        assert(quad, "undefined quad :: ".. str)
        local newps = psys:clone()
        newps:setQuads(quad)
        table.insert(psyses, newps)
    end
end
local emitter
emitter = {
    psyses = psyses,
    type = "mushroom",
    runtime = 0
}
emitter.mt = {__index = emitter}
local ceil = math.ceil
local rand = math.random
function emitter:emit(x,y,n)
    for i, ps in ipairs(self.psyses) do
        ps:emit(n)
    end
end
function emitter:clone()
    local tab = setmetatable({
        psyses = {};
        runtime = 0;
        mt = self.mt
    }, self.mt)
    for i,ps in ipairs(psyses)do
        table.insert(tab.psyses, ps:clone())
    end
    return tab
end
local draw = love.graphics.draw
function emitter:draw(x,y,z)
    for i,ps in ipairs(self.psyses) do
        draw(ps, x,y - z/2)
    end
end
function emitter:update(dt)
    for i,ps in ipairs(self.psyses) do
        ps:update(dt)
    end
    self.runtime = self.runtime + dt
end
function emitter:isFinished()
    return self.runtime > MAX_PARTICLE_TIME
end
function emitter:release()
    for k,ps in ipairs(self.psyses)do
        ps:release()
    end
end
return emitter
local atlas = require "assets.atlas"
local Quads = atlas.Quads
-- This emitter's ParticleSystems must not have particles that survive for
-- any longer than this!
local MAX_PARTICLE_TIME = 0.7
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.bot)
    psys:setParticleLifetime(0.4, MAX_PARTICLE_TIME)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(60,70)
    psys:setEmissionRate(0)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 6,6)
    psys:setColors({1,1,1}, {1,1,1,0.5})
    psys:setSpin(0,0)
    psys:setRotation(-2*math.pi, 2*math.pi)
    psys:setRelativeRotation(false)
    psys:setLinearAcceleration(0, 250)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local psyses = {}
do
    --[[
        This bit of code is for loading the quads,
        and creating particleSystems out of each of them
    ]]
    local ps_quads = {} -- these are the quads that get emitted:
    for i=1,5 do
        table.insert(ps_quads, "rock_particle"..tostring(i))
    end
    for i,str in ipairs(ps_quads) do
        if str == "NULL CHECK" then
            error("Did you forget to name the quads in `ps_quads`?")
        end
        local quad = Quads[str]
        assert(quad, "undefined quad :: ".. str)
        local newps = psys:clone()
        newps:setQuads(quad)
        newps:setSpin((love.math.random()-0.5)*3)
        table.insert(psyses, newps)
    end
end
local emitter
emitter = {
    psyses = {},
    type = "rocks",
    runtime = 0
}
emitter.mt = {__index = emitter}
local ceil = math.ceil
local rand = math.random
function emitter:emit(x,y,n)
    for i, ps in ipairs(self.psyses) do
        ps:emit(n)
    end
end
function emitter:clone()
    local tab = setmetatable({
        psyses = {};
        runtime = 0;
        mt = self.mt
    }, self.mt)
    for i,ps in ipairs(psyses)do
        table.insert(tab.psyses, ps:clone())
    end
    return tab
end
local draw = love.graphics.draw
function emitter:draw(x,y,z)
    for i,ps in ipairs(self.psyses) do
        draw(ps, x,y - z/2)
    end
end
function emitter:update(dt)
    for i,ps in ipairs(self.psyses) do
        ps:update(dt)
    end
    self.runtime = self.runtime + dt
end
function emitter:isFinished()
    return self.runtime > MAX_PARTICLE_TIME
end
function emitter:release()
    for k,ps in ipairs(self.psyses)do
        ps:release()
    end
end
return emitter
local atlas = require "assets.atlas"
local Quads = atlas.Quads
-- This emitter's ParticleSystems must not have particles that survive for
-- any longer than this!
local MAX_PARTICLE_TIME = 1.4
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.shotgunshell)
    psys:setParticleLifetime(1.2, MAX_PARTICLE_TIME)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(100,110)
    psys:setEmissionRate(0)
    psys:setSpread(math.pi/4)
    psys:setEmissionArea("uniform", 3,2)
    psys:setColors({1,1,1}, {1,1,1,0.9})
    psys:setSpin(-5,-5)
    psys:setRotation(-2*math.pi, 2*math.pi)
    psys:setRelativeRotation(false)
    psys:setLinearAcceleration(0, 250)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local psyses = {
    psys
}
local emitter
emitter = {
    psyses = {},
    type = "shell",
    runtime = 0
}
emitter.mt = {__index = emitter}
local ceil = math.ceil
local rand = math.random
function emitter:emit(x,y,n)
    for i, ps in ipairs(self.psyses) do
        ps:emit(n)
    end
end
function emitter:clone()
    local tab = setmetatable({
        psyses = {};
        runtime = 0;
        mt = self.mt
    }, self.mt)
    for i,ps in ipairs(psyses)do
        table.insert(tab.psyses, ps:clone())
    end
    return tab
end
local draw = love.graphics.draw
function emitter:draw(x,y,z)
    for i,ps in ipairs(self.psyses) do
        draw(ps, x,y - z/2)
    end
end
function emitter:update(dt)
    for i,ps in ipairs(self.psyses) do
        ps:update(dt)
    end
    self.runtime = self.runtime + dt
end
function emitter:isFinished()
    return self.runtime > MAX_PARTICLE_TIME
end
function emitter:release()
    for k,ps in ipairs(self.psyses)do
        ps:release()
    end
end
return emitter
local atlas = require "assets.atlas"
local Quads = atlas.Quads
-- This emitter's ParticleSystems must not have particles that survive for
-- any longer than this!
local MAX_PARTICLE_TIME = 1
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.bot)
    psys:setParticleLifetime(0.6, MAX_PARTICLE_TIME)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(60,70)
    psys:setEmissionRate(0)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 10,10)
    psys:setColors({1,1,1}, {1,1,1,0.5})
    psys:setSpin(0,0)
    psys:setRotation(-2*math.pi, 2*math.pi)
    psys:setRelativeRotation(false)
    psys:setLinearAcceleration(0, 250)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local psyses = {}
do
    --[[
        This bit of code is for loading the quads,
        and creating particleSystems out of each of them
    ]]
    local ps_quads = {} -- these are the quads that get emitted:
    for i=1, 8 do
        local quad = "red_mushroom_particle"..tostring(i)
        table.insert(ps_quads, quad)
    end
    for i,str in ipairs(ps_quads) do
        if str == "NULL CHECK" then
            error("Did you forget to name the quads in `ps_quads`?")
        end
        local quad = Quads[str]
        assert(quad, "undefined quad :: ".. str)
        local newps = psys:clone()
        newps:setQuads(quad)
        table.insert(psyses, newps)
    end
end
local emitter
emitter = {
    psyses = psyses,
    type = "small_mushroom",
    runtime = 0
}
emitter.mt = {__index = emitter}
local ceil = math.ceil
local rand = math.random
function emitter:emit(x,y,n)
    for i, ps in ipairs(self.psyses) do
        ps:emit(n)
    end
end
function emitter:clone()
    local tab = setmetatable({
        psyses = {};
        runtime = 0;
        mt = self.mt
    }, self.mt)
    for i,ps in ipairs(psyses)do
        table.insert(tab.psyses, ps:clone())
    end
    return tab
end
local draw = love.graphics.draw
function emitter:draw(x,y,z)
    for i,ps in ipairs(self.psyses) do
        draw(ps, x,y - z/2)
    end
end
function emitter:update(dt)
    for i,ps in ipairs(self.psyses) do
        ps:update(dt)
    end
    self.runtime = self.runtime + dt
end
function emitter:isFinished()
    return self.runtime > MAX_PARTICLE_TIME
end
function emitter:release()
    for k,ps in ipairs(self.psyses)do
        ps:release()
    end
end
return emitter
local atlas = require "assets.atlas"
local Quads = atlas.Quads
-- This emitter's ParticleSystems must not have particles that survive for
-- any longer than this!
local MAX_PARTICLE_TIME = 2
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.bot)
    psys:setParticleLifetime(1.2, 2)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(60,70)
    psys:setEmissionRate(0)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 6,6)
    psys:setColors({1,1,1}, {1,1,1,0.5})
    psys:setSpin(-5,5)
    psys:setRotation(-2*math.pi, 2*math.pi)
    psys:setRelativeRotation(false)
    psys:setLinearAcceleration(0, 250)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local psyses = {}
do
    --[[
        This bit of code is for loading the quads,
        and creating particleSystems out of each of them
    ]]
    local ps_quads = {} -- these are the quads that get emitted
    for i=1,4 do
        table.insert(ps_quads, "smoke"..tostring(i))
    end
    for i,str in ipairs(ps_quads) do
        local quad = Quads[str]
        assert(quad, "undefined quad :: ".. str)
        local newps = psys:clone()
        newps:setQuads(quad)
        table.insert(psyses, newps)
    end
end
local emitter
emitter = {
    psyses = psyses,
    type = "smoke",
    runtime = 0
}
emitter.mt = {__index = emitter}
local ceil = math.ceil
local rand = math.random
function emitter:emit(x,y,n)
    for i, ps in ipairs(self.psyses) do
        ps:emit(n)
    end
end
function emitter:clone()
    local tab = setmetatable({
        psyses = {};
        runtime = 0;
        mt = self.mt
    }, self.mt)
    for i,ps in ipairs(psyses)do
        table.insert(tab.psyses, ps:clone())
    end
    return tab
end
local draw = love.graphics.draw
function emitter:draw(x,y,z)
    for i,ps in ipairs(self.psyses) do
        draw(ps, x,y - z/2)
    end
end
function emitter:update(dt)
    for i,ps in ipairs(self.psyses) do
        ps:update(dt)
    end
    self.runtime = self.runtime + dt
end
function emitter:isFinished()
    return self.runtime > MAX_PARTICLE_TIME
end
function emitter:release()
    for k,ps in ipairs(self.psyses)do
        ps:release()
    end
end
return emitter
local atlas = require "assets.atlas"
local Quads = atlas.Quads
-- This emitter's ParticleSystems must not have particles that survive for
-- any longer than this!
local MAX_PARTICLE_TIME = 0.5
local psys = love.graphics.newParticleSystem(atlas.image)
local SPLAT_COL = CONSTANTS.SPLAT_COLOUR
local START_SPLAT_COLOUR = {SPLAT_COL[1], SPLAT_COL[2], SPLAT_COL[3], 1}
local END_SPLAT_COLOUR = {SPLAT_COL[1], SPLAT_COL[2], SPLAT_COL[3], 0.4}
do
    psys:setQuads(Quads.circ4, Quads.circ3, Quads.circ2)
    psys:setParticleLifetime(0.2, MAX_PARTICLE_TIME)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(60,70)
    psys:setEmissionRate(0)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 12,12)
    psys:setColors(START_SPLAT_COLOUR, END_SPLAT_COLOUR)
    psys:setSpin(0,0)
    psys:setRotation(-2*math.pi, 2*math.pi)
    psys:setRelativeRotation(false)
    psys:setLinearAcceleration(0, 250)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local psyses = {psys}
local emitter
emitter = {
    psyses = {},
    type = "splat",
    runtime = 0
}
emitter.mt = {__index = emitter}
local ceil = math.ceil
local rand = math.random
function emitter:emit(x,y,n)
    for i, ps in ipairs(self.psyses) do
        ps:emit(n)
    end
end
function emitter:clone()
    local tab = setmetatable({
        psyses = {};
        runtime = 0;
        mt = self.mt
    }, self.mt)
    for i,ps in ipairs(psyses)do
        table.insert(tab.psyses, ps:clone())
    end
    return tab
end
local draw = love.graphics.draw
function emitter:draw(x,y,z)
    for i,ps in ipairs(self.psyses) do
        draw(ps, x,y - z/2)
    end
end
function emitter:update(dt)
    for i,ps in ipairs(self.psyses) do
        ps:update(dt)
    end
    self.runtime = self.runtime + dt
end
function emitter:isFinished()
    return self.runtime > MAX_PARTICLE_TIME
end
function emitter:release()
    for k,ps in ipairs(self.psyses)do
        ps:release()
    end
end
return emitter
local atlas = require "assets.atlas"
local Quads = atlas.Quads
-- This emitter's ParticleSystems must not have particles that survive for
-- any longer than this!
local MAX_PARTICLE_TIME = 1
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.bot)
    psys:setParticleLifetime(0.6, MAX_PARTICLE_TIME)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(60,70)
    psys:setEmissionRate(0)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 30,40)
    psys:setColors({1,1,1}, {1,1,1,0.5})
    psys:setRotation(-2*math.pi, 2*math.pi)
    psys:setRelativeRotation(false)
    psys:setLinearAcceleration(0, 250)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local psyses = {}
do
    --[[
        This bit of code is for loading the quads,
        and creating particleSystems out of each of them
    ]]
    local ps_quads = {}
    for i=1,8 do
        table.insert(ps_quads, "wall_particle"..tostring(i))
    end
    for i,str in ipairs(ps_quads) do
        if str == "NULL CHECK" then
            error("Did you forget to name the quads in `ps_quads`?")
        end
        local quad = Quads[str]
        assert(quad, "undefined quad :: ".. str)
        local newps = psys:clone()
        newps:setQuads(quad)
        table.insert(psyses, newps)
    end
end
local emitter
emitter = {
    psyses = {},
    type = "wallbreak",
    runtime = 0
}
emitter.mt = {__index = emitter}
local ceil = math.ceil
local rand = math.random
function emitter:emit(x,y,n)
    for i, ps in ipairs(self.psyses) do
        ps:emit(n)
    end
end
function emitter:clone()
    local tab = setmetatable({
        psyses = {};
        runtime = 0;
        mt = self.mt
    }, self.mt)
    for i,ps in ipairs(psyses)do
        table.insert(tab.psyses, ps:clone())
    end
    return tab
end
local draw = love.graphics.draw
function emitter:draw(x,y,z)
    for i,ps in ipairs(self.psyses) do
        draw(ps, x,y - z/2)
    end
end
function emitter:update(dt)
    for i,ps in ipairs(self.psyses) do
        ps:update(dt)
    end
    self.runtime = self.runtime + dt
end
function emitter:isFinished()
    return self.runtime > MAX_PARTICLE_TIME
end
function emitter:release()
    for k,ps in ipairs(self.psyses)do
        ps:release()
    end
end
return emitter
local atlas = require "assets.atlas"
local Quads = atlas.Quads
-- This emitter's ParticleSystems must not have particles that survive for
-- any longer than this!
local MAX_PARTICLE_TIME = 1
local psys = love.graphics.newParticleSystem(atlas.image)
do
    psys:setQuads(Quads.bot)
    psys:setParticleLifetime(0.6, MAX_PARTICLE_TIME)
    --psys:setLinearAcceleration(0,0,200,200)
    psys:setDirection(-math.pi/2)
    psys:setSpeed(60,70)
    psys:setEmissionRate(0)
    psys:setSpread(math.pi/2)
    psys:setEmissionArea("uniform", 6,6)
    psys:setColors({1,1,1}, {1,1,1,0.5})
    psys:setSpin(0,0)
    psys:setRotation(-2*math.pi, 2*math.pi)
    psys:setRelativeRotation(false)
    psys:setLinearAcceleration(0, 250)
    local _,_, pW, pH = psys:getQuads()[1]:getViewport( )
    psys:setOffset(pW/2, pH/2)
end
local psyses = {}
do
    --[[
        This bit of code is for loading the quads,
        and creating particleSystems out of each of them
    ]]
    local ps_quads = {"NULL CHECK", "bit", "bot", "bat"} -- these are the quads that get emitted:
    for i,str in ipairs(ps_quads) do
        if str == "NULL CHECK" then
            error("Did you forget to name the quads in `ps_quads`?")
        end
        local quad = Quads[str]
        assert(quad, "undefined quad :: ".. str)
        local newps = psys:clone()
        newps:setQuads(quad)
        table.insert(psyses, newps)
    end
end
local emitter
emitter = {
    psyses = {},
    type = "TEMPLATE :: this name must be the same as the file name",
    runtime = 0
}
emitter.mt = {__index = emitter}
local ceil = math.ceil
local rand = math.random
function emitter:emit(x,y,n)
    for i, ps in ipairs(self.psyses) do
        ps:emit(n)
    end
end
function emitter:clone()
    local tab = setmetatable({
        psyses = {};
        runtime = 0;
        mt = self.mt
    }, self.mt)
    for i,ps in ipairs(psyses)do
        table.insert(tab.psyses, ps:clone())
    end
    return tab
end
local draw = love.graphics.draw
function emitter:draw(x,y,z)
    for i,ps in ipairs(self.psyses) do
        draw(ps, x,y - z/2)
    end
end
function emitter:update(dt)
    for i,ps in ipairs(self.psyses) do
        ps:update(dt)
    end
    self.runtime = self.runtime + dt
end
function emitter:isFinished()
    return self.runtime > MAX_PARTICLE_TIME
end
function emitter:release()
    for k,ps in ipairs(self.psyses)do
        ps:release()
    end
end
return emitter
--[[
Main spacial partition scheme.
Note that there is an extra, smaller partitioning scheme directly
created in `MoveBehaviourSys`.
This smaller partitioner only involves ents with `target` components, and
there is one of them for each target group.
]]
local MAX_VEL = CONSTANTS.MAX_VEL;
-- We add 1 off to account for floating point errors. A missed entity search due to
-- ent skipping a cell would be catastrophic and crash program
local p_MAX_VEL = MAX_VEL + 1
local partition = require("libs.spatial_partition.partition")(
    p_MAX_VEL * CONSTANTS.MAX_DT,  p_MAX_VEL * CONSTANTS.MAX_DT
)
return partition
local Sigils = { }
local pth = Tools.Path(...)
Tools.req_TREE(pth:gsub("%.","/") .. "/_sigils", Sigils)
assert(Sigils.strength, "Hmm, req_TREE not working")
local baseSigil = { 
    added = function()end
    ,removed = function()end
    ,update = function()end
    ,draw = function()end
    ,staticUpdate = function()end
}
local Sigil_mt = {
    __index = baseSigil
}
for k,v in pairs(Sigils) do
    setmetatable(v, Sigil_mt)
end
return Sigils
local atlas = require("assets.atlas")
local Quads = atlas.Quads
local Psys = love.graphics.newParticleSystem(atlas.image,2000)
Psys:setColors({1,0,0}, {0.7,0,0}, {0.7,0,0.4})
Psys:setQuads{ Quads.capital }
local _,_, pW, pH = (Psys:getQuads()[1]):getViewport( )
Psys:setOffset(pW/2, pH/2)
Psys:setColors(
   {0,0.2,0},
   {0,0.6,0},
   {0,1,0,0.5},
   {1,1,1,0}
)
Psys:setEmissionRate(8)
Psys:setParticleLifetime(0.9, 1)
Psys:setDirection(-math.pi/2)
Psys:setRotation(0, 0)
Psys:setRelativeRotation(false)
Psys:setSpeed(20,30)
Psys:setEmissionArea("normal", 4,0)
local lg=love.graphics
return {
    staticUpdate = function(dt)
        Psys:update(dt)
    end,
    draw = function(ent)
        local h
        if ent.draw then
            h = ent.draw.h/1.3
        else
            h = 0
        end
        lg.draw(Psys, ent.pos.x, (ent.pos.y - h) - ent.pos.z / 2)
    end
}
local Atlas = require("assets.atlas")
local CROWN_OFFSET=13/2 -- crown is 13 pixels wide
local GOLD = {1,0.83984375,0}
local setColour = love.graphics.setColor
return {
    draw = function(ent)
        local h,w2
        if ent.draw then
            h = ent.draw.h
            w2 = ent.draw.w/2
        else
            h = 0
            w = 0
        end
        setColour(GOLD)
        Atlas:draw(Atlas.Quads.crown, (ent.pos.x - (CROWN_OFFSET)), (ent.pos.y - h) - ent.pos.z / 2)
    end
}
local Atlas = require("assets.atlas")
local CROWN_OFFSET=16/2
local RED = {0.6,0,0}
local ADDED_HEIGHT = 2-- add some height to horn to make it floating
                       --  ((by default tho, this sigil will use `ent.size`.))
local setColour = love.graphics.setColor
return {
    draw = function(ent)
        local h,w2
        if ent.draw then
            h = ent.draw.h
            w2 = ent.draw.w/2
        else
            h = 0
            w = 0
        end
        setColour(RED)
        Atlas:draw(Atlas.Quads.horns, (ent.pos.x - (CROWN_OFFSET)), ((ent.pos.y - h) - ent.pos.z / 2)-(ent.size or ADDED_HEIGHT))
    end
}
local atlas = require("assets.atlas")
local Quads = atlas.Quads
local Psys = love.graphics.newParticleSystem(atlas.image,2000)
Psys:setColors({0,0,0.3}, {0,0,0.5}, {0.1,0.1,0.5})
Psys:setQuads{ Quads.bat, Quads.bot, Quads.bit }
local _,_, pW, pH = (Psys:getQuads()[1]):getViewport( )
Psys:setOffset(pW/2, pH/2)
Psys:setEmissionRate(150)
Psys:setParticleLifetime(0.1, 0.5)
Psys:setDirection(-math.pi/2)
Psys:setRotation(0, 2*math.pi)
Psys:setRelativeRotation(false)
Psys:setSpeed(30,45)
Psys:setEmissionArea("uniform", 2,0)
local lg=love.graphics
return {
    staticUpdate = function(dt)
        Psys:update(dt)
    end,
    draw = function(ent)
        local h
        if ent.draw then
            h = ent.draw.h/1.3
        else
            h = 0
        end
        lg.draw(Psys, ent.pos.x, (ent.pos.y - h) - ent.pos.z / 2)
    end
}
local atlas = require("assets.atlas")
local Quads = atlas.Quads
local Psys = love.graphics.newParticleSystem(atlas.image,2000)
Psys:setColors({1,0,0}, {0.7,0,0}, {0.7,0,0.4})
Psys:setQuads{ Quads.bat, Quads.bot, Quads.bit }
local _,_, pW, pH = (Psys:getQuads()[1]):getViewport( )
Psys:setOffset(pW/2, pH/2)
Psys:setEmissionRate(150)
Psys:setParticleLifetime(0.1, 0.5)
Psys:setDirection(-math.pi/2)
Psys:setRotation(0, 2*math.pi)
Psys:setRelativeRotation(false)
Psys:setSpeed(30,45)
Psys:setEmissionArea("uniform", 2,0)
local lg=love.graphics
return {
    staticUpdate = function(dt)
        Psys:update(dt)
    end,
    draw = function(ent)
        local h
        if ent.draw then
            h = ent.draw.h/1.3
        else
            h = 0
        end
        lg.draw(Psys, ent.pos.x, (ent.pos.y - h) - ent.pos.z / 2)
    end
}
local PATH = "assets/sounds"
--[[
Loads all SFX and music into a table.
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
The catch:
If a sound file has the string `LONG` in it's name,
it is registered as a sound file that is too long
to be loaded into memory.
(Do this for music files, SFX can be loaded into mem)
`SoundSys` will manage grouping together sounds:
Sounds will be automatically grouped together depending on their
filename.
`main` stands for main sounds,
`bg` stands for background sounds.
(background sounds can vary in volume)
usually the main sounds will be the loudest.
For example:
`boom_main1.ogg`, `boom_main2.ogg`, `boom_bg1.ogg`, `boom_bg2.ogg`.
In this scenario, whenever `boom` is envoked,
either main1 or main2 will play, and BOTH bg (background) sounds will be played.
each soundGroup is represented by this:
exampleSoundGroup {
    mainSounds = { };
    backgroundSounds = { }
}
]]
local newSource = love.audio.newSource
local function sound_TREE_push(PATH, tabl)
    for _,fname in ipairs(love.filesystem.getDirectoryItems(PATH)) do
        if fname:sub(1,1) ~= "_" then
            local proper_name = fname:gsub("%.%w+", "")
            fname = PATH.."/"..fname
            local info = love.filesystem.getInfo(fname)
            if info.type == "directory" then
                sound_TREE_push(fname, tabl)
            else
                if fname:find("LONG") then
                    tabl[proper_name:gsub("LONG", "")] = newSource(fname, "stream")
                else
                    tabl[proper_name] = newSource(fname, "static")
                end
            end
        end
    end
    return tabl
end
local sounds = {  }
sound_TREE_push(PATH, sounds)
return sounds
local Camera = require("libs.NM_STALKER_X.Camera")
local cam =  Camera(0,0, nil,nil, 2, -- scale 
                    0)  -- rotation
cam:setFollowLerp(0.05)
cam:setFollowLead(10)
return cam
local font = love.graphics.newImageFont("assets/font2.png", ' ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789><    ')
love.graphics.setFont(font)
return font
local moonshine = require("libs.NM_moonshine")
local cyan = _G.Cyan
local gamestate = { }
local n = 0
local n2 = 0
function gamestate.update(dt)
    -- paused is for DEBUG ONLY!!
    if CONSTANTS.paused then
        return
    end
    dt = math.min(dt, CONSTANTS.MAX_DT)
    cyan.call("update",dt)
    if n > 60 then
        n = 0
        cyan.call("heavyupdate", dt)
    end
    if n2 > 2 then
        cyan.call("sparseupdate", dt) -- Is called once every 4 frames
        n2 = 0
    end
    n2 = n2 + 1
    n = n + 1
end
function gamestate.draw( )
    cyan.call("draw")
end
function gamestate.keypressed(a,b,c)
    cyan.call("keypressed", a,b,c)
end
function gamestate.keyreleased(a,b)
    cyan.call("keyreleased", a,b)
end
function gamestate.wheelmoved(x,y)
    cyan.call("wheelmoved", x, y)
end
function gamestate.mousemoved(x,y,dx,dy)
    cyan.call("mousemoved", x,y,dx,dy)
end
function gamestate.mousepressed(x,y, button, istouch, presses)
    cyan.call("mousepressed", x,y, button, istouch, presses)
end
function gamestate.quit()
    cyan.call("quit")
    return false --Yes, we should indeed quit
end
for k,v in pairs(gamestate) do
    _G.love[k] = v
end
--[[
Spacial partitions exclusively for targettable entities.
Although un-elegant, these structures bring down the AI time complexity by a lot
The system in charge of running this is `TargetSys`,
inside the file `MoveBehaviourSys.lua`.
]]
local MAX_VEL = CONSTANTS.MAX_VEL
--[[
Target groups: 
-- "player" :: player / ally
-- "enemy" :: enemy
-- "neutral" :: neutral / weak mob
-- "physics" :: physics object
-- "coin"    :: coin
-- "interact" :: shop, portal, artefact
]]
local Partitions = {}
for _, val in ipairs(CONSTANTS.TARGET_GROUPS) do
    Partitions[val] = require("libs.spatial_partition.partition")(MAX_VEL * CONSTANTS.MAX_DT, MAX_VEL * CONSTANTS.MAX_DT)
end
return Partitions
local partition = require("src.misc.partition")
local ccall = Cyan.call
local rand = love.math.random
local BUF_TIME = 0.35 -- wait BUF_TIME seconds then spawn new world
local genLevel = function(e)
    local dest = e.portalDestination or error("No portal destination given")
    ccall("switchWorld", {
        x = dest.x;
        y = dest.y;
        type = dest.type;
        tier = dest.tier
    })
end
local function regularShockwave(x,y, col)
    ccall("shockwave", x, y, 210, 40, 9, 0.4, col)
end
return function(portal, player)
    --[[
        creates new level with feedback
    ]]
    local R = 3
    player.hidden = true
    ccall("sound", "boom")
    ccall("sound", "teleport",0.4)
    ccall("animate", "tp_up", 0,0,0, BUF_TIME/10, 1, nil, player, true)
    -- TOOD: play a sound here
    for i=0, R-2 do
        ccall("await", regularShockwave, (i-1)*(BUF_TIME/R),
                portal.pos.x, portal.pos.y - portal.pos.z/2, {0.05,0.3,0.3})
    end
    ccall("await", genLevel, BUF_TIME+0.05, portal) -- wait  seconds
end
local json = require("libs.NM_json.json")
local FNAME = CONSTANTS.SAVE_DATA_FNAME
if not love.filesystem.getInfo(FNAME) then
    local file, err = love.filesystem.newFile(FNAME, "w")
    if not file then
        error(err)
    end
    file:write(
        "{}" -- Nothing, dataSys should take care of this
    )
    file:close()
end
local fdat, err
fdat, err = love.filesystem.read(FNAME)
if not fdat then
    error(err)
end
local savedata = json.decode(fdat)
return savedata
// main shader ==>
// lights
uniform vec4 light_colours[20]; // max 20 lights at once
uniform vec2 light_positions[20];
uniform int  light_distances[20]; // this distance a light can be bright
uniform int  num_lights;
uniform float max_light_strength; // the max light strength (good number is like 0.2 or something)
uniform vec4 base_lighting; // base_lighting will be something like <0.7, 0.7, 0.7>
uniform float brightness_modifier;
// noise
uniform float amount;
uniform float period;
//  colourblindness mode
uniform bool colourblind;
uniform bool devilblind;
uniform bool navyblind;
// thanks to stackoverflow.com/users/350875/appas for this function!
// very good pseudorandom generator
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // Lighting :::
    vec4 light_mod = base_lighting;
    //vec2 middle_of_screen = love_ScreenSize.xy/2;
    vec4 adding_light;
    for(int i=0; i<num_lights; i++){
        //adding_light = vec4(0,0,0,1);
        float dist_to_light = length(screen_coords - light_positions[i]);
        //if (dist_to_light < light_distances[i]){
        adding_light = ((light_colours[i]*light_distances[i]))
                        / (sqrt(dist_to_light) * brightness_modifier);
        // Cap the light brightness so it cannot be too bright
        adding_light.x = max(min(max_light_strength, adding_light.x), -max_light_strength);
        adding_light.y = max(min(max_light_strength, adding_light.y), -max_light_strength);;
        adding_light.z = max(min(max_light_strength, adding_light.z), -max_light_strength);;
        //}
        light_mod += adding_light;
    }
    light_mod.w = 1;
    // filmgrain :::
    vec2 sc;
    sc.x = screen_coords.x;
    sc.y = screen_coords.y;
    sc.x = floor(sc.x/period);
    sc.y = floor(sc.y/period);
    float r = 0.9 + amount * rand(sc);
    float g = 0.9 + amount * rand(sc + 91);
    float b = 0.9 + amount * rand(sc + 213);
    // ORIGINAL ::
    // float am = 0.9 + amount * rand(sc);
    //color = Texel(texture, tc);
    //return  (color*am);
    vec4 colour = Texel(texture, texture_coords);
    for (int n=0;n<4;n++){
        light_mod[n] = min(1, light_mod[n]);
    }
    color[0] *= r;
    color[1] *= g;
    color[2] *= b;
    vec4 final;
    final = colour * color * light_mod; // originally  colour * color * light_mod
    if (colourblind){
        // switch blue and green
        float b_temp;
        b_temp = final[2];
        final[2] = final[1];
        final[1] = b_temp;
    }
    if (devilblind){
        // switch red and green! oooo
        float r_temp;
        r_temp = final[0];
        final[0] = final[1];
        final[1] = r_temp;
    }
    if (navyblind){
        // switch blue and red
        float n_temp;
        n_temp = final[2];
        final[2] = final[0];
        final[0] = n_temp;
    }
    final.xyz = max(final.xyz, vec3(.12));
    return final;
}
local moonshine = require("libs.NM_moonshine")
--[[
-- old code
local effect = moonshine(moonshine.effects.noise)
return effect
]]
local pth = "src/misc/unique/shader.glsl"
local code,e = love.filesystem.read(pth)
assert(code, e)
return love.graphics.newShader(code)
// main shader ==>
// lights
uniform vec4 light_colours[20]; // max 20 lights at once
uniform vec2 light_positions[20];
uniform int  light_distances[20]; // this distance a light can be bright
uniform int  num_lights;
uniform float max_light_strength; // the max light strength (good number is like 0.2 or something)
uniform vec4 base_lighting; // base_lighting will be something like <0.7, 0.7, 0.7>
uniform float brightness_modifier;
// noise
uniform float amount;
uniform float period;
//  colourblindness mode
uniform bool colourblind;
uniform bool devilblind;
uniform bool navyblind;
// thanks to stackoverflow.com/users/350875/appas for this function!
// very good pseudorandom generator
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}
vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // Lighting :::
    vec4 light_mod = base_lighting;
    //vec2 middle_of_screen = love_ScreenSize.xy/2;
    vec4 adding_light;
    for(int i=0; i<num_lights; i++){
        //adding_light = vec4(0,0,0,1);
        float dist_to_light = length(screen_coords - light_positions[i]);
        //if (dist_to_light < light_distances[i]){
        adding_light = ((light_colours[i]*light_distances[i]))
                        / (sqrt(dist_to_light) * brightness_modifier);
        // Cap the light brightness so it cannot be too bright
        adding_light.x = max(min(max_light_strength, adding_light.x), -max_light_strength);
        adding_light.y = max(min(max_light_strength, adding_light.y), -max_light_strength);;
        adding_light.z = max(min(max_light_strength, adding_light.z), -max_light_strength);;
        //}
        light_mod += adding_light;
    }
    light_mod.w = 1;
    // filmgrain :::
    vec2 sc;
    sc.x = screen_coords.x;
    sc.y = screen_coords.y;
    sc.x = floor(sc.x/period);
    sc.y = floor(sc.y/period);
    float r = 0.9 + amount * rand(sc);
    float g = 0.9 + amount * rand(sc + 91);
    float b = 0.9 + amount * rand(sc + 213);
    // ORIGINAL ::
    // float am = 0.9 + amount * rand(sc);
    //color = Texel(texture, tc);
    //return  (color*am);
    vec4 colour = Texel(texture, texture_coords);
    for (int n=0;n<4;n++){
        light_mod[n] = min(1, light_mod[n]);
    }
    color[0] *= r;
    color[1] *= g;
    color[2] *= b;
    vec4 final;
    final = colour * color * light_mod; // originally  colour * color * light_mod
    if (colourblind){
        // switch blue and green
        float b_temp;
        b_temp = final[2];
        final[2] = final[1];
        final[1] = b_temp;
    }
    if (devilblind){
        // switch red and green! oooo
        float r_temp;
        r_temp = final[0];
        final[0] = final[1];
        final[1] = r_temp;
    }
    if (navyblind){
        float n_temp;
        n_temp = final[2];
        final[2] = final[0];
        final[0] = n_temp;
    }
    return final;
}
local ShockWave = {
    --[[
Shockwave objects represented as a class, with :new and :update
and :draw methods.
    ]]
}
local mt = {__index = ShockWave}
function ShockWave.new( x, y, start_rad, end_rad, thickness, time, colour )
    local sw = setmetatable({
        x = x, y = y,
        thickness = thickness,
        rad = start_rad,
        colour = colour,
        start_rad = start_rad,
        end_rad = end_rad
    }, mt)
    sw.d_rad = (end_rad - start_rad) / time
    return sw
end
function ShockWave:update(dt)
    self.rad = self.rad + (self.d_rad * dt)
    local opacity = 1-(self.rad-self.start_rad)/(self.end_rad-self.start_rad)
    self.colour[4] = opacity
    if self.d_rad < 0 then
        -- then the radius is running backwards
        if self.rad < self.end_rad then
            self.isFinished = true
        end
    else
        if self.rad > self.end_rad then
            self.isFinished = true
        end
    end
end
local setLineWidth = love.graphics.setLineWidth
local c = love.graphics.circle
local setColour = love.graphics.setColor
function ShockWave:draw()
    setColour(self.colour)
    setLineWidth(self.thickness)
    c("line", self.x, self.y, self.rad)    
end
return ShockWave.new
(macro ENT [e x y quads s_expr1 ...]
    `(fn [,x ,y]
        (local ,e (Cyan.Entity))
        (local ,quads (require "libs.assets.atlas").Quads)
        (do
            ,s_expr1
            ,...)
        ,e))
--[[
"Exclusion zone tables" are set up to ensure
ents don't spawn too closely to each other.
For example, we can set up an exclusion table to ensure enemies
don't spawn around ["E"] spawn locations:
see example:
exclusionZones = {
    ["E"] = {
        ["e"] = 1, -- exclusion radius 1
        ["u"] = 1, -- exclusion radius 1
        ["E"] = 3 -- exclusion radius 3.
    };
    -- Likewise, we can ensure large structures don't spawn
    -- next to each other:
    ["l"] = {
        ["l"] = 1
    }
}
(please note that player spawn, walls, player exit, shop, etc are done 
such that exclusion zones should not need to be used for those spawns)
]]
return {
    e={
        e=1;
        r=1;
        u=1;
    };
    E={
        E=3;
        e=1;
        r=1;
        u=1
    };
    u={
        E=1;
        e=1;
        r=1;
        u=1
    };
    p={
        p=1
    };
    q={
        q=2
    };
    l={
        l=1
    };
}
local s = [[
##################..............
#...l..p.^^..^..^#...........l..
#^l.pp...p..^..^.#....l.........
#..^...p......^p.#..........l...
#..p....^l..^..^^#..l...........
#...p.l^^^pp.^l..#....l.........
#..l.^p^p^p^....^#..l..l.l......
#.....^pp^p.^.^..#.l..^l.....l..
#l.^lp^..&...^.l.#..l.l.l.^.....
#..^.lp.....^^..^#.^l..^.l..^...
#.pl...^.^^^.^^.^#.ll.^...^.^...
#.p.^p^..t....L..###############
#..l^....3.......#.............#
#^..l^^.........^#..^.^.^.^.^..#
#.l..^^..2..^.^.^#.....^.^..^..#
#.^^.p^....^.^^p.#..^...X......#
########.1.#######.....^^^.....#
...l.ll#.@.#l^^l.#.p.^^....^.^.#
..l.^l.#.^^#.ll^l#......^...^..#
...lll.#####l^.l.###############
......^l^.^^.l..................
]]
local k = {}
for line in s:gmatch("[^\n]+") do
    local n = {}
    for i=1,line:len() do
        table.insert(n, line:sub(i,i))
    end
    table.insert(k,n)
end
return k
local default_T1 = {
    id = "default_T1",
    tries = 20, -- If a structure is generated > `tries` times and still does not
            -- fit, do not generate this structure.
            -- The lower this is, the faster worlds will be generated.
    min_structures = 30, -- number of structures will be within this range.
    max_structures = 40,
    -- Note that after the number of structures has been chosen,
    -- These are the required structures. (e.g. player spawn, etc)
    required = {
        [{
             {"???",
              "???",
              "???"}
             ,  
             {"^^^",
              "^@^",
              "^^^"}
        }] = 1
    },
    structures = {
    [  -- Small room structure with coin inside,
    --  guarded by 'e'.
        {
            {"?????",
            "?????",
            "?????",
            "?????",
            "?????"}
            ,
            {"?????",
            "?#e#?",
            "?#c#?",
            "?###?",
            "?????"}
        }
    ] = 0.05 -- weight of being chosen out of all structures
    ,
    [
        {  -- Large object surrounded by small objects
            {"???",
            "???",
            "???"}
            ,
            {"^p^",
            "plp",
            "^p^"}
        }
    ] = 0.04
    ,
    [  -- Decoration field with physics objects in center
        {
            {"? ? ? ? ? ? ?",
            "? ? ? ? ? ? ?",
            "? ? ? ? ? ? ?",
            "? ? ? ? ? ? ?",
            "? ? ? ? ? ? ?",
            "? ? ? ? ? ? ?",
            "? ? ? ? ? ? ?"}
            ,
            {"^ ^ ^ ^ ^ ^ ^",
            "^ l ^ ^ ^ l ^",
            "^ ^ ^ p ^ ^ ^",
            "^ ^ p p p ^ ^",
            "^ ^ ^ p ^ ^ ^",
            "^ l ^ ^ ^ l ^",
            "^ ^ ^ ^ ^ ^ ^"}
        }
    ] = 0.3
    ,
    [  -- Open room filled with unique enemies
        {
            {"???????",
            "???????",
            "???????",
            "???????",
            "???????",
            "???????",
            "???????"}
            ,
            {"^^.^^.^",
            "^#####^",
            ".#^^.#^",
            "^^.U^^^",
            "^#^^^#^",
            "p#####.",
            "^p^..^p"}
        }
    ] = 0.1
    ,
    [  -- Closed room with random (non-walled) interior 1
        {
            {"???????",
            "???????",
            "???????",
            "???????",
            "???????",
            "???????",
            "???????"}
            ,
            {"? ? ? ? ? ? ?",
            "? # # # # # ?",
            "? # . ? . # ?",
            "? . ? ? ? # ?",
            "? # . ? . # ?",
            "? # # # # # ?",
            "? ? ? ? ? ? ?"}
        }
    ] = 0.1
    ,
    [--  Closed room with random (non-walled) interior 2
        {
            {"???????",
            "???????",
            "???????",
            "???????",
            "???????",
            "???????",
            "???????"}
            ,
            {"? ? ? ? ? ? ?",
            "? # # # # # ?",
            "? # . ? . # ?",
            "? # ? ? ? . ?",
            "? # . ? . # ?",
            "? # # # # # ?",
            "? ? ? ? ? ? ?"}
        }
    ] = 0.1
    ,
    [
        { --  Closed room with random (non-walled) interior 3
            {"???????",
            "???????",
            "???????",
            "???????",
            "???????",
            "???????",
            "???????"}
            ,
            {"? ? ? ? ? ? ?",
            "? # # # # # ?",
            "? # . ? . # ?",
            "? # ? ? ? # ?",
            "? # . ? . # ?",
            "? # # . # # ?",
            "? ? ? ? ? ? ?"}
        }
    ] = 0.1
    ,
    [
        { --  Closed room with random (non-walled) interior 4
            {"???????",
            "???????",
            "???????",
            "???????",
            "???????",
            "???????",
            "???????"},
            {"? ? ? ? ? ? ?",
            "? # # . # # ?",
            "? # . ? . # ?",
            "? # ? ? ? # ?",
            "? # . ? . # ?",
            "? # # # # # ?",
            "? ? ? ? ? ? ?"}
        }
    ] = 0.1
    ,
    [
        {
            {"????",
             "????",
             "????",
             "????"},
             {"????",
              "??l?",
              "?l??",
              "????"}
        }
    ] = 0.1
}
}
-- Higher Tier worlds will have things like Bossfights, artefacts etc.
return default_T1
local weighted_selection = _G.Tools.weighted_selection
local PATH = Tools.Path(...):gsub("%.","%/")
local StructureGenRules = {}
do
    local function req_TREE(PATH)
        for _,fname in ipairs(love.filesystem.getDirectoryItems(PATH)) do
            if fname:sub(1,1) ~= "_" then
                fname = PATH.."/"..fname
                local info = love.filesystem.getInfo(fname)
                if info.type == "directory" then
                    req_TREE(fname)
                else
                    local structRule = require(fname:gsub("%/","%."):gsub(".lua", ""))
                    assert(structRule, "StructRule file empty or did not return")
                    assert(structRule.id, "StructRule not given an id")
                    assert(not (StructureGenRules[structRule.id]),
                    "Attempt to overwrite structureRule. Ensure structureRules have different `id`s.")
                    StructureGenRules[structRule.id] = structRule
                end
            end
        end
    end
    req_TREE(PATH)
end
for _, structRule in pairs(StructureGenRules) do
    -- Creates a random selection function from the ruleset.
    structRule.random = weighted_selection(
        structRule.structures
    )
    for structure, _ in pairs(structRule.structures) do
        for n=1,2 do
            for i, str in ipairs(structure[n]) do
                structure[n][i] = str:gsub(" ","")
            end
        end
    end
end
--[[
Table encoded as :::
{
    id1 = <structRule>
    id2 = <structRule>
    id3 = <structRule>
    etc
}
]]
return StructureGenRules
--[[
world construction helper functions
(similar to EH.)
]]
local WH = setmetatable({},{__index=error})
local LIGHT_PLACEMENT_OFFSET = 200
local LIGHT_PLACEMENT_R_AMPLITUDE = 300
local rand = love.math.random
function WH.lights(world, worldMap, num_lights, light_distance)
    local size_x = world.x * 64
    local size_y = world.y * 64
    print("Sizes:" , size_x, size_y)
    assert(num_lights, "expected a number of lights")
    local ct =  math.ceil(math.sqrt(num_lights))
    for x = 1, ct do
        for y = 1, ct do
            local properwidth = size_x - (LIGHT_PLACEMENT_OFFSET*2)
            local properheight = size_y - (LIGHT_PLACEMENT_OFFSET*2)
            local x = (properwidth) * (x / ct) + LIGHT_PLACEMENT_OFFSET --+ (rand()-0.5)*2*LIGHT_PLACEMENT_R_AMPLITUDE
            local y = (properheight) * (y / ct) + LIGHT_PLACEMENT_OFFSET --+ (rand()-0.5)*2*LIGHT_PLACEMENT_R_AMPLITUDE
            local light = EH.Ents.light(x,y)
            light.distance = light_distance
        end
    end
end
function WH.zonenum(tier, px, py)
    local txt = "zone " .. math.roman(tier)
    ccall("spawnText", px, py - 60, txt, 600, 10)
end
return WH
--[[
TYPE :: 'basic'
tier :: T1 :: 1
]]
--[[
World map will be encoded by a 2d array of characters.
Capital version of any character stands for "spawn multiple."
.  :  nothing (empty space)
#  :  wall
e  :  enemy spawn
r  :  rare enemy spawn
u  :  unique enemy spawn (i.e. crowd control enemy, enemies that are bad solo)
n  :  neutral mob spawn
!  :  Bossfight
$  :  shop (add this at the end)
c  :  coin (add this at the end)
@  :  player spawn
&  :  exit level / next level
p  :  physics object
q :  spiky physics object (damages player upon hit)
^  :  decoration area (grass, nice ground texture, etc)
l  :  large immovable structure (basically a solo wall, ie a pillar, tree, giant mushroom)
*  :  collectable artefact / trophy!!
(NYI:)
In order to spawn entities, the worldGen will pick a random
constructor function from the respective char table.
That constructor function will then be called and an
entity will be placed.
]]
local Ents = require("src.entities")
local rand = love.math.random
local enemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.enemy]    = 0.5;
    [Ents.boxenemy] = 0.3;
    [Ents.blob]     = 0.3;
    [Ents.boxblob]  = 0.3;
    [Ents.ghost]    = 0.1
}
local bigEnemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [function(x,y)
        for i=-1,0 do
            Ents.devil(x+(i*15), y+(i*15))
        end
    end] = 0.5
}
local purge_fn = function(e, cam_x, cam_y)
    -- called at end of level to clear enemies and walls.
    -- (Passed in as a param to `ccall(apply, .)`  ).
    if (e.targetID ~= "player")
    and (Tools.dist(cam_x-e.pos.x,cam_y-e.pos.y) < 160) then
        ccall("damage",e,0xffff)
    end
end
local function spawn_portal(x, y)
    local portal = EH.Ents.portal(x, y)
    portal.portalDestination = {
        x = 30;
        y = 30;
        tier = 2;
        type="basic"
    }
end
local WH = require("src.misc.worldGen.WH")
return {
    construct = function(wor,wmap, px, py)
        WH.zonenum(1, px,py)
        WH.lights(wor, wmap, 15, 10)
    end;
    type = 'basic',
    tier = 1,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.
    PROBS = {
            -- World generation:
            -- Probability of each character occuring.
            -- Each value is a weight and does not actually represent the probability.
            -- see `GenerationSys` for what character represents what.
            ["^"] = 0.8;
            ["l"] = 0.12;
            ["p"] = 0.3;
            ["P"] = 0.01;
            ["."] = 0.4
            -- Bossfights, artefacts, are done through special structure generator
            -- Walls, shops, player spawn, and player exit are done uniquely.
    }, -- Can modify the char probabilities by setting
                        -- this to a table. 
    enemies = {
        n = 30;
        n_var = 1;
        bign = 1;
        bign_var = 0
    };
    ratioWin = function(cam_x, cam_y)
        ccall("apply", purge_fn, cam_x, cam_y)
        ccall("await", spawn_portal, 1.5, cam_x, cam_y)
        --[[
        TODO:
        play sounds and stuff here. Like, a gong would be cool.
        have a shockwave also, that would be cool
        ]]
    end;
    entities = {
    ["e"] = {
        max = 200;
        function(x,y)
            for i=0, 1+rand(1,2) do
                local f = enemySpawns()
                f(x+(i-1)*10 + (rand()-.5)*20, y+(i-1)*10 + (rand()-.5)*20)
            end
        end
    };
    ["E"] = {
        max = 10;
        function(x,y)
            bigEnemySpawns()(x,y)
        end
    };
    ["p"] = {
        max = 300,
        function(x, y)
            for i = 1, rand(1,3) do
                Ents.block(
                    x + rand(-10, 10),
                    y + rand(-10, 10)
                )
            end
        end
    };
    ["P"] = {
        max = 3, 
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, rand(3,6) do
                block_ctor(
                    x + rand(-32, 32),
                    y + rand(-32, 32)
                )
            end
        end
    };
    ['^'] = {
        max = 0xFFFFFFF;
        function(x,y)
            local grass = Ents.grass
            for i=1, rand(8,9) do
                grass(x + rand(-50, 50), y + rand(-50, 50))
            end
        end
    };
    ['l'] = {
        max = 100;
        function (x, y)
            if rand()<0.5 then
                Ents.mushroom(x+(rand()-.5)*40,y+(rand()-.5)*40)
            else
                Ents.pine(x+(rand()-.5)*40,y+(rand()-.5)*40)
            end
        end
    }
}
}
--[[
TYPE :: 'basic'
tier :: T2 :: 2
]]
--[[
World map will be encoded by a 2d array of characters.
Capital version of any character stands for "spawn multiple."
.  :  nothing (empty space)
#  :  wall
e  :  enemy spawn
r  :  rare enemy spawn
u  :  unique enemy spawn (i.e. crowd control enemy, enemies that are bad solo)
n  :  neutral mob spawn
!  :  Bossfight
$  :  shop (add this at the end)
c  :  coin (add this at the end)
@  :  player spawn
&  :  exit level / next level
p  :  physics object
q :  spiky physics object (damages player upon hit)
^  :  decoration area (grass, nice ground texture, etc)
l  :  large immovable structure (basically a solo wall, ie a pillar, tree, giant mushroom)
*  :  collectable artefact / trophy!!
(NYI:)
In order to spawn entities, the worldGen will pick a random
constructor function from the respective char table.
That constructor function will then be called and an
entity will be placed.
]]
local Ents = require("src.entities")
local WH=require("src.misc.worldGen.WH")
local rand = love.math.random
local enemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.devil]    = 0.1;
    [Ents.enemy]    = 0.3;
    [Ents.mallow]   = 0.4;
    [Ents.cmallow]  = 0.1;
    [Ents.boxenemy] = 0.2;
    [Ents.blob]     = 0.15;
    [Ents.boxblob]  = 0.2
}
local bigEnemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.bully] = 1
}
local purge_fn = function(e, cam_x, cam_y)
    -- called at end of level to clear enemies and walls.
    -- (Passed in as a param to `ccall(apply, .)`  ).
    if (e.targetID ~= "player")
    and (Tools.dist(cam_x-e.pos.x,cam_y-e.pos.y) < 160) then
        ccall("damage",e,0xffff)
    end
end
local function spawn_portal(x, y)
    local portal = EH.Ents.portal(x, y)
    portal.portalDestination = {
        x = 30;
        y = 30;
        tier = 3;
        type="basic"
    }
end
return {
    type = 'basic',
    tier = 2,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.
    construct = function(wor,wmap, px, py)
        WH.zonenum(2, px,py)
        WH.lights(wor, wmap, 15, 10)
    end;
    PROBS = {
            -- World generation:
            -- Probability of each character occuring.
            -- Each value is a weight and does not actually represent the probability.
            -- see `GenerationSys` for what character represents what.
            ["e"] = 0.4;
            ["E"] = 0.005;
            ["r"] = 0.02; -- 0.02 weight chance of spawning on random tile.
            ["R"] = 0.005;
            ["u"] = 0.01;
            ["U"] = 0.003;
            ["^"] = 0.8;
            ["l"] = 0.12;
            ["p"] = 0.3;
            ["P"] = 0.01;
            ["."] = 0.4
            -- Bossfights, artefacts, are done through special structure generator
            -- Walls, shops, player spawn, and player exit are done uniquely.
    }, -- Can modify the character probabilities by setting
                        -- this to a table. 
    entExclusionZones = nil, -- Can modify this table also.
                            -- See `defaultEntExclusionZones.lua`.
    enemies = {
        n = 20;
        bign = 3
    };
    ratioWin = function(cam_x, cam_y)
        ccall("apply", purge_fn, cam_x, cam_y)
        ccall("await", spawn_portal, 1.5, cam_x, cam_y)
        --[[
        TODO:
        play sounds and stuff here. Like, a gong would be cool.
        have a shockwave also, that would be cool
        ]]
    end;
    entities = {
    ["e"] = {
        max = 200;
        function(x,y)
            EH.Ents.light(x,y)
            for i=-1,rand(1,2) do
                local f = enemySpawns()
                f(x+(i-1)*40, y+(i-1)*40)
            end
        end
    };
    ["E"] = {
        max = 6;
        function(x,y)
            bigEnemySpawns()(x,y)
        end
    };
    ["p"] = {
        max = 300, -- 60 max
        function(x, y)
            for i = 1, rand(1,3) do
                Ents.block(
                    x + rand(-10, 10),
                    y + rand(-10, 10)
                )
            end
        end
    };
    ["P"] = {
        max = 3, -- Max spawns :: 3
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, rand(3,6) do
                block_ctor(
                    x + rand(-32, 32),
                    y + rand(-32, 32)
                )
            end
        end
    };
    ['^'] = {
        max = 0xFFFFFFF;
        function(x,y)
            local grass = Ents.grass
            for i=1, rand(8,9) do
                grass(x + rand(-50, 50), y + rand(-50, 50))
            end
        end
    };
    ['l'] = {
        max = 100;
        function (x, y)
            if rand()<0.5 then
                Ents.mushroom(x+rand()*5,y+rand()*5)            
            else
                Ents.pine(x+rand()*5,y+rand()*5)
            end
        end
    }
}
}
--[[
TYPE :: 'basic'
tier :: T3 :: 3
]]
--[[
World map will be encoded by a 2d array of characters.
Capital version of any character stands for "spawn multiple."
.  :  nothing (empty space)
#  :  wall
e  :  enemy spawn
r  :  rare enemy spawn
u  :  unique enemy spawn (i.e. crowd control enemy, enemies that are bad solo)
n  :  neutral mob spawn
!  :  Bossfight
$  :  shop (add this at the end)
c  :  coin (add this at the end)
@  :  player spawn
&  :  exit level / next level
p  :  physics object
q :  spiky physics object (damages player upon hit)
^  :  decoration area (grass, nice ground texture, etc)
l  :  large immovable structure (basically a solo wall, ie a pillar, tree, giant mushroom)
*  :  collectable artefact / trophy!!
(NYI:)
In order to spawn entities, the worldGen will pick a random
constructor function from the respective char table.
That constructor function will then be called and an
entity will be placed.
]]
local Ents = require("src.entities")
local WH = require("src.misc.worldGen.WH")
local rand = love.math.random
local enemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.devil]     = 0.4;
    [Ents.demon]     = 0.2;
    [Ents.mallow]    = 0.2;
    [Ents.enemy]     = 0.1;
    [Ents.boxenemy]  = 0.5;
    [Ents.splatenemy]= 0.5;
    [Ents.boxblob]   = 0.15;
}
local bigEnemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.boxbully] = 1
}
local purge_fn = function(e, cam_x, cam_y)
    -- called at end of level to clear enemies and walls.
    -- (Passed in as a param to `ccall(apply, .)`  ).
    if (e.targetID ~= "player")
    and (Tools.dist(cam_x-e.pos.x,cam_y-e.pos.y) < 160) then
        ccall("damage",e,0xffff)
    end
end
local function spawn_portal(x, y)
    local portal = EH.Ents.portal(x, y)
    portal.portalDestination = {
        x = 30;
        y = 30;
        tier = 4;
        type="basic"
    }
end
return {
    type = 'basic',
    tier = 3,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.
    construct = function(wor,wmap,px,py)
        WH.zonenum(3,px,py)
        WH.lights(wor, wmap, 15, 10)
    end;
    ratioWin = function(cam_x, cam_y)
        ccall("apply", purge_fn, cam_x, cam_y)
        ccall("await", spawn_portal, 1.5, cam_x, cam_y)
        --[[
        TODO:
        play sounds and stuff here. Like, a gong would be cool. 
        have a shockwave also, that would be cool
        ]]
    end;
    PROBS = {
            -- World generation:
            -- Probability of each character occuring.
            -- Each value is a weight and does not actually represent the probability.
            -- see `GenerationSys` for what character represents what.
            ["e"] = 0.4;
            ["E"] = 0.005;
            ["r"] = 0.02; -- 0.02 weight chance of spawning on random tile.
            ["R"] = 0.005;
            ["u"] = 0.01;
            ["U"] = 0.003;
            ["^"] = 0.8;
            ["l"] = 0.12;
            ["p"] = 0.3;
            ["P"] = 0.01;
            ["."] = 0.4
            -- Bossfights, artefacts, are done through special structure generator
            -- Walls, shops, player spawn, and player exit are done uniquely.
    }, -- Can modify the character probabilities by setting
                        -- this to a table. 
    entExclusionZones = nil, -- Can modify this table also.
                            -- See `defaultEntExclusionZones.lua`.
    enemies = {
        n = 20;
        bign = 2
    };
    entities = {
    ["#"] = { -- For wall entity.
        max = 999999, --No max.
        Ents.wall
    };
    ["e"] = {
        max = 200;
        function(x,y)
            for i=-1,rand(1,2) do
                local f = enemySpawns()
                f(x+(i-1)*40, y+(i-1)*40)
            end
        end
    };
    ["E"] = {
        max = 6;
        function(x,y)
            bigEnemySpawns()(x,y)
        end
    };
    ["p"] = {
        max = 300, -- 60 max
        function(x, y)
            for i = 1, rand(1,3) do
                Ents.block(
                    x + rand(-10, 10),
                    y + rand(-10, 10)
                )
            end
        end
    };
    ["P"] = {
        max = 3, -- Max spawns :: 3
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, rand(3,6) do
                block_ctor(
                    x + rand(-32, 32),
                    y + rand(-32, 32)
                )
            end
        end
    };
    ['^'] = {
        max = 0xFFFFFFF;
        function(x,y)
            local grass = Ents.grass
            for i=1, rand(8,9) do
                grass(x + rand(-50, 50), y + rand(-50, 50))
            end
        end
    };
    ['l'] = {
        max = 100;
        function (x, y)
            if rand()<0.5 then
                Ents.mushroom(x+rand()*5,y+rand()*5)            
            else
                Ents.pine(x+rand()*5,y+rand()*5)
            end
        end
    }
}
}
--[[
TYPE :: 'basic'
tier :: T3 :: 3
]]
--[[
World map will be encoded by a 2d array of characters.
Capital version of any character stands for "spawn multiple."
.  :  nothing (empty space)
#  :  wall
e  :  enemy spawn
r  :  rare enemy spawn
u  :  unique enemy spawn (i.e. crowd control enemy, enemies that are bad solo)
n  :  neutral mob spawn
!  :  Bossfight
$  :  shop (add this at the end)
c  :  coin (add this at the end)
@  :  player spawn
&  :  exit level / next level
p  :  physics object
q :  spiky physics object (damages player upon hit)
^  :  decoration area (grass, nice ground texture, etc)
l  :  large immovable structure (basically a solo wall, ie a pillar, tree, giant mushroom)
*  :  collectable artefact / trophy!!
(NYI:)
In order to spawn entities, the worldGen will pick a random
constructor function from the respective char table.
That constructor function will then be called and an
entity will be placed.
]]
local Ents = require("src.entities")
local WH = require("src.misc.worldGen.WH")
local rand = love.math.random
local enemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.devil]      = 0.1;
    [Ents.demon]      = 0.05;
    [Ents.mallow]     = 0.2;
    [Ents.enemy]      = 0.3;
    [Ents.spookyenemy]= 0.6;
    [Ents.boxenemy]   = 0.2;
    [Ents.boxblob]    = 0.2;
}
local bigEnemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.boxbully] = 1
}
local purge_fn = function(e, cam_x, cam_y)
    -- called at end of level to clear enemies and walls.
    -- (Passed in as a param to `ccall(apply, .)`  ).
    if (e.targetID ~= "player")
    and (Tools.dist(cam_x-e.pos.x,cam_y-e.pos.y) < 160) then
        ccall("damage",e,0xffff)
    end
end
local function spawn_portal(x, y)
    local portal = EH.Ents.portal(x, y)
    portal.portalDestination = {
        x = 30;
        y = 30;
        tier = 5;
        type="basic"
    }
end
return {
    construct = function(wor,wmap,px,py)
        WH.zonenum(4,px,py)
        WH.lights(wor, wmap, 15, 10)
        ccall("setGrassColour", "aqua")
    end;
    destruct = function(  )
        ccall("setGrassColour", "green")
    end;
    ratioWin = function(cam_x, cam_y)
        ccall("apply", purge_fn, cam_x, cam_y)
        ccall("await", spawn_portal, 1.5, cam_x, cam_y)
        --[[
        TODO:
        play sounds and stuff here. Like, a gong would be cool. 
        have a shockwave also, that would be cool
        ]]
    end;
    type = 'basic',
    tier = 4,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.
    PROBS = {
            -- World generation:
            -- Probability of each character occuring.
            -- Each value is a weight and does not actually represent the probability.
            -- see `GenerationSys` for what character represents what.
            ["^"] = 0.8;
            ["l"] = 0.12;
            ["p"] = 0.3;
            ["P"] = 0.01;
            ["."] = 0.4
            -- Bossfights, artefacts, are done through special structure generator
            -- Walls, shops, player spawn, and player exit are done uniquely.
    }, -- Can modify the character probabilities by setting
                        -- this to a table. 
    entExclusionZones = nil, -- Can modify this table also.
                            -- See `defaultEntExclusionZones.lua`.
    enemies = {
        n = 32; n_var = 4;
        bign = 2
    };
    entities = {
    ["#"] = { -- For wall entity.
        max = 999999, --No max.
        Ents.wall
    };
    ["e"] = {
        max = 200;
        function(x,y)
            for i=-1,rand(1,2) do
                local f = enemySpawns()
                f(x+(i-1)*40, y+(i-1)*40)
            end
        end
    };
    ["E"] = {
        max = 6;
        function(x,y)
            bigEnemySpawns()(x,y)
        end
    };
    ["p"] = {
        max = 300, -- 60 max
        function(x, y)
            for i = 1, rand(1,3) do
                Ents.block(
                    x + rand(-10, 10),
                    y + rand(-10, 10)
                )
            end
        end
    };
    ["P"] = {
        max = 3, -- Max spawns :: 3
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, rand(3,6) do
                block_ctor(
                    x + rand(-32, 32),
                    y + rand(-32, 32)
                )
            end
        end
    };
    ['^'] = {
        max = 0xFFFFFFF;
        function(x,y)
            local grass = Ents.purpgrass
            for i=1, rand(8,9) do
                grass(x + rand(-50, 50), y + rand(-50, 50))
            end
        end
    };
    ['l'] = {
        max = 100;
        function (x, y)
            if rand()<0.3 then
                Ents.mushroom(x+rand()*5,y+rand()*5)            
            else
                Ents.blue_mushroom(x+rand()*5,y+rand()*5)
            end
        end
    }
}
}
--[[
TYPE :: 'basic'
tier :: T3 :: 3
]]
--[[
World map will be encoded by a 2d array of characters.
Capital version of any character stands for "spawn multiple."
.  :  nothing (empty space)
#  :  wall
e  :  enemy spawn
r  :  rare enemy spawn
u  :  unique enemy spawn (i.e. crowd control enemy, enemies that are bad solo)
n  :  neutral mob spawn
!  :  Bossfight
$  :  shop (add this at the end)
c  :  coin (add this at the end)
@  :  player spawn
&  :  exit level / next level
p  :  physics object
q :  spiky physics object (damages player upon hit)
^  :  decoration area (grass, nice ground texture, etc)
l  :  large immovable structure (basically a solo wall, ie a pillar, tree, giant mushroom)
*  :  collectable artefact / trophy!!
(NYI:)
In order to spawn entities, the worldGen will pick a random
constructor function from the respective char table.
That constructor function will then be called and an
entity will be placed.
]]
local Ents = require("src.entities")
local WH = require("src.misc.worldGen.WH")
local rand = love.math.random
local enemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.devil]      = 0.1;
    [Ents.demon]      = 0.05;
    [Ents.mallow]     = 0.15;
    [Ents.wizard]     = 0.3;
    [Ents.spookyenemy]= 0.4;
    [Ents.splatenemy] = 0.15;
    [Ents.boxbully]   = 0.15;
    [Ents.boxenemy]   = 0.2;
    [Ents.ghost_squad]= 0.1
}
local bigEnemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.spookybully] = 0.5;
    [Ents.boxbully]    = 0.5
}
local purge_fn = function(e, cam_x, cam_y)
    -- called at end of level to clear enemies and walls.
    -- (Passed in as a param to `ccall(apply, .)`  ).
    if (e.targetID ~= "player")
    and (Tools.dist(cam_x-e.pos.x,cam_y-e.pos.y) < 160) then
        ccall("damage",e,0xffff)
    end
end
local function spawn_portal(x, y)
    local portal = EH.Ents.portal(x, y)
    portal.portalDestination = {
        x = 30;
        y = 30;
        tier = 6;
        type="basic"
    }
end
return {
    construct = function(wor,wmap,px,py)
        WH.zonenum(5,px,py)
        WH.lights(wor, wmap, 15, 10)
        ccall("setGrassColour", "aqua")
    end;
    destruct = function(  )
        ccall("setGrassColour", "green")
    end;
    ratioWin = function(cam_x, cam_y)
        ccall("apply", purge_fn, cam_x, cam_y)
        ccall("await", spawn_portal, 1.5, cam_x, cam_y)
        --[[
        TODO:
        play sounds and stuff here. Like, a gong would be cool. 
        have a shockwave also, that would be cool
        ]]
    end;
    type = 'basic',
    tier = 5,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.
    PROBS = {
            -- World generation:
            -- Probability of each character occuring.
            -- Each value is a weight and does not actually represent the probability.
            -- see `GenerationSys` for what character represents what.
            ["^"] = 0.8;
            ["l"] = 0.12;
            ["p"] = 0.3;
            ["P"] = 0.01;
            ["."] = 0.4
            -- Bossfights, artefacts, are done through special structure generator
            -- Walls, shops, player spawn, and player exit are done uniquely.
    }, -- Can modify the character probabilities by setting
                        -- this to a table. 
    entExclusionZones = nil, -- Can modify this table also.
                            -- See `defaultEntExclusionZones.lua`.
    enemies = {
        n = 30;
        bign = 3
    };
    entities = {
    ["#"] = { -- For wall entity.
        max = 999999, --No max.
        Ents.wall
    };
    ["e"] = {
        max = 200;
        function(x,y)
            for i=-1,rand(1,2) do
                local f = enemySpawns()
                f(x+(i-1)*40, y+(i-1)*40)
            end
        end
    };
    ["E"] = {
        max = 6;
        function(x,y)
            bigEnemySpawns()(x,y)
        end
    };
    ["p"] = {
        max = 300, -- 60 max
        function(x, y)
            for i = 1, rand(1,3) do
                Ents.block(
                    x + rand(-10, 10),
                    y + rand(-10, 10)
                )
            end
        end
    };
    ["P"] = {
        max = 3, -- Max spawns :: 3
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, rand(3,6) do
                block_ctor(
                    x + rand(-32, 32),
                    y + rand(-32, 32)
                )
            end
        end
    };
    ['^'] = {
        max = 0xFFFFFFF;
        function(x,y)
            local grass = Ents.purpgrass
            for i=1, rand(8,9) do
                grass(x + rand(-50, 50), y + rand(-50, 50))
            end
        end
    };
    ['l'] = {
        max = 100;
        function (x, y)
            if rand()<0.3 then
                Ents.mushroom(x+rand()*5,y+rand()*5)            
            else
                Ents.blue_mushroom(x+rand()*5,y+rand()*5)
            end
        end
    }
}
}
--[[
TYPE :: 'basic'
tier :: T3 :: 3
]]
--[[
World map will be encoded by a 2d array of characters.
Capital version of any character stands for "spawn multiple."
.  :  nothing (empty space)
#  :  wall
e  :  enemy spawn
r  :  rare enemy spawn
u  :  unique enemy spawn (i.e. crowd control enemy, enemies that are bad solo)
n  :  neutral mob spawn
!  :  Bossfight
$  :  shop (add this at the end)
c  :  coin (add this at the end)
@  :  player spawn
&  :  exit level / next level
p  :  physics object
q :  spiky physics object (damages player upon hit)
^  :  decoration area (grass, nice ground texture, etc)
l  :  large immovable structure (basically a solo wall, ie a pillar, tree, giant mushroom)
*  :  collectable artefact / trophy!!
(NYI:)
In order to spawn entities, the worldGen will pick a random
constructor function from the respective char table.
That constructor function will then be called and an
entity will be placed.
]]
local Ents = require("src.entities")
local WH = require("src.misc.worldGen.WH")
local rand = love.math.random
local enemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.devil]      = 0.1;
    [Ents.demon]      = 0.05;
    [Ents.mallow]     = 0.15;
    [Ents.wizard]     = 0.3;
    [Ents.spookyenemy]= 0.4;
    [Ents.splatenemy] = 0.15;
    [Ents.boxbully]   = 0.15;
    [Ents.boxenemy]   = 0.2;
    [Ents.ghost_squad]= 0.05;
    [Ents.boxsplitter]= 0.05
}
local bigEnemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.spookybully] = 0.5;
    [Ents.boxbully]    = 0.5
}
local purge_fn = function(e, cam_x, cam_y)
    -- called at end of level to clear enemies and walls.
    -- (Passed in as a param to `ccall(apply, .)`  ).
    if (e.targetID ~= "player")
    and (Tools.dist(cam_x-e.pos.x,cam_y-e.pos.y) < 160) then
        ccall("damage",e,0xffff)
    end
end
local function spawn_portal(x, y)
    local portal = EH.Ents.portal(x, y)
    portal.portalDestination = {
        x = 30;
        y = 30;
        tier = 7;
        type="basic"
    }
end
return {
    construct = function(wor,wmap,px,py)
        WH.zonenum(6, px,py)
        WH.lights(wor, wmap, 15, 10)
        ccall("setGrassColour", "yellow")
    end;
    destruct = function(  )
        ccall("setGrassColour", "green")
    end;
    ratioWin = function(cam_x, cam_y)
        ccall("apply", purge_fn, cam_x, cam_y)
        ccall("await", spawn_portal, 1.5, cam_x, cam_y)
        --[[
        TODO:
        play sounds and stuff here. Like, a gong would be cool. 
        have a shockwave also, that would be cool
        ]]
    end;
    type = 'basic',
    tier = 6,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.
    PROBS = {
            -- World generation:
            -- Probability of each character occuring.
            -- Each value is a weight and does not actually represent the probability.
            -- see `GenerationSys` for what character represents what.
            ["^"] = 0.8;
            ["l"] = 0.12;
            ["p"] = 0.3;
            ["P"] = 0.01;
            ["."] = 0.4
            -- Bossfights, artefacts, are done through special structure generator
            -- Walls, shops, player spawn, and player exit are done uniquely.
    }, -- Can modify the character probabilities by setting
                        -- this to a table. 
    entExclusionZones = nil, -- Can modify this table also.
                            -- See `defaultEntExclusionZones.lua`.
    enemies = {
        n = 24;
        bign = 3
    };
    entities = {
    ["#"] = { -- For wall entity.
        max = 999999, --No max.
        Ents.wall
    };
    ["e"] = {
        max = 200;
        function(x,y)
            for i=-1,rand(1,2) do
                local f = enemySpawns()
                f(x+(i-1)*40, y+(i-1)*40)
            end
        end
    };
    ["E"] = {
        max = 6;
        function(x,y)
            bigEnemySpawns()(x,y)
        end
    };
    ["p"] = {
        max = 300, -- 60 max
        function(x, y)
            for i = 1, rand(1,3) do
                Ents.block(
                    x + rand(-10, 10),
                    y + rand(-10, 10)
                )
            end
        end
    };
    ["P"] = {
        max = 3, -- Max spawns :: 3
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, rand(3,6) do
                block_ctor(
                    x + rand(-32, 32),
                    y + rand(-32, 32)
                )
            end
        end
    };
    ['^'] = {
        max = 0xFFFFFFF;
        function(x,y)
            local grass = Ents.purpgrass
            for i=1, rand(8,9) do
                grass(x + rand(-50, 50), y + rand(-50, 50))
            end
        end
    };
    ['l'] = {
        max = 100;
        function (x, y)
            if rand()<0.3 then
                Ents.mushroom(x+rand()*5,y+rand()*5)            
            else
                Ents.blue_mushroom(x+rand()*5,y+rand()*5)
            end
        end
    }
}
}
local Ents = require("src.entities")
local WH = require("src.misc.worldGen.WH")
local rand = love.math.random
local enemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.boxenemy]    = 0.5;
    [Ents.splatenemy]  = 0.3;
    [Ents.boxblob]     = 0.2;
    [Ents.boxblob]     = 0.2;
    [Ents.ghost]       = 0.1;
    [Ents.boxsplitter] = 0.05
}
local bigEnemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.splatbully] = 1;
}
local purge_fn = function(e, cam_x, cam_y)
    -- called at end of level to clear enemies and walls.
    -- (Passed in as a param to `ccall(apply, .)`  ).
    if (e.targetID ~= "player")
    and (Tools.dist(cam_x-e.pos.x,cam_y-e.pos.y) < 160) then
        ccall("damage",e,0xffff)
    end
end
local function spawn_portal(x, y)
    local portal = EH.Ents.portal(x, y)
    portal.portalDestination = {
        x = 30;
        y = 30;
        tier = 8;
        type="basic"
    }
end
return {
    type = 'basic',
    tier = 7,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.
    construct = function(wor,wmap)
        WH.lights(wor, wmap, 15, 10)
    end;
    PROBS = {
            -- World generation:
            -- Probability of each character occuring.
            -- Each value is a weight and does not actually represent the probability.
            -- see `GenerationSys` for what character represents what.
            ["^"] = 0.8;
            ["l"] = 0.12;
            ["p"] = 0.3;
            ["P"] = 0.01;
            ["."] = 0.4
            -- Bossfights, artefacts, are done through special structure generator
            -- Walls, shops, player spawn, and player exit are done uniquely.
    }, -- Can modify the char probabilities by setting
                        -- this to a table. 
    enemies = {
        n = 25;
        n_var = 4;
        bign = 2;
        bign_var = 0
    };
    ratioWin = function(cam_x, cam_y)
        ccall("apply", purge_fn, cam_x, cam_y)
        ccall("await", spawn_portal, 1.5, cam_x, cam_y)
        --[[
        TODO:
        play sounds and stuff here. Like, a gong would be cool.
        have a shockwave also, that would be cool
        ]]
    end;
    entities = {
    ["e"] = {
        max = 200;
        function(x,y)
            for i=0, 1+rand(1,2) do
                local f = enemySpawns()
                f(x+(i-1)*10 + (rand()-.5)*20, y+(i-1)*10 + (rand()-.5)*20)
            end
        end
    };
    ["E"] = {
        max = 10;
        function(x,y)
            bigEnemySpawns()(x,y)
        end
    };
    ["p"] = {
        max = 300,
        function(x, y)
            for i = 1, rand(1,3) do
                Ents.block(
                    x + rand(-10, 10),
                    y + rand(-10, 10)
                )
            end
        end
    };
    ["P"] = {
        max = 3, 
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, rand(3,6) do
                block_ctor(
                    x + rand(-32, 32),
                    y + rand(-32, 32)
                )
            end
        end
    };
    ['^'] = {
        max = 0xFFFFFFF;
        function(x,y)
            local grass = Ents.grass
            for i=1, rand(8,9) do
                grass(x + rand(-50, 50), y + rand(-50, 50))
            end
        end
    };
    ['l'] = {
        max = 100;
        function (x, y)
            if rand()<0.5 then
                Ents.mushroom(x+(rand()-.5)*40,y+(rand()-.5)*40)
            else
                Ents.pine(x+(rand()-.5)*40,y+(rand()-.5)*40)
            end
        end
    }
}
}
--[[
B-B-B-B-B-BOSS FIGHT!!!
world type:  basic
tier 8
]]
local Ents = require("src.entities")
local rand = love.math.random
local enemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.enemy]    = 0.5;
    [Ents.mallow]   = 0.3;
    [Ents.boxenemy] = 0.2;
    [Ents.blob]     = 0.3;
    [Ents.boxblob]  = 0.2;
    [Ents.ghost]    = 0.1
}
local bigEnemySpawns = Tools.weighted_selection{
    -- [ Ent spawn function ] = <probability of selection >
    [Ents.boxsplitter] = 0.8;
    [Ents.ghost_squad] = 0.2;
    [function(x,y)
        for i=-1,0 do
            Ents.devil(x+(i*15), y+(i*15))
        end
    end] = 0.5
}
local purge_fn = function(e, cam_x, cam_y)
    -- called at end of level to clear enemies and walls.
    -- (Passed in as a param to `ccall(apply, .)`  ).
    if (e.targetID ~= "player")
    and (Tools.dist(cam_x-e.pos.x,cam_y-e.pos.y) < 160) then
        ccall("damage",e,0xffff)
    end
end
local function spawn_portal(x, y)
    local portal = EH.Ents.portal(x, y)
    portal.portalDestination = {
        x = 30;
        y = 30;
        tier = 2;
        type="basic"
    }
end
return {
    type = 'basic',
    tier = 8,
    structureRule = 'default_T1', -- Use default Tier 1 structure rule for this tier.
        -- Note that this is NOT referring to the filename,
        -- it is referring to the `id` of the structureRule.
    PROBS = {
            -- World generation:
            -- Probability of each character occuring.
            -- Each value is a weight and does not actually represent the probability.
            -- see `GenerationSys` for what character represents what.
            ["^"] = 0.8;
            ["l"] = 0.12;
            ["p"] = 0.3;
            ["P"] = 0.01;
            ["."] = 0.4
            -- Bossfights, artefacts, are done through special structure generator
            -- Walls, shops, player spawn, and player exit are done uniquely.
    }, -- Can modify the char probabilities by setting
                        -- this to a table. 
    enemies = {
        n = 30;
        n_var = 1;
        bign = 1;
        bign_var = 0
    };
    ratioWin = function(cam_x, cam_y)
        ccall("apply", purge_fn, cam_x, cam_y)
        ccall("await", spawn_portal, 1.5, cam_x, cam_y)
        --[[
        TODO:
        play sounds and stuff here. Like, a gong would be cool.
        have a shockwave also, that would be cool
        ]]
    end;
    entities = {
    ["e"] = {
        max = 200;
        function(x,y)
            for i=0, 1+rand(1,2) do
                local f = enemySpawns()
                f(x+(i-1)*10 + (rand()-.5)*20, y+(i-1)*10 + (rand()-.5)*20)
            end
        end
    };
    ["E"] = {
        max = 10;
        function(x,y)
            bigEnemySpawns()(x,y)
        end
    };
    ["p"] = {
        max = 300,
        function(x, y)
            for i = 1, rand(1,3) do
                Ents.block(
                    x + rand(-10, 10),
                    y + rand(-10, 10)
                )
            end
        end
    };
    ["P"] = {
        max = 3, 
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, rand(3,6) do
                block_ctor(
                    x + rand(-32, 32),
                    y + rand(-32, 32)
                )
            end
        end
    };
    ['^'] = {
        max = 0xFFFFFFF;
        function(x,y)
            local grass = Ents.grass
            for i=1, rand(8,9) do
                grass(x + rand(-50, 50), y + rand(-50, 50))
            end
        end
    };
    ['l'] = {
        max = 100;
        function (x, y)
            if rand()<0.5 then
                Ents.mushroom(x+(rand()-.5)*40,y+(rand()-.5)*40)
            else
                Ents.pine(x+(rand()-.5)*40,y+(rand()-.5)*40)
            end
        end
    }
}
}
local gladiator_colour = {255, 243, 176}
for i,v in ipairs(gladiator_colour) do-- to normalized
    gladiator_colour[i] = v/255
end
local Ents=EH.Ents
local rand = love.math.random
return {
    type="gladiator",
    tier=1,
    enemies = {
        n=0;
        n_var=0;
        bign=0; bign_var=0
    };
    entities = {
        ['M'] = {
            max=0;
            function(x,y)return end
        };
        ['^'] = {
            max = 0xFFFFFFF;
            function(x,y)
                local grass = Ents.grass
                for i=1, rand(8,9) do
                    grass(x + rand(-50, 50), y + rand(-50, 50))
                end
            end
        };
        ['x'] = {
            max=0xffff;
            function(x,y)
                local e =  Ents.pillar(x,y)
                e.colour = gladiator_colour
            end
        };
        ["#"] = {
            max=0xffff;
            function(x,y)
                local grass = Ents.grass
                Ents.pine(x + rand(-100,100), y + rand(-100,100))
                for i=1, rand(1,3) do
                    grass(x + rand(-50, 50), y + rand(-50, 50))
                end
            end
        };
        ["%"] = {
            max=0xfffff;
            function(x,y)
                Ents.inviswall(x,y)
                local pillar = Ents.pillar(x,y)
            end
        };
        ['l'] = {
            max = 100;
            function (x, y)
                Ents.pine(x+(rand()-.5)*20,y+(rand()-.5)*20)
            end
        }
    }
}
local Ents = require("src.entities")
local rand = love.math.random
local TXT_COLOUR = {120/255, 90/255, 65/255, 0.52}
return {
    type="menu";
    tier = 1;
    enemies = {
        n=0;
        bign=0
    };
    construct = function()
        ccall("setGrassColour","green")
    end;
    entities = {
    ["X"] = {
            --[[
                Experimental entity slot.
                This ent could refer to any entity type, it just depends what I
                am testing rn!
            ]]
            function(x,y)
                for i=1,14 do
                    EH.Ents.enemy(x + i*10,y + i*10)
                end
                for i=1,1 do
                    EH.Ents.mushroomblock(x + i*10 + 50,y + i*10)
                end
            end;
            max=0xfff
        };
        ["#"] = { -- For wall entity.
            max = 999999, --No max.
            Ents.wall
        };
        ["1"] = {
            max=0xff;
            function(x,y)
                local txt = EH.Ents.goodtxt(x, y-35, nil,
                    " WASD\nto move",
                    TXT_COLOUR, 250)
            end
        };
        ["2"] = {
            max=0xff;
            function(x,y)
                local txt = EH.Ents.goodtxt(x,y,nil,
                    "Arrow keys\nto push\nand pull",
                    TXT_COLOUR, 250)
            end
        };
        ["3"] = {
            max=2;
            function(x,y)
                local txt = EH.Ents.goodtxt(x, y, nil,
                    "Colliding blocks\nwill deal damage",
                    TXT_COLOUR, 250)
            end
        };
        ["L"] = {
            max=1;
            function(x,y)
                local txt=EH.Ents.goodtxt(x,y+25, nil,
                    "PROUDLY MADE\nWITH LOVE 2d",
                    {0.85,0.45,0.45})
                EH.Ents.love2d_logo(x,y)
            end
        };
        ["t"] = {
            max=0xfff;
            function(x,y)
            ccall("spawnText", x, y, "push game")
        end};
        ["e"] = {
            max = 200;
            function(x,y)
                Ents.blob(x,y)
                Ents.enemy(x+5,y+5)
                Ents.mallow(x-5,y-5)
            end
        };
        ["p"] = {
            max = 300, -- 300 max
            function(x, y)
                for i = 1, rand(3,6) do
                    Ents.block(
                        x + rand(-10, 10),
                        y + rand(-10, 10)
                    )
                end
            end
        };
        ["P"] = {
            max = 12, -- Max spawns :: 6
            function(x, y)
                local block_ctor = Ents.block
                for i = 1, rand(3,6) do
                    block_ctor(
                        x + rand(-32, 32),
                        y + rand(-32, 32)
                    )
                end
            end
        };
        ['^'] = {
            max = 0xFFFFFFF;
            function(x,y)
                local grass = Ents.grass
                local stone = Ents.stone
                for i=1, rand(8,9) do
                    grass(x + rand(-50, 50), y + rand(-50, 50))
                end
                if rand()<0.3 then
                    for i=1, rand(2,3)do
                        stone(x + rand(-10, 10), y + rand(-10, 10))                    
                    end
                end
            end
        };
        ['%'] = {
            max = 0xFFFFFFFF; --no max;
            Ents.wall
        };
        ['l'] = {
            max = 100;
            function (x, y)
                if rand()<0.5 then
                    Ents.mushroom(x+rand()*5, y+rand()*5)            
                else
                    Ents.pine(x+rand()*5, y+rand()*5)
                end
            end
        },
        ['&'] = {
            max = 0xfff;
            function(x,y)
                local portal = Ents.portal(x,y)
                portal.portalDestination = {
                    tier = 1;
                    type = "basic";
                    x = 32;
                    y = 32
                }
                EH.Ents.goodtxt(x,y+10, nil,"ZONE I",{0.1,0.7,0.1}, 250)
            end
        }
    }
}
--[[
Fallback entity hasher so code can be reused.
This covers basic entities that will be the same across (pretty much)
all iterations of basic_T1, basic_T2 etc.
(Prime example being '@' character)
]]
local Ents = require("src.entities")
local rand = love.math.random
local menu = require("src.misc.worldGen.menu")
local function goToMenu()
    ccall("purge")
    ccall("newWorld",{
        x=100,y=100,
        tier = 1,
        type = 'menu'
    }, menu)
end
return {
    -- NOTE:: YOU DONT NEED TO USE THESE CALLBACKS! they are optional; things will work fine without em
    construct = function(world, worldMap, player_x, player_y )
        -- Callback for when this wType is constructed
        -- (worldMap is only available if passed in)
    end;
    destruct = function()
        -- Callback for when this wType is destructed
    end;
    lose = function( x, y )
        -- wait a bit, then respawn player at menu
        ccall("shockwave", x, y, 10, 700, 30, .57, {0.8,0.05,0.05})
        ccall("spawnText", x, y, "rekt", 750,100)
        ccall("await", goToMenu, 6)
    end;
    entities = {
    ["#"] = { -- For wall entity.
        max = 999999, --No max.
        Ents.wall
    };
    ["%"] = {
        max=math.huge;
        function(x,y)
            Ents.inviswall(x,y)
            for i=1, (rand()*2) do--4 + rand()*2 do
                local X = x+90*(rand()-0.5)
                local Y = y+90*(rand()-0.5)
                Ents.fakepine(X,Y)    
            end
        end
    };
    ["~"] = {
        max=math.huge;
        function(x,y)
            for i=1, rand()*4 do--4 + rand()*2 do
                local X = x+200*(rand()-0.5)
                local Y = y+200*(rand()-0.5)
                Ents.fakepine(X,Y)    
            end
        end
    };
    ["p"] = {
        max = 300, -- 60 max
        function(x, y)
            for i = 1, rand(1,3) do
                Ents.block(
                    x + rand(-10, 10),
                    y + rand(-10, 10)
                )
            end
        end
    };
    ["P"] = {
        max = 3, -- Max spawns :: 3
        function(x, y)
            local block_ctor = Ents.block
            for i = 1, rand(3,6) do
                block_ctor(
                    x + rand(-32, 32),
                    y + rand(-32, 32)
                )
            end
        end
    };
    ['^'] = {
        max = 0xFFFFFFF;
        function(x,y)
            local grass = Ents.grass
            for i=1, rand(8,9) do
                grass(x + rand(-50, 50), y + rand(-50, 50))
            end
        end
    };
    ['l'] = {
        max = 100;
        function (x, y)
            if rand()<0.5 then
                Ents.mushroom(x+rand()*5,y+rand()*5)            
            else
                Ents.pine(x+rand()*5,y+rand()*5)
            end
        end
    };
    ["@"] = {
        max = 1;
        function(x,y)
            return Ents.player(x,y)
        end
    }
    }
}
--[[
`worldTypes` is a table of the form ::
{
    basic = {
        [1] = basic_T1,
        [2] = basic_T2
    },
    other = {
        [1] = other_T1,
        [2] = other_T2
    }
}
Note :::
It doesn't matter what the files are called in this directory!!!
All that matters is that each file is a worldType table,
and each worldType has the appropriate `tier` and `type` fields.
]]
local PATH = Tools.Path(...):gsub("%.","%/")
local default = require(PATH:gsub("%/","%.").."._default")
local Auxiliary = { }
local function req_TREE(PATH)
    for _,fname in ipairs(love.filesystem.getDirectoryItems(PATH)) do
        if fname:sub(1,1) ~= "_" then
            local proper_name = fname:gsub(".lua", "")
            fname = PATH.."/"..fname
            local info = love.filesystem.getInfo(fname)
            if info.type == "directory" then
                req_TREE(fname)
            else
                Auxiliary[proper_name] = require(fname:gsub("/","."):gsub(".lua", ""))
            end
        end
    end
end
req_TREE(PATH)
local defaultEntExclusionZones =
require(PATH:gsub("worldTypes", "").."defaultEntExclusionZones")
local EMPTY = {
    max = 0xFFFFFFFFFFFFFFFFFFFF, -- For uninitialized char spawn calls,
    function()end                 -- this table will be accessed.
}
assert(default.entities, "?")
setmetatable(default.entities,{
    __index = function(t,k) return EMPTY end
})
local worldType_entity_mt = {
    __index = default.entities
}
local worldType_mt = {
    __index = default
}
local charProbability_mt = {
    __index = CONSTANTS.PROBS
}
local worldTypes = { }
for name, wType in pairs(Auxiliary) do
    local type = wType.type
    local tier = wType.tier
    assert(type, "not given a type")
    assert(tier, "not given a tier")
    if not (worldTypes[type]) then
        -- If this type does not have a spot in table, put in
        worldTypes[type] = { }
    end
    assert(not (worldTypes[type][tier]), 
    ("duplicate worldType: type=%s tier=%d \nAssert that no worlds overwrite anything else"):format(type, tier))
    wType.entities = setmetatable(wType.entities, worldType_entity_mt)
    setmetatable(wType, worldType_mt)
    assert(wType.enemies, ("enemy table not implimented in worldType: type: %s, tier: %s"):format(type, tier))
    if not wType.entExclusionZones then
        wType.entExclusionZones = defaultEntExclusionZones
    end
    worldTypes[type][tier] = wType
end
return worldTypes
return{
    MAX_DT = 0.05 -- Maximum value `dt` will ever take.
,
    AVERAGE_DT = 1/60
,
    GRAVITY = -981
,
    MAX_VEL = 5000
,
    PHYS_CAP = 45 -- the max number of phys objs allowed in each spatial bucket
,
    PUSH_RANGE = 50
,
    PUSH_COOLDOWN = 0.5
,
    PULL_COOLDOWN = 0.4
,
    PHYSICS_LINEAR_DAMPING = 0.05
,
    ENT_DMG_SPEED = 300 -- ents hit faster than this will be damaged (except player!)
,
    PROBS = {
        -- World generation:
        -- Probability of each character occuring.
        -- Each value is a weight and does not actually represent the probability.
        -- see `GenerationSys` for what character represents what.
        ["^"] = 0.8;
        ["l"] = 0.03;
        ["p"] = 0.3;
        ["P"] = 0.01;
        ["."] = 0.5
        -- Bossfights, artefacts, are done through special structure generator
        -- Walls, shops, player spawn, and player exit are done uniquely.
    }
,
    TARGET_GROUPS = {
        "player";
        "physics";
        "enemy";
        "neutral";
        "interact";
        "coin"
    }
,
    WIN_RATIO = 0.35-- Good value is 0.35 (had to make higher because of invisible ents)
    -- percentage of enemies that need to be killed before ccall("winRatio")
,
    paused = false  -- debug only  (if not debug only, make an cyan.call event for this)
,
    grass_colour = {0.4,1,0.5} -- colour of ground grass    
                -- TODO: Player should be able to change grass colour!
,
    GRASS_COLOURS = {
        green = {0.4,1,0.5};
        aqua  = {50/255, 220/255, 185/255};
        yellow = {255/255, 250/255, 66/255}
    }
,
    SAVE_DATA_FNAME = "game.png" -- save data filename
    -- We encode as a png so people wont tamper with it ahahahahaha
,
    SAVE_DATA_DEFAULT = {
        -- The default save data for a program.
        -- Putting this in CONSTANTS.lua ensures future compatibility.
        tokens = 0; -- the number of tokens player has collected
    }
,
    SPLAT_COLOUR = {255/255, 241/255, 16/255}
,
    COLOURBLIND = false --==>>>  swaps blue-green
,
    DEVILBLIND  = false --==>>>  swaps red-green
,
    NAVYBLIND   = false --==>>>  swaps blue-red
,
    MASTER_VOLUME = 0.4--.4-- = 0.4 -- volume is always a number:   0 --> 1
,
    DEBUG = true
}
local path = "src/misc"
Tools.req_TREE(path)
local BehaviourSys = Cyan.System("behaviour")
--[[
Runs and update behaviour trees
]]
local cexists = Cyan.exists
local function update(e,dt )
    if cexists(e) then
        if e.behaviour.tree then
            e.behaviour.tree:update(e, dt)
        end
    end
end
function BehaviourSys:update(dt)
    for _,e in ipairs(self.group)do
        update(e,dt)
    end
end
function BehaviourSys:damage(ent, amount)
    if self:has(ent) then
        if ent.behaviour.tree then
            ent.behaviour.tree:call('damage', ent, amount)
        end
    end
end
local BuffSystem = Cyan.System("buff")
--[[
TODO:::: NEEDS TESTING!!
In charge of buffing and debuffing ents.
buff component:
    buff = {
        buffs = {"speed", "strength"}
        speed = 30 -- 30 seconds left for speed
        strength = 15.32
    }
]]
local Buffs = require("src.misc.buffs.buffs")
function BuffSystem:buff(ent, buffType, time, a1,a2,a3,a_ER)
    --[[
        buff( ent, buff_type, time, ... )
    ]]
    if not Buffs[buffType] then
        error("Unknown buff type: "..tostring(buffType))
    end
    if a_ER then
        error("too many args used, add an xtra one in BuffSystem")
    end
    if type(time)~="number" then
        error("time parameter was not number. got: "..type(time))
    end
    if (not ent:has("buff")) then
        ent:add("buff", {
            [buffType] = time;
            buffs = {buffType}
        })
        Buffs[buffType].buff(ent, a1, a2, a3)
    elseif not ent.buff[buffType] then
        Buffs[buffType].buff(ent, a1, a2, a3)
        table.insert(ent.buff.buffs, buffType)
        ent.buff[buffType] = time
    else
        -- else- it either already has the buff.
        -- can't buff twice, but we can increase the time tho.
        ent.buff[buffType] = math.max(ent.buff[buffType], time)
    end
end
local function debuff(ent, bufftype, i)
    local buff = ent.buff
    table.remove(buff.buffs, i)
    buff[bufftype] = nil
    assert(Buffs[bufftype].debuff,"?????")
    Buffs[bufftype].debuff(ent)
    if #buff.buffs <= 0 then
        -- entity has no more buffs left.
        -- remove from system
        ent:remove("buff")
    end
end
function BuffSystem:debuff(ent, btype)
    if self:has(ent) then
        local buffs = ent.buff.buffs
        for i=1, #buffs do
            if buffs[i] == btype then
                debuff(ent, btype, i)
            end
        end
    end
end
local function update(ent,dt)
    local buff = ent.buff
    for i, bufftype in ipairs(buff.buffs) do
        assert(buff[bufftype], "????????????")
        buff[bufftype] = buff[bufftype] - dt
        if buff[bufftype] < 0 then
            debuff(ent, bufftype, i)
        end
    end
end
function BuffSystem:update(dt)
    for _,ent in ipairs(self.group) do
        update(ent, dt)
    end
end
--[[
ControlSys:
Handles camera transformations and player motion.
Also handles `pushing` and `pulling` by player,
and HealthBars etc.
TODO: add joystick support, make more robust
]]
local ControlSys = Cyan.System("control")
local Camera = require("src.misc.unique.camera")
local Partition = require 'src.misc.partition'
local TargetPartitions = require("src.misc.unique.partition_targets")
local max, min = math.max, math.min
local ROT_AMPLITUDE = 0.03
local ROT_FREQ = 0.07
local cur_sin_amount = 0
local cam_rot = 0
-- camera position gets locked when all players are killed
local lock_cam_x, lock_cam_y
local dist = Tools.dist
local ccall = Cyan.call
local dot = math.dot
    -- THIS FUNCTION IS FOR DEBUG PURPOSES ONLY !!!!!!!!!!!
function ControlSys:wheelmoved(dx, dy)
    Camera.scale = Camera.scale + (dy/30)
end
function ControlSys:added(e)
    -- just some sanity checks
    e.control.canPush = true
    e.control.canPull = true
end
-- We have to keep a boolean var to check if purge was invoked.
-- (signalling a lose condition during a purge would be terrrrible)
local duringPurge = false
function ControlSys:removed(e)
    if not duringPurge then
        if #self.group == 1 then
            -- then this is the last player in game.
            -- lock the camera, emit the lose callback; worldGen will handle it
            -- from here
            lock_cam_x = e.pos.x
            lock_cam_y = e.pos.y
            ccall("lose")
        end
    end
end
local function findEntToPush(ent)
    --[[
        returns the closest ent that is able to be pushed by `ent`.
    ]]
    local min_dist
    if ent.size then
        min_dist = ent.size * 10
    else
        min_dist = 50
    end
    local best_ent = nil
    local epos = ent.pos
    local vx, vy = ent.vel.x, ent.vel.y
    for candidate in Partition:longiter(ent) do
        -- if its not moving, it wont be pushed
        if candidate.vel then
            local ppos = candidate.pos
            local dx, dy
            dx = ppos.x - epos.x
            dy = ppos.y - epos.y
            if candidate.pushable then
                local distance = dist(dx, dy)
                if distance < min_dist then
                    -- Is a valid candidate ::
                    if dot(dx, dy, vx,vy) > 0 then
                        best_ent = candidate
                        min_dist = distance
                    end
                end
            end
        end
    end
    return best_ent
end
function ControlSys:update(dt)
    duringPurge = false -- obviously if a frame has passed, it will no longer
        -- be during a purge callback.
    Camera:update(dt)
    for _,ent in ipairs(self.group) do
        local c = ent.control
        local speed = ent.speed.speed or 4
        local dx = 0
        local dy = 0
        if c.move_up then
            dy = -speed
        end
        if c.move_down then
            dy = dy + speed
        end
        if c.move_left then
            dx = -speed
        end
        if c.move_right then
            dx = speed
        end
        ccall("addVel", ent, dx, dy)
        if c.zoomIn then
            Camera.scale = min(Camera.scale * (1+dt), 3)
        end
        if c.zoomOut then
            Camera.scale = max(Camera.scale * (1-dt), 1.5)
        end
    end
end
local r = love.math.random 
local function afterPush(player)
    if Cyan.exists(player) then
        player.control.canPush = true
    end
end
local function pushFeedback(player)
    if Cyan.exists(player)then
        ccall("sound", "reload", 0.2)
        ccall("emit", "shell", player.pos.x, player.pos.y, 1, r(2,3))
    end
end
local function push(ent)
    assert(ent.control,"??????????")
    for e in (TargetPartitions.interact):iter(ent.pos.x, ent.pos.y) do
        if e ~= ent then
        -- ents cannot interact with themself
            if e.onInteract and Tools.edist(ent, e) < e.size then
                e:onInteract(ent, "push")
                return -- We dont want to push if its an interact
            end
        end
    end
    if ent.control.canPush then
        local x = ent.pos.x
        local y = ent.pos.y
        local z = ent.pos.z
        -- boom will be biased towards enemies with 1.2 radians
        ccall("boom", x, y, ent.strength, 100, 0,0, "enemy", 1.2)
        ccall("animate", "push", x,y+25,z, 0.03) 
        ccall("shockwave", x, y, 4, 130, 7, 0.3)
        ccall("sound", "boom")
        Camera:shake(8, 1, 60) -- this doesnt work, RIP
        ent.control.canPush = false
        ccall("await", pushFeedback, CONSTANTS.PUSH_COOLDOWN/4, ent)
        ccall("await", afterPush, CONSTANTS.PUSH_COOLDOWN, ent)
    else
        --TODO ::: add feedback here!
        -- the player just tried to push on cooldown
    end
end
local function afterPull(player)
    if Cyan.exists(player) then
        player.control.canPull = true
    end
end
local function pull(ent)
    assert(ent.control, "?????")
    if ent.control.canPull then
        local x,y = ent.pos.x, ent.pos.y
        ent.control.canPull = false
        ccall("sound", "moob")
        ccall("shockwave", x, y, 130, 4, 7, 0.3)
        ccall("moob", x, y, ent.strength/1.7, 300)
        ccall("await", afterPull, CONSTANTS.PULL_COOLDOWN, ent)
        for e in (TargetPartitions.interact):iter(x, y) do
            if e ~= ent then
                -- ents cannot interact with themself
                if e.onInteract and Tools.edist(ent, e) < e.size then
                    e:onInteract(ent, "pull")
                end
            end
        end
    else
        --TODO ::: add feedback here!
        -- the player just tried to pull on cooldown
    end
end
function ControlSys:keytap(key)
    for _, ent in ipairs(self.group) do
        local c = ent.control
        if c[key] == 'push' then
            push(ent)
        elseif c[key] == 'pull' then
            pull(ent)
        end
    end
end
function ControlSys:keydown(key)
    for _, ent in ipairs(self.group) do
        local control = ent.control
        local purpose = control[key]
        if purpose then
            control[purpose] = true
        end
    end
end
function ControlSys:keyheld(key, time)
    for _, ent in ipairs(self.group) do
        local control=ent.control
        local purpose = control[key]
        if purpose == "push" then
            if not ent.pushing then
                local push_ent = findEntToPush(ent)
                if push_ent then
                    ent:add("pushing", push_ent)
                end
            end
        end
    end
end
function ControlSys:keyup(key)
    for _, ent in ipairs(self.group) do
        local control = ent.control
        local purpose = control[key]
        if purpose then
            control[purpose] = false
            if purpose == "push" then
                if ent:has("pushing") then
                    ent:remove("pushing")
                end
            end
        end
    end
end
function ControlSys:purge()
    duringPurge = true
    Cyan.clear( ) -- Deletes all entities.
    -- big operation
    -- TODO:
    -- WHY IS THIS HERE??
    -- put this somewhere else
end
function ControlSys:newWorld()
    lock_cam_x = nil
    lock_cam_y = nil
end
--[[
Drawing health Bar
]]
local setColor = love.graphics.setColor
local rect = love.graphics.rectangle
local draw = love.graphics.draw
local atlas = require("assets.atlas")
local Quads = atlas.Quads
local lg=love.graphics
local HP_X = 10
local HP_Y = 8
local tick = 0
local sin = math.sin
function ControlSys:drawUI()
    -- check that a player exists
    if self.group[1] then
        -- At the moment, we only support 1 health bar.
        local hp = self.group[1].hp
        tick = tick + 0.01
        setColor( 0.7 + 0.1*sin(tick) ,0,0)
        rect("fill", HP_X+2, HP_Y+2, 26 * (hp.hp / (hp.max_hp)), 10)
        setColor(1,1,1)
        atlas:draw(Quads.hp_bar, HP_X, HP_Y)
    end
end
local function getAveragePosition(group) -- => (x, y)
    if lock_cam_x then
        assert(lock_cam_y,"?")
        return lock_cam_x, lock_cam_y
    end
    if #group > 0 then
        local x = 0
        local y = 0
        local follow_count = 0
        for _, ent in ipairs(group) do
            follow_count = follow_count + 1
            x = x + ent.pos.x
            y = y + ent.pos.y
        end
        x = x / follow_count
        y = y / follow_count
        return x,y
    else -- not enough entities to get an average position
        -- (this should never happen btw)
        return 0,0
    end
end
function ControlSys:transform()    
    Camera:attach()
    local x,y = getAveragePosition(self.group)
    Camera:follow(x,y)
end
function ControlSys:untransform()
    Camera:detach()
end
--[[
For detecting collisions/ent detections within certain ranges.
A good way to do this would be to have the components point to functions somehow.
But how to store the data...? Not sure. Definitely use targetID tho
]]
local DetectSys = Cyan.System("pos", "collisions")
local PartitionTargets = require("src.misc.unique.partition_targets") 
function DetectSys:added(e)
    if e.collisions[1] then
        error("You are using `collisions` component incorrectly, see `components.md`")
    end
    if e.collisions.area then
        local targets = { }
        for k,v in pairs(e.collisions.area) do
            if not PartitionTargets[k] then
                error("Misuse of e.collisions component. See components.md")
            end
            table.insert(targets, k)
        end
        e.collisions.areaTargets = targets
    end
    -- Backref so pairs doesn't need to be done.
    -- Note that this also makes it so that component `collisions` 
    -- cannot be modified at runtime.
end
local dist = Tools.dist
local er1 = "Collision entity had no position component, WAT?????? why is this in the partition"
function DetectSys:collide(e1, e2, speed)
    local collisions = e1.collisions
    if collisions.physics then
        collisions.physics(e1,e2,speed)
    end
end
local function S_update(e, dt)
    --[[
        We don't need to worry about `collisions.physics`,
        that is handled seperately by the physics system;
        we just need to listen for any ccall("collide") events.
    ]]
    local pos = e.pos
    local collisions = e.collisions
    local area = collisions.area
    if collisions.areaTargets then
        for _, targetID in ipairs(collisions.areaTargets)do
            if not PartitionTargets[targetID] then
                error("unknown target ID:  " .. tostring(targetID))
            end
            for col_ent in PartitionTargets[targetID]:iter(pos.x, pos.y) do
                if not(col_ent == e) then
                -- Ent shouldn't interact with itself
                    local colpos = col_ent.pos
                    local d = dist(pos.x - colpos.x,  pos.y - colpos.y)
                    if d < ((e.size or 5) + (col_ent.size or 5)) then
                        area[targetID](e, col_ent, dt)
                    end
                end
            end
        end
    end
end
function DetectSys:update(dt)
    for _, e in ipairs(self.group) do
        S_update(e, dt)
    end
end
local BobSys = Cyan.System("bobbing", "draw")
--[[
For entities that are bobbing up and down.
]]
local sin = math.sin
local rand_choice = Tools.rand_choice
-- Speed at which entities "bob" (rads/s)
local speed = 13
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
function BobSys:added(ent)
    ent.bobbing.phase = rand_choice(t)
    ent.bobbing.oy = 0
    if not ent.bobbing.magnitude then
        ent.bobbing.magnitude = 5
    end
end
local x = 0
function BobSys:update(dt)
    x = x + (dt * speed)
    for indx, func in ipairs(functions) do
        values[indx] = func(x)
    end
    for _, ent in ipairs(self.group) do
        local bobbing = ent.bobbing
        local draw = ent.draw
        local value = values[bobbing.phase]
        bobbing.value = 1  +  value * bobbing.magnitude
        bobbing.scale = (bobbing.value * bobbing.magnitude)+(1-bobbing.magnitude)
        bobbing.oy =  - ((bobbing.value-1) * draw.h * -1 * bobbing.magnitude)
    end
end
local DrawSys = Cyan.System("pos", "draw")
--[[
Main drawing system.
Will emit draw calls based on position, and in correct order.
]]
local Tools = _G.Tools
local PATH = Tools.Path(...)
local Set = require ("libs.tools.sets")
local floor = math.floor
local Atlas = require("assets.atlas")
local font = require("src.misc.unique.font")
local push = require("libs.NM_push.push")
--[[push:setupScreen(
    love.graphics.getWidth()/3, 
    love.graphics.getHeight()/3,
    love.graphics.getWidth(),
    love.graphics.getHeight(), 
    {fullscreen = false, pixelperfect=false}
)]]
-- Ordered drawing data structure
local Indexer = setmetatable({},
    --[[
        each pixel is represented by a set in Indexer.
        So, doing Indexer[floor(ent.pos.y + ent.pos.z)] will get the set that holds ent.
    ]]
    {__index = function(t, k)
        t[k] = Set()
        return t[k]
    end}
)
-- This table holds Entities that point to `y+z` values that ensure that
-- Entities in Indexer can always be found.  (y+z positions are updated only when system is ready.)
local positions = {}
local Indexer_max_depth = 0
local Indexer_min_depth = 0
local min = math.min
local max = math.max
-- a Set for all shockwave objects that are being drawn
local ShockWaves = Tools.set()
local set, add, remove
do
    function add(ent)
        --[[
            Adds entity to Indexer
        ]]
        local zindx = floor((ent.pos.y + ent.pos.z)/2)
        Indexer[zindx]:add(ent)
        Indexer_max_depth = max(Indexer_max_depth, zindx)
        Indexer_min_depth = min(Indexer_min_depth, zindx)
    end
    function remove(ent)
        --[[
            Removes entity from previous Indexer location.
        ]]
        local gett = positions[ent]
        Indexer[gett]:remove(ent)
        return gett
    end
    function set(ent)
        --[[
            Sets current position of entity in Indexer, to give system awareness
            of what location ent is currently in in Indexer sets.
        ]]
        positions[ent] = floor((ent.pos.y + ent.pos.z)/2)
    end
end
function DrawSys:added( ent )
    -- Callback for entity addition
    set(ent)
    add(ent)
end
function DrawSys:removed( ent )
    -- Callback for entity removal
    remove(ent)
    positions[ent] = nil
    ent.draw = nil
end
function DrawSys:update(dt)
    for _,sw in ipairs(ShockWaves.objects)do
        sw:update(dt)
        if sw.isFinished then
            ShockWaves:remove(sw)
            sw.colour = nil -- easier on GC
        end
    end
end
local ccall = Cyan.call
local lg = love.graphics
local getW = love.graphics.getWidth
local getH = love.graphics.getHeight
local rawget = rawget
local ipairs = ipairs
local camera = require("src.misc.unique.camera")
local drawShockWaves
local setFont = love.graphics.setFont
local function mainDraw()
    local setColor = lg.setColor
    local isOnScreen = Tools.isOnScreen
    ccall("transform")
    setColor(CONSTANTS.grass_colour)
    setFont(font)
    local w,h = getW(), getH()
    local camx, camy = camera.x, camera.y
    lg.rectangle("fill", -10000,-10000, 20000,20000)
    setColor(1,1,1)
    local indx_set
    for z_dep = Indexer_min_depth, Indexer_max_depth do
        if rawget(Indexer, z_dep) then
            indx_set = Indexer[z_dep]
            for _, ent in ipairs(indx_set.objects) do
                if isOnScreen(ent, camera) then
                    setColor(1,1,1)
                    if not ent.hidden then
                        if ent.trivial then
                            ccall("drawTrivial", ent)
                        else
                            if ent.colour then
                                setColor(ent.colour)
                            end
                            ccall("drawEntity", ent)
                        end
                    end
                end
            end
        end
        ccall("drawIndex", z_dep)
    end
    Atlas:flush( )
    drawShockWaves()
    ccall("untransform")
end
function DrawSys:draw()
    mainDraw()
    lg.push()
    lg.scale(2)
    ccall("drawUI")
    lg.pop()
end
function DrawSys:setGrassColour(colour, a)
    if a then
        error("Grass colour expected a table, not (R, G, B)")
    end
    if type(colour) == "string" then
        local col = CONSTANTS.GRASS_COLOURS[colour]
        if not col then
            error("Colour string "..colour.." did not have a CONSTANT.GRASS_COLOUR value.")
        end
        CONSTANTS.grass_colour = col
        return
    end
    CONSTANTS.GRASS_COLOUR = colour
end
local newShockWave = require("src.misc.unique.shockwave")
function DrawSys:shockwave(x, y, start_size, end_size, thickness, time, colour)
    local sw = newShockWave(x,y,start_size, end_size, thickness, time, colour or {1,1,1,1})
    ShockWaves:add(sw)
end
function drawShockWaves()
    for _,sw in ipairs(ShockWaves.objects) do
        sw:draw(  )
    end
end
local IndexSys = Cyan.System("pos", "draw", "vel")
local function fshift(ent)
    --[[
        shifts the entities around in the indexer structure
        in a fast manner
    ]]
    local z_index = floor((ent.pos.y + ent.pos.z)/2)
    if positions[ent] ~= z_index then
        remove(ent)
        set(ent)
        add(ent)
    end
end
function IndexSys:update()
    for _, ent in ipairs(self.group) do
        fshift(ent)
    end
end
--[[
ents will fade from view the further they get
from the camera position
IMPORTANT:
Colour tables assigned to entities must be memory unique, else the alpha channel
of one entity will affect all others that share the ref of the table
]]
local FadeSys = Cyan.System("fade")
local cam = require("src.misc.unique.camera")
function FadeSys:added(ent)
    if not ent.colour then
        ent.colour = {1,1,1,1} -- They may be given a colour in future,
            -- but who cares. GC already hates me ahhaha
    end
end
local max = math.max
local min = math.min
function FadeSys:update(dt)
    for _, ent in ipairs(self.group) do -- fades the further away from player
        local minfade = ent.minfade or 0
        local dist = Tools.distToPlayer(ent,cam)
        --ent.colour[4] = min(max((ent.fade / dist)-1, minfade), 1)
        ent.colour[4] = min(max((ent.fade / dist)-1, 0), 1)
    end
end
local FrictionSys = Cyan.System("friction", "pos", "vel")
--[[
In charge of providing friction, (slowing velocity)
and drawing dust particles at base of object.
]]
local THRESHOLD = 20
function FrictionSys:added(ent)
    -- Add friction to body of object.
    ent.friction.amount = ent.friction.amount or 5 -- default value
    ent.friction.on = true
    if ent.physics then
        if type(ent.physics.body) == "userdata" then
            ent.physics.body:setLinearDamping(ent.friction.amount)
        end
    end
end
function FrictionSys:grounded(ent)
    if ent.friction then
        ent.friction.on = true
    end
end
function FrictionSys:airborne(ent)
    if ent.friction then
        ent.friction.on = false
    end
end
function FrictionSys:update( dt )
    for _, ent in ipairs(self.group) do
        local friction = ent.friction
        local emitter = friction.emitter
        if emitter then
            emitter:update(dt)
            emitter:setPosition(ent.pos.x + ent.vel.x/50, ent.pos.y + ent.vel.y/50)
            local isStopped = emitter:isStopped()
            if (ent.vel:len() > THRESHOLD) and friction.on then
                if isStopped then
                    emitter:start()
                end
            else
                if not isStopped then
                    emitter:stop()
                end
            end
            if not ent:has("physics") then
                ent.vel = ent.vel - (ent.vel * (ent.friction.amount * dt))
            end
        end
    end
end
local lgdraw = love.graphics.draw
function FrictionSys:drawEntity(ent)
    if self:has(ent) then
        if ent.friction.emitter and ent.grounded then
            if not(ent.friction.emitter:isStopped()) then
                lgdraw(ent.friction.emitter, 0, 8) -- Draw at 0, 8. (at bottom of ent)
            end
        end
    end
end
function FrictionSys:removed(ent)
    if ent.friction.emitter then
        ent.friction.emitter:release()
    end
end
local atlas = require 'assets.atlas'
local ImageSys = Cyan.System("image", "pos")
function ImageSys:added(ent)
    if type(ent.image) == "userdata" then
        if ent.image:type() == "Quad" then
            -- Assume ent.image is a quad.
            ent.image = {
                quad = ent.image
            }
        else
            error("ent.image: expected quad or table, got: "..ent.image:type())
        end
    end
    local image = ent.image
    local _,_, w,h = image.quad:getViewport( )
    if not image.ox then
        image.ox = w/2
    end
    if not image.oy then
        image.oy = h/2
    end
    ent:add("draw", {
        ox = image.ox;
        oy = image.oy;
        w = w;
        h = h
    }) -- tell that its a drawable entity
end
local default_bob = {value = 1, magnitude = 0, oy = 0}
local default_sway = {value = 0, magnitude = 0, ox = 0}
function ImageSys:drawEntity(ent)
    --[[
        Draws the entity
    ]]
    if self:has(ent) then
        local bob_comp = ent.bobbing or default_bob
        local sway_comp = ent.swaying or default_sway
        if not (ent.animation or ent.motion) then -- Else, other systems will do the drawing.
            local img = ent.image
            local draw = ent.draw
            local pos = ent.pos
            atlas:draw(img.quad, pos.x, pos.y - pos.z/2,
                ent.rot or 0, 1,
                bob_comp.scale,
                draw.ox + sway_comp.ox, 
                draw.oy + bob_comp.oy,
                sway_comp.value
            )
        end
    end
end
function ImageSys:drawTrivial(ent)
    local bob_comp = ent.bobbing or default_bob
    local sway_comp = ent.swaying or default_sway
    local img = ent.image
    local draw = ent.draw
    atlas:draw(img.quad, ent.pos.x, ent.pos.y - ent.pos.z/2,
                ent.rot or 0, 1,
                bob_comp.scale,
                draw.ox + sway_comp.ox, 
                draw.oy + bob_comp.oy,
                sway_comp.value
    )
end
local LightSys = Cyan.System("light")
-- shader consts.
local BASE_LIGHTING = {0.4, 0.4, 0.4, 1}
local MAX_LIGHT_STRENGTH = 0.65
local NUM_LIGHTS = 20 -- max N
local BRIGHTNESS_MODIFIER = 4 -- all light strengths divided by 100
local cam = require("src.misc.unique.camera")
-- X, Y  =  cam:toCameraCoords(x,y)
local shader = require("src.misc.unique.shader")
local getW = love.graphics.getWidth
local getH = love.graphics.getHeight
function LightSys:setBaseLighting(newValue)
    BASE_LIGHTING = newValue
end
function LightSys:added(e)
    if (not e.light.colour) or (not e.light.distance) then
        error("LightSys: entity added is missing a required field")
    end
    if #e.light.colour ~= 4 then
        error("ent.light.colour expected to be a 4d vector")
    end
end
local function send(e, light_positions, light_colours, light_distances)
    local x,y = cam:toCameraCoords(
        e.pos.x,
        e.pos.y
    )
    table.insert(light_positions, {x,y})
    table.insert(light_colours,   e.light.colour)
    table.insert(light_distances, e.light.distance * cam.scale)
end
local function makeLight(ent, distance, time, colour, fade)
    --[[
        constructs the rest of fields for light source
    ]]
    ent.hp.hp = time
    ent.hp.max_hp = time
    ent.hp.regen = -1 -- gets -1 hp per second
    ent.light.distance=distance
    if fade then
        ent.hybrid = true
        -- onUpdate function is specified in `ents -> light.lua`
        -- cache original distance of light
        ent.original_distance = distance
    end
end
local DEFAULT_LIGHT_COL = {1,1,1,1}
function LightSys:light(x, y, distance, time, colour, fade)
    --[[
        colour is colour of light
        distance is distance
        time is how long it exists for
        fade = true/false
            If fade is true, the light will linearly fade to black
    ]]
    colour = colour or DEFAULT_LIGHT_COL
    assert(#colour == 4, "must be 4d vector for colour thx")
    time = time or 0xffffffffffffffff -- else it exists forever
    local u = EH.Ents.light(x,y)
    makeLight(u,distance,time,colour,fade)
end
function LightSys:update()
    local light_positions = {}
    local light_colours   = {}
    local light_distances = {}
    for _, e in ipairs(self.group)do
        if Tools.distToPlayer(e, cam) < 1000 then
            send(e, light_positions, light_colours, light_distances)
        end
    end
    assert((#light_positions == #light_colours)
        and (#light_positions == #light_distances), "???")
    -- This sucks.
    --TODO: Convert this to a matrix so you can do it efficiently please
    for i=1, 20-#light_positions do
        table.insert(light_positions, {0,0})
        table.insert(light_colours  , {0,0,0,0})
        table.insert(light_distances, 0)
    end
    local unpack = table.unpack or unpack -- F**CK. This breaks JIT, I didnt want to do this. No choice tho
    -- TODO:
    -- NOTE: You can fix this unpacking by packing values into a matrix!
    -- maybe leave it for now, see how this game performs on machines with slower pipeline
    shader:send("light_positions", unpack(light_positions))
    shader:send("light_colours"  , unpack(light_colours))
    shader:send("light_distances", unpack(light_distances))
    shader:send("num_lights", NUM_LIGHTS)
    shader:send("base_lighting", BASE_LIGHTING)
    shader:send("max_light_strength", MAX_LIGHT_STRENGTH)
    shader:send("brightness_modifier", BRIGHTNESS_MODIFIER)
end
local atlas = require("assets.atlas")
--[[
This is a really dumb fix....
But I had to rename this filename and system to `LinearAnimationSys` so
FrictionSys would be drawn before this.
Future oli here:
This whole File is dumb. Tjhis whole idea is dumb! Dont give crappy animation
objects control over every single entity. Next time, pass the position only
and make it so the animObjs do all the work. AnimationSys should not have to do
field checks!!!! I mean this is literal spagetti
]]
local LinearAnimationSys = Cyan.System("animation", "pos")
-- { [ent] : anim_obj } table, this is for entities that are being tracked by
-- anim objects. The reason we need this is because if an entity is destroyed,
-- we need to let the animation object know.
local ents_being_tracked = setmetatable({ }, {__mode="kv"})
-- (this is for ccall("animate", ...) btw)
local cexists = Cyan.exists
function LinearAnimationSys:added(ent)
    local anim = ent.animation
    anim.animation_len = #anim.frames
    anim.current = 0
    local _,_, w,h = anim.frames[1]:getViewport( )
    if not anim.ox then
        anim.ox = w/2
    end
    if not anim.oy then
        anim.oy = h/2
    end
    if anim.sounds then
        anim.sounds.last_index = 1
    end
    ent:add("draw",{
        ox=anim.ox;
        oy=anim.oy;
        w=w;
        h=h
    })
end
function LinearAnimationSys:removed(ent)
    if ent.anim then
        local a = ent.anim
        for i = 1, #a.frames do
            a.frames[i] = nil
        end
    end
    if ents_being_tracked[ent] then
        ents_being_tracked[ent]:removed(ent)
    end
end
local floor = math.floor
local default_bob = {scale = 1, magnitude = 0, oy=0}
local default_sway = {value = 0, ox=0}
local function doSounds(ent, index)
    local anim = ent.animation
    local sounds = anim.sounds
    if index ~= sounds.last_index then
        if sounds[index] then
            ccall("sound", sounds[index], sounds.vol,
                            sounds.pitch, sounds.vol_v, sounds.pitch_v)
        end
    end
    sounds.last_index = index
end
function LinearAnimationSys:drawEntity( ent )
    if self:has(ent) then
        local index
        local anim = ent.animation
        local draw = ent.draw
        index = (floor(anim.current / (anim.interval))) + 1
        if anim.sounds then
            doSounds(ent, index)
        end
        local bob_comp = ent.bobbing or default_bob
        -- img.oy must be modified for bobbing entities
        local sway_comp = ent.swaying or default_sway
        local oy = ent.animation.oy
        atlas:draw(
            anim.frames[index],
            ent.pos.x,
            ent.pos.y - ent.pos.z/2,
            ent.rot,1,
            bob_comp.scale,
            draw.ox + sway_comp.ox,
            oy + bob_comp.oy,
            sway_comp.value
        )
    end
end
--[[
*****
*****
*****
*****
*****
*****
*****
*****
Static callbacks :::
    Inducing animations regardless of entity.
    (See src.misc.animation.types for a list of possible animations. ) 
*****
*****
*****
*****
*****
*****
*****
*****
Animation objects :::
Each animation object must have the following:
:play(x, y, z, frame_speed, ent_to_track=nil)     // ent_to_track allows anim object to follow an entity    
:draw()  draws animation
:update(dt)
:isFinished() check if finished animation
:clone() to clone itself
:finish()  to reset fields and mark finish flag
:release() to free it's individual memory
It must have a `.type` field that tells what type it is. (This MUST also be the file name!!!)
]]
local AnimTypes = require("src.misc.animation.types")
--[[
Remember `AnimTypes` holds keyworded references to
"anim objects", not love2d particleSystem objects!!!
]]
-- just quick checking ::::
for type, anim in pairs(AnimTypes) do
    assert(type == anim.type, "Animation.type confliction with filename for anim.\nMake sure the anim .type field has same name as the file!\n( See src.misc.animations.types )")
end
local available_anim_objs = setmetatable(
    {}, {__index = function(t,k) t[k] = {} return t[k] end}
    -- Arrays of available animation objs, keyworded by type
)
local sset = Tools.set
-- Holds all the anim objects that are tracking an entity
local tracking_anim_objs = sset()
local in_use_anim_Z_index = setmetatable(
    -- `k` is the z depth of this in-use anim object
    {}, {__index = function(t,k) t[k] = sset() return t[k] end}
)
-- A SSet of all the animation objects in use.
-- (in_use_anim_Z_index is sorted by Z depth.)
local in_use_anim_objs = Tools.set()
local floor = math.floor
local function getZIndex(y,z)
    return floor((y+z)/2)
end
local function get_anim_obj(type)
    --[[
        gets anim of certain type from the queue of that type.
        (also removes from queue)
    ]]
    local anim
    local availables = available_anim_objs[type]
    if #availables > 0 then
        -- there is an available system to use!
        anim = availables[#availables]
        availables[#availables] = nil
    else
        -- Else we gotta clone.
        anim = AnimTypes[type]:clone()
    end
    return anim
end
local t_insert = table.insert
local WHITE = {1,1,1}
function LinearAnimationSys:animate(anim_type, x, y, z, frame_len, cycles,
                              colour, track_ent, hide_ent)
    if colour and colour.pos then
        -- colours should not have a position! This is an entity instead
        error[[Incorrect signature for ccall('animate'). 
Expected  ccall('animate', x, y, z, frame_len, cycles, colour = WHITE, track_ent = nil, hide_ent = false)]]
    end
    if not AnimTypes[anim_type] then
        error("LinearAnimationSys:animate(type, x,y,z, frame_len, track_ent=nil) ==> Unrecognised anim type ==> "..tostring(anim_type))
    end
    local anim = get_anim_obj(anim_type)
    anim:play(x,y,z, frame_len, cycles, (colour or WHITE), track_ent, (hide_ent or false))
    in_use_anim_objs:add(anim)
    local z_dep 
    if track_ent then
        assert(track_ent.pos, "Track entity not given position. Is this even an entity?")
        ents_being_tracked[track_ent] = anim
        tracking_anim_objs:add(anim)
        z_dep = getZIndex(y + track_ent.pos.y, z + track_ent.pos.z)
    else
        z_dep = getZIndex(y,z)
    end
    anim.z_dep = z_dep
    in_use_anim_Z_index[z_dep]:add(anim)
end
function LinearAnimationSys:drawIndex( z_dep )
    for _, anim in ipairs(in_use_anim_Z_index[z_dep].objects) do
        anim:draw()
    end
end
local function updateEnt(ent, dt)
    local anim = ent.animation
    local interval_tot = anim.interval * anim.animation_len
    local increment =  dt
    if anim.current + increment >= interval_tot then
        anim.current = (anim.current + increment) - interval_tot
        if anim.current >= interval_tot then
            anim.current = 0
        end
    else
        anim.current = anim.current + increment
    end
end
local temp_stack = {}
function LinearAnimationSys:update(dt)
    for _, ent in ipairs(self.group) do
        updateEnt(ent, dt)
    end
    --[===[
        Static update workings here.
        (unrelated to animation component)
    ]===]
    for i, anim in ipairs(in_use_anim_objs.objects) do
        anim:update(dt)
        if anim:isFinished() then
            tracking_anim_objs:remove(anim)
            table.insert(temp_stack, anim)
            in_use_anim_Z_index[anim.z_dep]:remove(anim)
            anim.runtime = 0
            t_insert(available_anim_objs[anim.type], anim)
        end
    end
    for i,a in ipairs(temp_stack) do
        -- Cannot remove from set halfway thru ipairs loop
        in_use_anim_objs:remove(a)
        temp_stack[i] = nil
    end
    assert(#temp_stack == 0,"huh")
    for _, anim in ipairs(tracking_anim_objs.objects) do
        -- For tracking animations that need to track their objects
        in_use_anim_Z_index[anim.z_dep]:remove(anim)
        local new_z_dep
        if (not anim.tracking) then
            --  we're no longer tracking.
            -- (anim_base.lua =>  :removed() btw, smh. horrible code structure)
            table.insert(temp_stack, anim)
            new_z_dep = anim.z_dep --cant afford anything else.
            anim:finish()
        else
            local tpos = anim.tracking.pos
            new_z_dep = getZIndex(anim.y + tpos.y, anim.z + tpos.z)
        end
        anim.z_dep = new_z_dep
        in_use_anim_Z_index[anim.z_dep]:add(anim)
    end
    for i,a in ipairs(temp_stack) do
        -- Cannot remove from set halfway thru ipairs loop
        tracking_anim_objs:remove(a)
        temp_stack[i]=nil
    end
    assert(#temp_stack == 0,"SCUSE ME?????")
end
function LinearAnimationSys:purge()
    --
    -- Releases all memory
    --
    for i,v in ipairs(in_use_anim_objs.objects)do
        in_use_anim_objs.objects[i]:release()
    end
    in_use_anim_objs:clear()
    --[[   Your using `pairs`???
    With this we don't care about JIT breaking. 
    This will only be called once when mass deletions need to happen
    (i.e. world resets)
    ]]
    for k,v in pairs(in_use_anim_Z_index)do
        local ar = in_use_anim_Z_index[k].objects
        for i=1,#ar do
            ar[i]:release( )
        end
        in_use_anim_Z_index[k]:clear()
    end
    tracking_anim_objs:clear()
    for k,v in pairs(available_anim_objs)do
        local ar = available_anim_objs[k]
        for i=1,#ar do
            ar[i]:release()
            ar[i] = nil
        end
    end
end
--[[
System for running animation components that have directional states.
(I.e. player has animations for going up, down, left, right,
so this system is used for exactly that! )
NOTE::  
This system recieved a `Cyan.call("drawEntity", ent)` from DrawSys.
]]
local MotionSys = Cyan.System("motion", "pos", "vel")
local atlas = require 'assets.atlas'
function MotionSys:added(ent)
    local motion = ent.motion
    motion.current_direction = "down"
    motion.animation_len = #motion.up -- gets length of animation
    local len = motion.animation_len
    assert(#motion.up == len, "Inconsistent animation lengths for motion comp")
    assert(#motion.down == len, "Inconsistent animation lengths for motion comp")
    assert(#motion.left == len, "Inconsistent animation lengths for motion comp")
    assert(#motion.right == len, "Inconsistent animation lengths for motion comp")
    assert(motion.current, "ent motion comp not given current var")
    assert(motion.interval, "not given a field")
    assert(motion.required_vel, "not given a field")
    local _,_, w,h = motion.up[1]:getViewport( )
    if not motion.ox then
        motion.ox = w/2
    end
    if not motion.oy then
        motion.oy = h/2
    end
    if motion.sounds then
        motion.sounds.last_index = 1
    end
    ent:add("draw", {
        ox = motion.ox;
        oy = motion.oy;
        w = w;
        h = h
    }) -- tell that its a drawable entity
end
local function updateDirection(ent)
    local motion = ent.motion
    local rvel = motion.required_vel/2
    local dir = motion.current_direction
    if ent.vel.x > rvel then
        dir = "right"
        rvel = ent.vel.x
    elseif ent.vel.x < -rvel then
        dir = "left"
        rvel = -ent.vel.x
    end
    if ent.vel.y > rvel then
        dir = "down"
    elseif ent.vel.y < -rvel then
        dir = "up"
    end
    motion.current_direction = dir
end
local min = math.min
function MotionSys:update( dt )
    for _, ent in ipairs(self.group) do
        local motion = ent.motion
        updateDirection(ent)
        if ent.vel:len() > motion.required_vel then
            -- update the motion state of our entity
            --[[
                Why do we multiply the interval by #?
                The total length of the animation loop is `interval_tot` seconds,
                because the number of frames is 4, and each animation lasts
                0.7 seconds.
            ]]
            local interval_tot = motion.interval * motion.animation_len
            local increment =  dt
            if motion.current + increment >= interval_tot then
                motion.current = (motion.current + increment) - interval_tot
                -- We must check again to account for freak `dt` spikes.
                if motion.current >= interval_tot then
                    motion.current = 0
                end
            else
                motion.current = motion.current + increment
            end
        else
            if motion.sounds then
                motion.sounds.last_index = 1
            end
            motion.current = 0
        end
    end
end
local floor = math.floor
local default_bob =  { scale = 1,  oy=0}
local default_sway = { value = 0,  ox = 0}
local function doSound(ent, index)
    local motion = ent.motion
    local sounds = motion.sounds
    if index ~= sounds.last_index then
        if sounds[index] then
            ccall("sound", sounds[index], sounds.vol,
                            sounds.pitch, sounds.vol_v, sounds.pitch_v)
        end
    end
    sounds.last_index = index
end
local function drawEnt(ent)
    local index
    index = floor(ent.motion.current / ent.motion.interval) + 1 -- lua 1 indexed
    if ent.motion.sounds then
        doSound(ent, index)
    end
    local sway_comp = ent.swaying or default_sway
    local bob_comp = ent.bobbing or default_bob
    local motion = ent.motion
    local draw = ent.draw
    atlas:draw(
            motion[ent.motion.current_direction][index],
            ent.pos.x,
            ent.pos.y - ent.pos.z/2,
            ent.rot,1,
            bob_comp.scale,
            draw.ox + sway_comp.ox,
            draw.oy + bob_comp.oy,
            sway_comp.value
        )
end
function MotionSys:drawEntity( ent )
    if self:has(ent) then
        drawEnt(ent)
    end
end
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
    ent.swaying.ox = 0
    if not ent.swaying.magnitude then
        ent.swaying.magnitude = 5
    end
end
local x = 0
function SwaySys:update(dt)
    x = (x + (dt * speed)) % (2*math.pi)
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
local FollowSys = Cyan.System("follow", "pos")
--[[
follow comp ::
e.follow = {
    following = e;
    distance = 10;   -- Follows 10 units behind `e`.
    onDetatch = function(e)
        -- called when ent detatches from following ent.
        -- (I.e. when following ent gets deleted)
    end
}
]]
local vec3 = math.vec3
local ccall = Cyan.call
local function project(e, other, distance)
    --[[
        projects `e` towards `other` for distance `distance`
    ]]
    local ep = e.pos
    local op = other.pos
    local norm = ((op - ep):normalize() * distance)
    ccall("setPos", e, ep.x + norm.x, ep.y + norm.y, ep.z + norm.z)
end
local er1 = "Ent not following an entity"
local cexists = Cyan.exists
local function update(e,dt)
    local follow = e.follow
    assert(follow.following, er1)
    if not cexists(follow.following) then
        if follow.onDetatch then
            follow.onDetatch(e)
        end
        e:remove("follow")
    else
        local edist = Tools.edist(follow.following, e)
        if edist > follow.distance then
            -- project ents position towards the following ent
            local p = follow.following.pos
            project(e, follow.following, edist - follow.distance)
        end
    end
end
function FollowSys:update(dt)
    for _,e in ipairs(self.group) do
        update(e,dt)
    end
end
--[[
-- To ensure that following ents don't have physics comp.
-- This would REALLY screw things up.
local ErSys = Cyan.System("physics", "follow")
local er2 = "Entities cannot have `physics` and `follow` components!"
function ErSys:added(ent)
    error(er2)
end
]]
local GravitySys = Cyan.System("pos", "vel")
--[[
"Ground level" is level 0
]]
local GRAVITY = CONSTANTS.GRAVITY
function GravitySys:added(ent)
    local pos = ent.pos
    if pos.z > 0.1 then
        ent.grounded = false
    else
        ent.grounded = true
        ent.vel.z = 0
        pos.z = 0
    end
end
local ccall = Cyan.call
local function startDig(ent)
    local d = ent.dig
    ent.hidden = true
    d.digging = true
    if d.onGround then
        d.onGround(ent)
    end
end
local function endDig(ent)
    local d = ent.dig
    d.digging = false
    ent.hidden = false
    if d.onSurface then
        d.onSurface(ent)
    end
end
local max = math.max
local function doDigStuff(ent,dt)
    local vel = ent.vel
    local pos = ent.pos
    local dig = ent.dig
    vel.z = vel.z + GRAVITY*dt*(ent.gravitymod or 1)    
    pos.z = pos.z + vel.z*dt
    if pos.z < (dig.z_min or -1) then
        pos.z = (dig.z_min or -1)
        vel.z = 0 -- hit rock bottom
    end
    if pos.z >= 0 then
        if dig.digging then
            endDig(ent)
        end
        dig.digging = false -- above ground
    else -- pos.z < 0
        if not dig.digging then
            startDig(ent)
        end
        dig.digging = true -- yeah its now digging
    end
end
function GravitySys:update(dt)
    dt = math.min(0.1, dt)
    for _, ent in ipairs(self.group)do
        local vel = ent.vel
        local pos = ent.pos
        if ent.dig then
            doDigStuff(ent,dt)
            goto continue
            -- digging entities are special little beasts
            -- exclude them from main update loop
        end
        if ent.grounded then
            -- ent is on ground, lets ensure that
            pos.z = 0.1
            pos.z = pos.z + (vel.z * dt)
            if pos.z > 0.1 then
                ent.grounded = false
                ccall("airborne", ent)
            end
        else
            -- ent is in the air
            vel.z = vel.z + GRAVITY*dt*(ent.gravitymod or 1)
            pos.z = pos.z + (vel.z * dt)
            if pos.z <= 0 then
                ent.grounded = true
                pos.z = 0.1
                vel.z = 0
                ccall("grounded", ent)
            end
        end
        ::continue::
    end
end
local HealthSys = Cyan.System("hp")
local ccall = Cyan.call
local DEFAULT_IFRAMES = 0 -- default invincibility of 0 seconds
                    -- (Just so we can get lovely chain reaction :booms going :p)
local function checkDead(ent)
    if ent.hp.hp <= 0 then
        ccall("dead", ent)
    end
end
function HealthSys:dead(ent)
    --[[
        NOTE that the entity doesn't need to have HP for this
        callback to come into effect.
    ]]
    if ent.onDeath then
        ent:onDeath()
    end
    ent:delete()
end
HealthSys.kill = HealthSys.dead
function HealthSys:added( ent )
    local hp = ent.hp
    if not hp.regen then -- default 0.
        hp.regen = 0
    end
    if not hp.iframe_count then
        -- invincibility frame counter.  <0 means that the ent isnt invincible.
        hp.iframe_count = -.1
    end
end
--[[
-- Should we do health bars, or will it add too much clutter??
local Atlas = require("assets.atlas")
local mob_hp_bars = {}
for i=1,20 do 
    local mob_hp_bar_str = "mob_hp_"..tostring(i)
    if Atlas.Quads[mob_hp_bar_str] then
        table.insert(mob_hp_bars, Atlas.Quads[mob_hp_bar_str])
    end
end
local getColour, setColour = love.graphics.getColor, love.graphics.setColor
function HealthSys:drawEntity(e)
    if self:has(e) then
        local hp = e.hp
        if hp.draw_hp and hp.hp < hp.max_hp then
            local r,g,b,a = getColour()
            setColour(1,0.2,0.2)
            local ratio = hp.hp / hp.max_hp
            local index = math.ceil((#mob_hp_bars) * ratio)
            local pos = e.pos
            local draw = e.draw
            assert(draw,"??")
            Atlas:draw(mob_hp_bars[index], pos.x, pos.y - pos.z/2,
                        0, 1, 1, draw.ox, draw.oy)
            setColour(r,g,b,a)
        end
    end
end
]]
function HealthSys:damage(ent, amount)
    if self:has(ent) and ent.hp.iframe_count < 0 then
        local hp = ent.hp
        hp.hp = hp.hp - amount
        if ent.onDamage then
            ent:onDamage(amount)
        end
        hp.iframe_count = hp.iframe_count + (hp.iframes or DEFAULT_IFRAMES)
        checkDead(ent)
    end
end
function HealthSys:heal(ent, amount)
    if self:has(ent) then
        local hp = ent.hp
        hp.hp = hp.hp + amount
        checkDead(ent)
    end
end
function HealthSys:hit( ent, hitting_ent, hit_amount )
    if (ent.toughness or 0) < (hitting_ent.toughness or 0) then
        HealthSys:damage( ent, hit_amount )
    end
end
local min = math.min
function HealthSys:update(dt)
    for _, ent in ipairs(self.group )do
        checkDead(ent)
        local hp = ent.hp
        if hp.regen then
            hp.hp = min(hp.max_hp, hp.hp + (hp.regen * dt))
        end
        if hp.iframe_count > 0 then
            hp.iframe_count = hp.iframe_count - dt  -- reduce iframes
        end
    end
end
--[[
had to do it, oh well!
Still got ~ 9 component bits left, and we are nearing polish stage
of development.
This system provides an interface to bridge the gap between OOP and ECS;
effectively, it allows entities to be hybrids between ents/standard objects.
]]
local HybridSys = Cyan.System("hybrid")
function HybridSys:added(ent)
    if ent.onLose then
        -- Add this entity to the onLose callback group
    end
    if ent.onRatioWin then
        -- Add this entity to the onRatioWin callback group
    end
end
function HybridSys:update(dt)
    for _,e in ipairs(self.group)do
        if e.onUpdate then
            e:onUpdate(dt)
        end
    end
end
function HybridSys:heavyupdate(dt)
    for _,e in ipairs(self.group) do
        if e.onHeavyUpdate then
            e:onHeavyUpdate(dt)
        end
    end
end
function HybridSys:drawEntity(e)
    if e.onDraw and e.hybrid then
        e:onDraw()
    end
end
local MoveBehaviourSys = Cyan.System("behaviour", "vel", "pos", "speed")
--[[
Custom `move` params:
]]
local ent_behaviour = { 
    move = {
        type = "LOCKON",
        id = "player",
        radius = 40, -- for ORBIT and TAUNT
            -- how far away they will veer from their target
        wait_time = 3, -- how long the RAND and ROOK waits when switching
        distance = 200, -- how far RAND and ROOK travel (on average)
         -- Fields that are added by system ::::
        -- In the case of LOCKON, ORBIT, TAUNT, target will equal an entity
        target = nil,
        -- whether this ent is waiting to move again (used by ROOK, RAND)
        is_waiting = false,
        -- time spent waiting
        time = 5
    }
}
--[[
]]
--[[
There are a set of possible movement behaviours that can be
defined for entities.
Each type has an 
:init()   called upon initialization (or reset)
:update()
:s_update()    (sparse update)
:h_update()    (heavy update)
All the move types are listed here ::
IDLE -->  DONE
    Stays still
LOCKON -->  DONE
    Chooses closest target ent from group ::
        target = entity
    Moves directly towards closest target entity
    in the group specified
ORBIT -->   DONE
    Chooses closest target ent from group ::
        target = entity
    Moves towards target entity + 20*sin(tick)x + 20*cos(tick)y
    in the group specified. (orbits around ent)
HIVE -->   DONE
    Moves towards center of mass of target group
        target = vec3
SOLO --> 
    Moves away from ent in target group
        target = vec3
RAND -->
    Chooses a random walkable location and goes towards it
        target = vec3
ROOK -->   DONE
    Moves in a (chess) rook-like pattern randomly
        target = vec3
TAUNT -->
    Chooses a target entity from group ::
        target = entity
    Moves towards the target entity, but keeps distance from ent
]]
local DEFAULT_DIST = 400
local MAX_VEL = require("src.misc.partition").MAX_VEL
local rawget = _G.rawget
local dist = Tools.dist
local Cyan = Cyan
local orbit_tick = 0 -- For ORBIT movement behaviour
local sin = math.sin
local cos = math.cos
local set = Tools.set
-- Array of spacial partitions for each target group
local Partitions = require("src.misc.unique.partition_targets") 
-- a hasher { [ent] => set() } 
-- that lists all the entities that are targetting another entity
local TargettedEntities = require("src.misc.behaviour.movebehaviours.targetted_entities")
local NAN_police = "This is the NAN police"
local function updateGotoTarget(ent, pos_x, pos_y, dt)
    local sp = ent.pos
    local d = dist(pos_x - sp.x, pos_y - sp.y)
    if d < 0.1 then -- if d is low, don't bother
        return
    end
    local vx = ((pos_x - sp.x)/d) * ent.speed.speed * dt
    local vy = ((pos_y - sp.y)/d) * ent.speed.speed * dt
    assert(vx == vx, NAN_police)
    assert(vy == vy, NAN_police)
    Cyan.call("addVel", ent, vx, vy)
end
local MoveTypes
--[===[
    local ROOK = {}
    function ROOK:select(distance)
        -- Selects a random cardinal direction
        local mve = e.behaviour.move
        local pos = e.pos
        local r = rand()
        local target = math.vec3(0,0,0)
        local x,y = 0,0
        if r<0.5 then
            x = 0; y = 1;
        else
            y = 0; x=1
        end
        if rand() < 0.5 then
            y = y * -1
            x = x * -1 
        end
        local r = rand()
        target.x = pos.x + x * distance * r
        target.y = pos.y + x * distance * r
        return target 
    end
    function ROOK:init()
        local mve = e.behaviour.move;
        mve.time = 0
        mve.target = nil
        mve.is_waiting = false
    end
    function ROOK:update(dt)
        local move = e.behaviour.move
        if move.is_waiting then
            if move.time >= move.wait then
                move.is_waiting = false
                move.time = 0
            else
                move.time = move.time + dt
            end
        elseif rand() < 0.003 then
            -- Change dir!
            move.target = ROOK.select(e) -- remember, `self` is the entity here.
            move.is_waiting = true
            move.time = move.wait
        else
            -- Keep current dir.
            local pos = e.pos
            local dir = e.behaviour.move.dir
            local target = move.target
            updateGotoTarget(e, target.x, target.y, dt)
        end
    end
    MoveTypes = {
        ORBIT=ORBIT,
        HIVE=HIVE,
        LOCKON=LOCKON,
        IDLE=IDLE,
        ROOK=ROOK,
        RAND=RAND
    }
end
]===]
MoveTypes = {"RAND", "IDLE", "ORBIT", "HIVE", "LOCKON",
            "VECLOCKON","VECORBIT",
            "CLOCKON","CORBIT","SOLO"}
for i,v in ipairs(MoveTypes) do
    MoveTypes[v] = require("src.misc.behaviour.movebehaviours."..v:lower())
    MoveTypes[i] = nil
end
function MoveBehaviourSys:added( ent )
    if not ent.behaviour.move then 
        ent.behaviour.move = { type="IDLE" }
    elseif not ent.behaviour.move.type then
        ent.behaviour.move.type = "IDLE"
    end
end
function MoveBehaviourSys:setMoveBehaviour(ent, newState, newID)
    -- newID: optional argument. will stay same unless otherwise specified.
    if not MoveBehaviourSys:has(ent) then
        error("attempted to change move behaviour of entity not in MoveBehaviourSys")
    end
    local move = ent.behaviour.move
    local shouldInit = ((move.type ~= newState) or (newID ~= move.id))
    move.type = newState
    move.id = (newID or move.id)
    if shouldInit then
        local type = MoveTypes[move.type]
        assert(type, "? undefined moveBehaviour: " .. tostring(move.type))
        move.initialized = false
    end
end
--[[
-- DEBUG ONLY!!!!
function MoveBehaviourSys:drawEntity(e)
    if self:has(e) then
        love.graphics.print(e.behaviour.move.type, e.pos.x, e.pos.y)
    end
end
]]
local isOnScreen = Tools.isOnScreen -- sig: ( e, cam )
local camera = require("src.misc.unique.camera")
function MoveBehaviourSys:update(dt)
    orbit_tick = orbit_tick + dt
    for _,e in ipairs(self.group) do
        if isOnScreen(e, camera) then
            local move = e.behaviour.move
            if move then
                local move_type = MoveTypes[e.behaviour.move.type]
                if move_type.update then
                    -- some moveBehaviours may not have :update
                    move_type:update(e,dt)
                end
            end
        end
    end
end
local function h_update(ent,dt)
    local move = ent.behaviour.move
    if MoveTypes[move.type].h_update then
        MoveTypes[move.type]:h_update(ent,dt)
    end
end
function MoveBehaviourSys:heavyupdate(dt)
    for _, ent in ipairs(self.group)do
        if isOnScreen(ent, camera) then
            h_update(ent,dt)
        end
    end
end
local TargetSys = Cyan.System("targetID", "pos")
local set = Tools.set
local valid_targetIDs--[[ = {
    player    =true,
    enemy     =true,
    physics   =true,
    neutral   =true,
    coin      =true,
    interact  =true
}]]
valid_targetIDs = {}
for _,t_group in ipairs(CONSTANTS.TARGET_GROUPS) do
    valid_targetIDs[t_group] = true
end
local er1 = "Target component is not valid:  "
function TargetSys:added(ent)
    if not valid_targetIDs[ent.targetID] then
        error(er1 .. tostring(ent.targetID))
    end
    Partitions[ent.targetID]:add(ent) -- Adds to the correct spatial partition
end
local partition_keys = {}
for t_id, _ in pairs(Partitions) do
    table.insert(partition_keys, t_id)
end
function TargetSys:update(dt)
    local partition
    for _, p_key in ipairs(partition_keys) do
        partition = Partitions[p_key]
        partition:update(dt)
    end
end
function TargetSys:_setPos(ent,x,y)
    --[[
        Why the underscore?  See MoveSys:setPos(e, x, y).
            (This is a private callback)
        reasoning:
        direct ent position must be set AFTER all the setPosition calls go through,
        for every partition, or else the ent position will be too volatile PartitionSys
        to find.
    ]]
    if ent.targetID then
        Partitions[ent.targetID]:setPosition(ent,x,y)
    end
end
function TargetSys:removed(ent)
    Partitions[ent.targetID]:remove(ent)
    if rawget(TargettedEntities, ent) then
        -- This means we still got entities targetting this ent,
        -- So we must re-initialize all the entities that were targetting
        -- this ent.
        for _, e in ipairs(TargettedEntities[ent].objects) do
            local move = e.behaviour.move
            move.initialized = false
            --MoveTypes[move.type]:init(e)  -- We shouldn't call :init directly like this!
            TargettedEntities[ent]:remove(e)
        end
        rawset(TargettedEntities, ent, nil)
    end
end
local MoveSys = Cyan.System("vel", "pos")
--[[
Handles velocities and max velocities.
]]
local partition = require("src.misc.partition")
local MAX_VEL = CONSTANTS.MAX_VEL
local PHYSICS_LINEAR_DAMPING = CONSTANTS.PHYSICS_LINEAR_DAMPING
local DAMP_AMOUNT = 1-PHYSICS_LINEAR_DAMPING
local min=math.min
local dist = Tools.dist
local vec3 = math.vec3
local dist = Tools.dist
local function updateVelo(ent, dt)
    local max_vel = MAX_VEL
    if ent.speed then
        max_vel = ent.speed.max_speed or MAX_VEL
        max_vel = min(MAX_VEL, max_vel)
    end
    if ent.physics then
        local body = ent.physics.body
        if body:isDestroyed() then
            Tools.dump(ent, "body was destroyed: \n")
        end
        local vx, vy = body:getLinearVelocity()
        if dist(vx, vy) > max_vel then
            -- Set vector velocity to vx, vy
            local vec = vec3(vx,vy, 0):normalize() * max_vel
            vx, vy = vec.x, vec.y
            body:setLinearVelocity(vx, vy)
        end
        ent.vel.x = vx
        ent.vel.y = vy
        ent.pos.x = body:getX()
        ent.pos.y = body:getY()
    else
        local len = ent.vel:len()
        if ent.acc then
            ent.vel = ent.vel + ent.acc
        end
        if len > max_vel then
            ent.vel = ent.vel:normalize() * max_vel
        end
        local p = ent.pos
        p.x = p.x + ent.vel.x * dt
        p.y = p.y + ent.vel.y * dt
    end
end
function MoveSys:update(dt)
    for _, ent in ipairs(self.group) do
        updateVelo(ent,dt)
    end
end
local er_missing_pos = "cannot set position of ent that has no position"
local ccall = Cyan.call
function MoveSys:setPos(e, x, y, z)
    assert(x==x, "Nan found x")
    assert(y==y, "Nan found y")
    assert(z==z, "Nan found z")
    assert(e.pos, er_missing_pos)
    ccall("_setPos", e,x,y) -- This is BADD!! I hate this. I dont see a cleaner way tho.
                            -- order must be respected, else the partitions will goof up
    e.pos.x = x
    e.pos.y = y
    e.pos.z = z or e.pos.z
end
local st = "Target entity requires a velocity component!"
local cexists = Cyan.exists
function MoveSys:addVel(ent, dx, dy)
    if (not (dx==dx)) or (not (dy==dy)) then
        Tools.dump(ent, "attempeted to give this ent a NaN velocity")
        error("gave ent nan velocity")
    end
    assert(ent.vel, st)
    if not cexists(ent) then
        return
    end
    if ent.physics then
        local vx, vy = ent.physics.body:getLinearVelocity( )
                -- Ratio to constrict fast moving entities fairly:::
        --[[
            0.1 :::: slow object - do not constrict (much)
            0.9 :::: fast object - probably should constrict
        ]]
                -- OLD:
                --         local ratio = min(dist(vx+dx, vy+dy) / MAX_VEL, 1)
        local max_vel = MAX_VEL
        if ent.speed then
            max_vel = min(ent.speed.max_speed or MAX_VEL, MAX_VEL)
        end
        assert(max_vel ~= 0, "ur gonna get a NaN here man")
        local ratio = min(dist(vx, vy) / max_vel, 1)
        -- Cube the ratio to be more easy on slow moving objs:
        ratio = ratio * ratio * ratio
        local modifier = 1 - ratio
        ent.physics.body:applyLinearImpulse(dx * modifier, dy * modifier)
        ent.vel.x = vx
        ent.vel.y = vy
    else
        local vx, vy = ent.vel.x, ent.vel.y
        ent.vel.x = vx + dx
        ent.vel.y = vy + dy
    end
end
function MoveSys:setVel(ent, dx, dy)
    assert(ent.vel, st)
    if not cexists(ent) then
        return
    end
    if ent.physics then
        local max_vel
        if ent.speed then
            max_vel = min(ent.speed.max_speed or MAX_VEL, MAX_VEL)
        else
            max_vel = MAX_VEL
        end
        local dist_ = dist(dx,dy)
        if dist_ ~= 0 then
            if dist_ > max_vel then
                dx = (dx / dist_) * max_vel
                dy = (dy / dist_) * max_vel
            end
            ent.physics.body:setLinearVelocity(dx, dy)
        end
        --else
            --ent.physics.body:applyLinearImpulse(dx /3 , dy /3)
    else
        ent.vel.x = dx
        ent.vel.y = dy
    end
end
--[===[
local function updateVelo(ent,dt)
    local max_vel = MAX_VEL
    if ent.speed then
        max_vel = ent.speed.max_speed or MAX_VEL
        max_vel = min(MAX_VEL, max_vel)
    end
    if ent.acc then
        ent.vel = ent.vel + ent.acc
    end
    local len = ent.vel:len()
    if len > max_vel then
        ent.vel = ent.vel:normalize() * max_vel
    end
    if not ent.physics then
        local reduction = 0
        if len > 0 then
            -- The reduction this entity will recieve in velocity
            --reduction = min(len/max_vel, 1)
            reduction = 0.02
            -- Now, actually make it a reduction:
            reduction = 1 - reduction
            -- be harsher on slow moving entities
            reduction = reduction
        end
        ent.pos = ent.pos + ent.vel
        ent.vel = ent.vel * reduction
    else
        local v = ent.vel
        local body = ent.physics.body
        body:setLinearVelocity(v.x, v.y)
        ent.vel = ent.vel
        ent.pos.x = body:getX()
        ent.pos.y = body:getY()
    end
end
]===]
local PartitionSys = Cyan.System("pos")  --, "vel" )
                            -- This is dumb!!! Grass should not be looped over
                            -- when doing a `:moob` or `:boom` callback.
local partition = require("src.misc.partition")
function PartitionSys:added(ent)
    partition:add( ent )
end
function PartitionSys:_setPos(ent, x, y)
    --[[
        Why the underscore?  See MoveSys:setPos(e, x, y).
            (This is a private callback)
        reasoning:
        direct ent position must be set AFTER all the setPosition calls go through,
        for every partition, or else the ent position will be too volatile for other
        partitions to find
    ]]
    partition:setPosition(ent,x,y)
end
function PartitionSys:removed( ent )
    partition:remove( ent )
end
function PartitionSys:update(dt)
    partition:update()
end
local PhysicsSys = Cyan.System("physics", "pos")
--[[
Handles all entities that require physics in the game.
If an object is in this system, the `vel` component and `pos`
component is read-only.
]]
local World
local vec3 = math.vec3
local ccall = Cyan.call
-- keeps ref
local fixture_to_ent = setmetatable({}, {__mode = "kv"})
-- function to init new ents
local initNewEntities
local init_set = Tools.set()
local function beginContact(fixture_A, fixture_B, contact_obj)
    local ent_A = fixture_to_ent[fixture_A]
    local ent_B = fixture_to_ent[fixture_B]
    -- Magnitude of collision
    local speed = ((ent_A.vel or vec3()) + (ent_B.vel or vec3())):len()
    if ent_A.collisions then
        ccall("collide", ent_A, ent_B, speed)
    end
    if ent_B.collisions then
        -- Note that two calls are made here...
        ccall("collide", ent_B, ent_A, speed)
    end
    if ent_A.toughness then
        if ent_A.toughness < speed then
            ccall("hit", ent_A, ent_B, ent_A.toughness - speed)
        end
    end
    if ent_B.toughness then
        if ent_B.toughness < speed then
            ccall("hit", ent_B, ent_A, ent_B.toughness - speed)
        end
    end
end
function PhysicsSys:boxquery(x, y, callback)
    --[[
        Calls `callback` for each fixture in relative `x` `y` range.
    ]]
    World:queryBoundingBox(x, y, x+0.01, y+0.01, callback)
end
function PhysicsSys:rayquery(x,y,x1,y1,callback)
    World:rayCast(x,y,x1,y1,callback)
end
function PhysicsSys:purge()
    if World then
        World:destroy()
    end
    World = love.physics.newWorld(0,0)
    World:setCallbacks(beginContact, nil, nil, nil)
end
function PhysicsSys:newWorld(world)
    if not World then
        World = love.physics.newWorld(0,0)
        World:setCallbacks(beginContact, nil, nil, nil)
    end
end
-- TODO :: setGroupIndex is not working as it should, I don't think
    -- I am using it properly.
function PhysicsSys:grounded(ent)
    if self:has(ent) then
        --ent.physics.fixture:setGroupIndex(0)
    end
end
-- TODO :: setGroupIndex is not working as it should, I don't think
    -- I am using it properly.
function PhysicsSys:airborne(ent)
    if self:has(ent) then
        --ent.physics.fixture:setGroupIndex(1)
    end
end
function PhysicsSys:update(dt)
    World:update(dt) 
end
function PhysicsSys:setPos(ent, x, y)
    if self:has(ent) then
        local body = ent.physics.body
        body:setX(x)
        body:setY(y)
    end
end
local Camera = require("src.misc.unique.camera")
local isOnScreen = Tools.isOnScreen
function PhysicsSys:heavyupdate(dt)
    for _,e in ipairs(self.group) do
        local body = e.physics.body
        local isAwake = body:isAwake()
        local within = isOnScreen(e, Camera)
        if within then
            local body = e.physics.body
            body:setActive(true) -- Is in range so wake up
        else
            body:setActive(false)
        end
    end
end
local function initialize(ent)
    local body_str = ent.physics.body
    ent.physics.body = love.physics.newBody(
        World, ent.pos.x, ent.pos.y, body_str
    )
    if body_str == "static" and ent.vel then
        error("Entity physics body assigned static, but has velocity component")
    end
    if body_str == "dynamic" or body_str == "kinematic" then
        ent.physics.body:setLinearVelocity(ent.vel.x, ent.vel.y)
    end
    ent.physics.body:setLinearDamping(CONSTANTS.PHYSICS_LINEAR_DAMPING)
    ent.physics.fixture = love.physics.newFixture(
        ent.physics.body,
        ent.physics.shape
    )
    if ent.physics.friction then
        ent.physics.body:setLinearDamping(ent.physics.friction)
    end
    fixture_to_ent[ent.physics.fixture] = ent
end
local er1 = [[
Attempted to construct ent when physics world was locked.
This kinda sucks; there is no good solution.
The best thing to do is `ccall("await", 0, entCtor)` so the ent will be constructed the next frame.
Sorry, this really does suck :(
]]
function PhysicsSys:added(ent)
    --[[
        will be in form:
        ent.physics = {
            shape = love.physics.newShape( )
            body = "kinetic"
        }
    ]]
    if World:isLocked( ) then 
        error(er1)  
    end
    initialize(ent)
end
function PhysicsSys:removed(ent)
    fixture_to_ent[ent.physics.fixture] = nil
    if not ent.physics.fixture:isDestroyed() then
        ent.physics.fixture:destroy()
    end
    if not ent.physics.body:isDestroyed() then
        ent.physics.body:destroy()
    end
    -- Dont need to destroy the shape, 
    -- as it is shared between all ent instances.
end
local PushSys = Cyan.System("pushing")
--[[
A system that handles the pushing of entities.
    (Note: This system holds entities that are *doing* the pushing.)
]]
local partition = require "src.misc.partition"
local dist = Tools.dist
local MAX_VEL = partition.MAX_VEL
local ccall = Cyan.call
local dot = math.dot
local er1 = "Attempted to push an unpushable entity. Silly idea brother"
function PushSys:added(ent)
    --[[
        Starts Pushing the closest entity to the pushing entity.
    ]]
    if not ent.pushing.pushable then
        error(er1)
    end
    assert(ent.vel, "Unmoving ent attempted to push moving ent")
    -- FUTURE OLI HERE: THANKKKK YOU FOR DOING THIS ASSERTION. DO MORE OF THESE
    assert(ent.pushing.vel, "Unmoving ent attempted to be pushed")
    ccall("startPush", ent, ent.pushing)
end
function PushSys:removed(ent)
end
function PushSys:update(dt)
    for _, e in ipairs(self.group) do
        local push_ent = e.pushing
        if Cyan.exists(push_ent) then
            local range
            if e.size then
                range = e.size*5
            else
                range = 25 -- default range
            end
            local epos = e.pos
            local ppos = push_ent.pos
            local dx, dy
            dx = ppos.x - epos.x
            dy = ppos.y - epos.y
            local vx,vy
            vx = e.vel.x
            vy = e.vel.y
            local norm_offset = math.vec3(vx,vy,0):normalize()
            local ox = range * norm_offset.x
            local oy = range * norm_offset.y
            ccall("setVel", push_ent, vx, vy)
            ccall("setPos", push_ent, epos.x + ox, epos.y + oy)
        else
            -- The ent being pushed has been deleted mid-push! AH!!
            -- quick, lets kill it before any shenanigans come about.
            e:remove("pushing")
        end
    end
end
--[[
====
====
All events after this point are static
====
====
]]
local AVERAGE_DT = CONSTANTS.AVERAGE_DT
local partition_targets = require("src.misc.unique.partition_targets")
local function getNormalizedBias(bX, bY, eX, eY, bias_group, bias_angle)
    --[[
        With :boom callbacks, entities can be biased to hit other ents
        of other target groups.
        This function gives a normalized corrected vector in the event
        that a :boom callback has a bias. (according to bias_group and 
        bias_angle)
    ]]
    local dot_value = math.cos(bias_angle or 0.5)
    local potentials = { } -- a list of potential entities this
                           -- obj could bias towards.
                           -- (It will bias towards the closest though.)
    local boom_to_obj = math.vec3(eX - bX, eY - bY, 0):normalize( )
    for e in partition_targets[bias_group]:iter(eX, eY) do
        local x,y = e.pos.x, e.pos.y
        if x ~= eX and y ~= eY then
            -- checking that we aren't comparing an ent to itself!!
            local obj_to_target = math.vec3(x - eX, y - eY, 0):normalize( )
            if obj_to_target:dot(boom_to_obj) > dot_value then
                table.insert(potentials, e)
            end
        end
    end
    -- Now select closest entity from all candidates
    local min_dist = math.huge
    local closest_ent
    for _, e in ipairs(potentials)do
        local distance = Tools.dist(e.pos.x - eX, e.pos.y - eY)
        if distance < min_dist then
            closest_ent = e
            min_dist = distance
        end
    end
    local ret
    if not closest_ent then
        -- darn, no ent found.
        ret = math.vec3(eX-bX, eY-bY, 0):normalize( )
    else
        local closest_pos = closest_ent.pos
        ret = math.vec3(closest_pos.x - eX, closest_pos.y - eY, 0):normalize( )
    end
    return ret
end
local max = math.max
function PushSys:boom(x, y, strength, distance, 
                        vx, vy, bias_group, bias_angle) -- optional arguments.
    --[[
        Pushes all entities from a point away.
        bias_group :: entities hit will bias 30 degrees towards ents
            in this bias group.
        bias_angle :: the maximum angle that the ents will bias towards.
    ]]
    local this_strength
    for ent in partition:longiter(x, y) do
        if ent.onBoom then
            ent:onBoom(x,y,strength)
        end
        local eX, eY = ent.pos.x, ent.pos.y
                                         -- ugh! I hate this.
        if ent.vel and ent.pushable and (not (eX == x and eY == y)) then
            -- If x and y position of ent is same as boom position:
                -- Dont apply the force. This entity is (probably)
                -- the entity that enacted the force.
            local e_dis = dist(x-eX, y-eY)
            e_dis = max(e_dis, 1) -- minimum of 1 distance (no Nans)
            this_strength = (strength*AVERAGE_DT*100) / e_dis;
            -- will only push entities a certain distance away
            if (e_dis < distance) then
                local X = eX-x
                local Y = eY-y
                if bias_group then
                    -- bias_vector will point towards the corrected position
                    -- (i.e. will target the targetgroup properly)
                    local bias_vector = getNormalizedBias(
                        x, y,
                        eX, eY,
                        bias_group, bias_angle
                    )
                    X = bias_vector.x * e_dis -- bias_vector is normalized, remember.
                    Y = bias_vector.y * e_dis
                end
                ccall("addVel", ent, X * this_strength + (vx or 0),
                                     Y * this_strength + (vy or 0))
                ccall("animate", "shock", 0, 0, 50, 0.02, nil, nil, ent)
                -- Push the entities away according to `strength` and distance.
            end
        end
    end
end
local rand = love.math.random
function PushSys:moob(x, y, strength, distance)
    --[[
        reverse of boom
        Pulls all entities from a point towards itself
    ]]
    local this_strength
    for ent in partition:longiter(x, y) do
        local eX, eY = ent.pos.x, ent.pos.y
        if ent.onBoom then
            -- is negative, because this is `moob` callback
            ent:onBoom(x,y,-strength)
        end
        if ent.vel and ent.pushable and (eX ~= x and eY ~= y) then
            -- If x and y position of ent is same as boom position:
                -- Dont apply the force. This entity is (probably)
                -- the entity that enacted the force.
            local e_dis = dist(x-eX, y-eY)
            this_strength = (AVERAGE_DT*strength*90) / e_dis;
            -- Will only push entities a certain distance away
            if e_dis < distance then
                Cyan.call("addVel", ent,
                ((x-eX)*this_strength),
                (y-eY)*this_strength)
                -- Push the entities away according to `strength` and distance.
                -- Add Z velocity to bounce em up.
                ent.vel.z = rand(100,300)
            end
        end
    end
end
local RotSys = Cyan.System("rot")
function RotSys:update(dt)
    for _,e in ipairs(self.group) do
        if e.avel then
            e.rot = (e.rot + e.avel) % (2*math.pi)
        end
    end
end
--[[
Handles abstract events that don't really belong to any other system,
or events that other Systems use.
]]
local AbstractSys = Cyan.System()
local Partition = require("src.misc.partition")
local PartitionTargets = require("src.misc.unique.partition_targets")
local er1 = "Invalid targetID"
function AbstractSys:apply(effect, x, y, targetID)
    --[[
        Applys `effect` function to all entities within
        relative range of `x` and `y`.
    ]]
    if targetID then
        assert(PartitionTargets[targetID], er1)
        for ent in PartitionTargets[targetID]:iter(x,y)do
            effect(ent, x, y)
        end
    else
        for ent in Partition:iter(x,y)do
            effect(ent, x, y)
        end
    end
end
local times = Tools.set()
--[[
Each `time` object is represented as a table:
{
    func = func -- The func is constructed with varargs saved as a closure (bad but oh well)
    time = time
}
]]
function AbstractSys:await(func, time, ...)
    --[[
    Im kinda using this callback a lot. Maybe I should stop
        being so damn reliant on it
    ]]
    local args={...}
    if CONSTANTS.DEBUG then
        assert(#args<7,"sorry, you broke the arg cap on ccall('await'). \nExtend the arg number in AbstractSys.")
    end
    times:add({
        args = args;
        func = func;
        time = time
    })
end
function AbstractSys:update(dt)
    for _,timeObj in ipairs(times.objects) do
        timeObj.runtime = timeObj.runtime or 0
        timeObj.runtime = timeObj.runtime + dt
        if timeObj.runtime > timeObj.time then
            local args = timeObj.args
            -- unpack isnt JIT'd
            timeObj.func(args[1],args[2],args[3],args[4],args[5],args[6],args[7])
            for i=1, #timeObj.args do
                timeObj.args[i] = nil -- cut GC some slack
            end
            timeObj.args=nil
            times:remove(timeObj)
        end
    end
end
function AbstractSys:purge()
    times:clear()
end
local BulletSys = Cyan.System( )
local Ents = require("src.entities")
local ccall = Cyan.call
function BulletSys:shoot(x, y, vx, vy)
    local b = Ents.bullet(x,y)
    ccall("setVel", b, vx, vy)
end
function BulletSys:shootbolt(x, y, vx, vy)
    local b = Ents.bolt(x, y)
    ccall("setVel", b, vx, vy)
end
--[[
Stores data across playthroughs
]]
local SaveDataSys = Cyan.System( )
local json = require("libs.NM_json.json")
local data = require("src.misc.unique.savedata")
--[[
Ensure saveData is up to data
]]
for k,v in pairs(CONSTANTS.SAVE_DATA_DEFAULT) do -- This is the default save data state
    if not data[k] then
       data[k] = v
    end
end
function SaveDataSys:quit()
    local tokens = CONSTANTS.tokens
    love.filesystem.write(CONSTANTS.SAVE_DATA_FNAME, json.encode(data))
end
function SaveDataSys:update()
end
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
local GenSys = Cyan.System( )
local DEFAULT_WALL_THRESHOLD = 0.7-- Noise (0->1) must be >=0.8 to form a wall
-- Noise must be 0.1 lower than the DEFAULT_WALL_THRESHOLD in order
-- to spawn an object on this location.
-- This is done so objects don't spawn right next to walls.
local DEFAULT_EDGE_THRESHOLD = 0.2
-- Frequency modifier of noise. 
local FREQUENCY = 1.2
local WALL_BORDER_LEN = 6
--[[
World map will be encoded by a 2d array of characters. (strings)
Capital version of any character stands for "spawn multiple."
If brackets are used, that means "spawn everything inside the brackets."
i.e. '(pqe)' means spawn physics object, spiky object, and enemy
.  :  nothing (empty space)
#  :  wall
%  :  An invincible wall
~  :  A decoration entity to be placed outside border
e  :  enemy spawn
r  :  rare enemy spawn
u  :  unique enemy spawn (i.e. crowd control enemy, enemies that are bad solo)
n  :  neutral mob spawn
!  :  Bossfight
$  :  shop (add this at the end)
c  :  coin (add this at the end)
@  :  player spawn
&  :  portal
p  :  physics object
q :  spiky physics object (damages player upon hit)
^  :  decoration area (grass, nice ground texture, etc)
l  :  large immovable structure (basically a solo wall, ie a pillar, tree, giant mushroom)
*  :  collectable artefact / trophy!!
]]
local PROBS = CONSTANTS.PROBS
local weighted_selection = require("libs.tools.weighted_selection")
local default_pick_function = weighted_selection(PROBS)
local rand = love.math.random
-- THESE TWO ARE NOT SAFE TO BE REQUIRED IMMEDIATELY!!! Will trigger creation of premature entities.
-- instead, these are required in :newWorld.
local StructureRules-- = require("src.misc.worldGen.structureGen._StructureGen")
local WorldTypes-- = require("src.misc.worldGen.worldTypes._worldTypes")
local noise = love.math.noise
local function getNoiseHeight(x, y, noise_offset_x, noise_offset_y)
    x,y = x * FREQUENCY, y * FREQUENCY
    local height = (noise((x/16)+noise_offset_x, (y/16)+noise_offset_y) + (noise(x/4+noise_offset_x, y/4+noise_offset_y)/4) +
            (noise((x/8)+noise_offset_x, (y/8)+noise_offset_y)/2)
            ) / 1.4676666   -- Had to normalize, because total noise was not at 0-1
    return height -- Value between 0 - 1.
end
local function getHeight(world, x, y)
    assert(world.heightMap, "world table not given heightmap in worldgen")
    return world.heightMap[x][y]
end
local function getChar(world, x, y, height, pick_function)
    -- height is a number between 0 -> 1
    local wall_threshold = world.wall_threshold or DEFAULT_WALL_THRESHOLD
    local edge_threshold = world.edge_threshold or DEFAULT_EDGE_THRESHOLD
    if height > wall_threshold then
        return "#"
    elseif height < (wall_threshold - edge_threshold) then
        -- could be anything! (within pick function constriction bounds)
        return pick_function()
    else
        return " "
    end
end
--[[
local function charIsAllowed(worldMap, wType, X, Y, c)
    local xcl_z = wType.entExclusionZones
    if not xcl_z[c] then
        return true
    end
    for ent_c, radius in pairs(xcl_z[c]) do
        -- (Square radius btw, not a circle!)
        for x= -radius, radius do
            if x+X > #worldMap then
                -- Passes because all other checks are out of bounds
                return true 
            end
            for y= -radius, radius do
                if y+Y > #worldMap[1] then
                    -- Passes onto next X iteration
                    goto skip
                end
                if worldMap[X+x] then
                    if worldMap[X+x][Y+y] == ent_c then
                        return false
                    end
                end
                -- TODO :
                -- im like 90% sure this ::skip:: is in the wrong place,
                -- but its been so long since i worked on this code
                ::skip::
            end
        end
    end
    return true -- Yay, is allowed. Now lets test this mofo.
end
]]
local function structureFits(worldMap, structure, wX, wY)
    --[[
        returns true if structure fits at x,y
        false otherwise.
    ]]
    local pattern = structure[1]
    for x = 1, #(pattern[1]) do
        for y = 1, #pattern do
            local chr = pattern[y]:sub(x,x)
            if chr == "?" then
                if (worldMap[wX + x][wY + y] == "#") then
                    return false
                end
            elseif not(chr == worldMap[wX + (x - 1)][wY + (y - 1)]) then
                return false
            end
        end
    end
    -- All characters have been checked- return true, buckeroo.
    return true
end
local function isSurroundedByWalls(worldMap, X, Y)
    for x = X-1,X+1 do 
        for y = Y-1, Y+1 do
            if not(x == X and y == Y) then
                if worldMap[x][y] ~= "#" and worldMap[x][y] ~= "%" then
                    -- hits a non-wall! ret false
                    return false
                end
            end
        end
    end
    -- Makes it all the way without break condition
    return true
end
local function genStructures(world)
    local worldMap = world.worldMap
    local structureRule = world.structureRule
    local amount = love.math.random( structureRule.min_structures, structureRule.max_structures )
    local rand_x
    local rand_y
    for i = 1, amount do 
        local structure = structureRule.random()
        -- structure size on the X
        local sX = #(structure[1][1])
        -- structure size on the Y
        local sY = #(structure[1])
        --[[
            structure is a table of the form:
            {
                {"???",
                "???",
                "???"},
                {"^^^",
                "^#^",
                "^^^"}
            }
            See _StructureGen.lua for details.
        ]]
        -- Now, try to fit structure in X and Y position.
        for try = 1, structureRule.tries do
            rand_x = love.math.random(2, (#worldMap)-(sX+1))
            -- remember- spaces are ignored during world gen.
            rand_y = love.math.random(2, (#worldMap[1]) - (sY+1))
            if structureFits(worldMap, structure, rand_x, rand_y) then
                local transform = structure[2]
                for x = 1, #transform[1] do
                    for y = 1, #transform do
                        local chr = transform[y]:sub(x,x)
                        if (chr ~= "?") then
                            worldMap[rand_x + x][rand_y + y] = chr
                        end
                    end
                end
            end
        end
    end
end
local worldMap_mt
do
    worldMap_mt =  { -- Just a simple 2d array
        __index = function(t, k)
            t[k] = { } return t[k]
        end
    }
end
--[[
# newWorld  {
#   x = 70    (150 units wide) (1 unit = 64 pixels)   
#   y = 70    (100 units tall)
#   type = "basic" 
#   tier = 1  (1 = easy, 2 = harder, 3 = hardest)
# }
]]
local er_missing_ents = "Missing entities table... what are you, stupid???????!! jk"
local entCounter_mt = {__index = function() return 0 end}
local function makeEnts(world)
    local worldMap = world.worldMap
    local worldType = world.worldType
    assert(worldMap, "world.worldMap does not exist")
    assert(worldType, "world.worldType does not exist")
    local ents = worldType.entities
    assert(ents, er_missing_ents)
    -- Hasher to count the occurance of every single entity.
    -- usage: { ["e"] = 5; }
    local entCounter = setmetatable({} , entCounter_mt) 
    for x=1, #worldMap do
        for y=1, #worldMap[1] do
            local eType = worldMap[x][y]
            if not eType then
                goto skip
            end
            entCounter[eType] = entCounter[eType] + 1
            if not(entCounter[eType] > ents[eType].max) then
                ents[worldMap[x][y]][1](y*64, x*64)
                -- What? you have `(y*64, x*64)` as opposed to `(x*64, y*64)`?
                -- This is because for some reason, the "map matrix" for lack of a better word,
                -- was transposed. 
                -- flipping around X and Y will not do anything in theory, it just
                -- makes menus a lot easier to design
            end
            ::skip::
        end
    end
    entCounter = nil
end
local function makeWalls(world)
    local worldMap = world.worldMap
    local BLEN = WALL_BORDER_LEN
    for _,ar in ipairs(worldMap) do
        for i=1,BLEN do
            table.insert(ar, "~")
            table.insert(ar, 1, "~")
        end
    end
    for i=1,BLEN do
        local q1 = {}
        local q2 = {}
        for i=1, #worldMap[1] do
            table.insert(q1, "~")
            table.insert(q2, "~")
        end
        table.insert(worldMap, 1, q1)
        table.insert(worldMap, q2)
    end
    local xlen = #worldMap
    local ylen = #worldMap[1]
    for xx=BLEN, #worldMap-BLEN do
        worldMap[xx][BLEN] = "%"
        worldMap[xx][ylen-(BLEN)] = "%"  
    end
    for yy=BLEN, #worldMap[1]-BLEN do
        worldMap[BLEN][yy] = "%"
        worldMap[xlen-BLEN][yy] = "%"
    end
end
local function genRequiredStructures(world)
    do
        -- Need to do this function up
        return nil
    end
    local worldMap = world.worldMap
    local structureRule = world.structureRule
    local amount = love.math.random( structureRule.min_structures, structureRule.max_structures )
    local rand_x
    local rand_y
    for i = 1, amount do 
        local structure = structureRule.random()
        -- structure size on the X
        local sX = #(structure[1][1])
        -- structure size on the Y
        local sY = #(structure[1])
        -- Now, try to fit structure in X and Y position.
        for try = 1, structureRule.tries do
            rand_x = love.math.random(2, (#worldMap)-(sX+1))
            -- remember- spaces are ignored during world gen.
            rand_y = love.math.random(2, (#worldMap[1]) - (sY+1))
            if structureFits(worldMap, structure, rand_x, rand_y) then
                local transform = structure[2]
                for x = 1, #transform[1] do
                    for y = 1, #transform do
                        local chr = transform[y]:sub(x,x)
                        if (chr ~= "?") then
                            worldMap[rand_x + x][rand_y + y] = chr
                        end
                    end
                end
            end
        end
    end
end
local function isWall(world, x, y)
    local worldMap = world.worldMap
    return  ((worldMap[x][y] == "%") or (worldMap[x][y] == "#") or (worldMap[x][y]=="~"))
end
local function isGoodFit(world, x, y)
    --[[
        returns whether the position is a fit
        (i.e, whether it is within the bounds of the worldMap,
        AND is greater than noise threshold)
        (AND has no walls next to it)
    ]]
    local is_within_border = (1 < x and x < world.x) and (1 < y and y < world.y)
    if not is_within_border then
        return false -- yeah its scuffed. The other tests gotta be chopped
    end
    for xoff=-1,1 do
        for yoff=-1,1 do
            if isWall(world, x + xoff, y + yoff) then
                return false -- its too close to a wall
            end
        end
    end
    local wall_threshold = world.wall_threshold or DEFAULT_WALL_THRESHOLD
    local edge_threshold = world.edge_threshold or DEFAULT_EDGE_THRESHOLD
    local h = world.heightMap[x][y]
    local good_noise = h < wall_threshold - edge_threshold
    return good_noise and (not isWall(world, x, y))
end
local function addPlayer(world)
    local worldMap = world.worldMap
    local heightMap = world.heightMap
    assert(#worldMap > 16 and #worldMap[1] > 16,
    "worldMap too small, this is too risky to spawn player in reliably.")
    for x = rand(5, 10), #worldMap do
        for y = rand(5, 10), #worldMap[1] do
            if isGoodFit(world, x, y) then
                worldMap[x][y] = "@"
                return x,y
            end
        end
    end
    error("player failed to generate in (this should never happen)")
end
local function findEmpty(world, X, Y)
    local worldMap = world.worldMap
    assert(worldMap, "world.worldMap is nil")
    if not isWall(worldMap, X, Y) then
        return X, Y
    end
    local n = 1
    repeat
        for x = -n, n do
            for y=-n, n do
                if ((y~=0) and (x~=0)) then
                    if (not isWall(worldMap, X+x, Y+y)) then
                        return X+x, Y+y
                    end
                end
            end
        end
        if n > 30 then
            return false -- lookup failed
        end
        n = n + 1
    until false
end
local function findGoodFit(world, X, Y)
    local worldMap = world.worldMap
    local heightMap = world.heightMap
    local worldMap = world.worldMap
    assert(heightMap, "what ??/ world.heightMap is nil ???")
    if isGoodFit(world, X, Y) then
        return X, Y
    end
    local n = 1
    local done = {
        -- 2d hasher with  N = 2*(10000 + x) * 3*(10000 + y)
        -- we offset by 10000 so no collisions with negative numbers
        [2*(10000 + 0) * 3*(10000 + 0)] = true -- This is the hash for 0,0.
        -- We dont want to search 0,0, so we add it to the `done` table
    }
    while 1 do
        for x = -n, n do
            for y=-n, n do
                if not done[2*(10000+x) * 3*(10000+y)] then
                    if (isGoodFit(world, X+x, Y+y)) then
                        return X+x, Y+y
                    end
                    done[2*(10000+x) * 3*(10000+y)] = true
                end
            end
        end
        if n > 30 then -- 30 is max tries
            return false -- lookup failed
        end
        n = n + 1
    end
end
local function addEnemies(world, player_x, player_y)
    --[[
        plan: How is this gonna work???
        Get the amount, sqrt the total enemies, and step across the map
        by each enemy count.
        Place them accordingly.
        Revoke the placement if the position is close to the player
    ]]
    local worldMap = world.worldMap
    local heightMap = world.heightMap
    local worldType = world.worldType
    local dist = Tools.dist
    local amount = worldType.enemies.n + math.floor(0.5+math.sin(6.3*rand()) * (worldType.enemies.n_var or 0))
    local big_amount = worldType.enemies.bign + math.floor(0.5+math.sin(6.3*rand()) * (worldType.enemies.bign_var or 0))
    local size = math.floor(math.sqrt(amount + big_amount))
    assert(size == size, "size is a nan. ohhh.. no")
    local width = #worldMap
    assert(worldMap[1],'wattt????')
    local height = #worldMap[1]
    for x = 1, size do
        for y = 1, size do
            local x_pos = math.floor((x / (size + 1)) * width)
            local y_pos = math.floor((y / (size + 1)) * height)
            local type
            if rand() <= (amount / (big_amount + amount)) then
                -- we choose small `e`.
                type = "e"
                amount = amount - 1
            else
                -- we choose big 'E'.
                type = "E"
                big_amount = big_amount - 1
            end
            x_pos, y_pos = findGoodFit(world, x_pos, y_pos)
            if x_pos and dist(player_x - x_pos, player_y - y_pos) > 4 then
                worldMap[x_pos][y_pos] = type
            end
        end
    end
end
local function procGenerateWorld(world)
    --[[
        generates world from scratch, according to the structureRule
    ]]
    local worldMap = world.worldMap
    local worldType = world.worldType
    assert(world.worldMap, "worldMap not in world table")
    assert(world.worldType, "worldType not in world table")
    local pick_function
    if worldType.probabilities then
        pick_function = weighted_selection(
            worldType.probabilities
        )
    else
        pick_function = default_pick_function
    end
    -- Check this over.
    -- Ensure that noise generation isn't doing anything wanky. If these
    -- offset values are too big, math.noise can yield weird artefacts.
    world.noise_offset_x = love.math.random(-10000, 10000)
    world.noise_offset_y = love.math.random(-10000, 10000)
    local size_x = world.x
    local size_y = world.y
    local heightMap = {}
    for ii = 1, size_x do
        heightMap[ii] = { }
    end
    for X = 1, size_x do
        for Y = 1, size_y do
            local height = getNoiseHeight(X, Y, world.noise_offset_x, world.noise_offset_y)
            heightMap[X][Y] = height
            local c = getChar(world, X, Y, height, pick_function)
            worldMap[X][Y] = c
        end
    end
    world.heightMap = heightMap
    local rule_id = worldType.structureRule
    local structureRule
    if rule_id then
        structureRule = StructureRules[rule_id]
        if not structureRule then
            error("invalid structureRule id :: "..rule_id)
        end
    else
        assert(world.tier, ("worldtype %s did not have a tier"):format(world.type or '<nil type>'))
        local def_id = "default_T" .. tostring(world.tier)
        structureRule = StructureRules[ def_id ]
        if not structureRule then
            error("Default structureRule for tier "..tostring(world.tier).." did not exist")
        end
    end
    world.structureRule = structureRule
    genRequiredStructures(world)
    genStructures(world)
    makeWalls(world)
    local player_x, player_y = addPlayer(world)
    addEnemies(world, player_x, player_y)
    return player_x, player_y
end
local world_type
local world_tier
-- ===>
-- callbacks here
-- ===>
local function getPlayerXY(worldMap)
    for i=1, #worldMap do
        for j=1,#worldMap[i] do
            if worldMap[i][j] == "@" then
                return i,j
            end
        end
    end
end
function GenSys:newWorld(world, worldMap)
    -- These are now safe to be initialized, as we know All systems
    -- will have been initialized
    StructureRules = require("src.misc.worldGen.structureGen._StructureGen")
    WorldTypes = require("src.misc.worldGen.worldTypes._worldTypes")
    local tier = world.tier
    world_tier = tier
    assert(tier, "world type was not given a tier")
    local type = world.type
    world_type = type
    assert(type, "world type was not given a type")
    local worldType = WorldTypes[type][tier]
    world.worldType = worldType
    assert(worldType, "HUH? worldTypes[type][tier] gave nil")
    local player_x, player_y
    if not worldMap then
        worldMap = setmetatable({ }, worldMap_mt)
        world.worldMap = worldMap
        player_x, player_y = procGenerateWorld(world)
    else
        world.worldMap = worldMap
        player_x, player_y = getPlayerXY(worldMap)        
    end
    if WorldTypes[type][tier].construct then
        WorldTypes[type][tier].construct(world, worldMap,
                            player_y * 64, player_x * 64)
                    -- times by 64 to get real world pos
                    -- ALSO, WTF. The x and y are switched. Ahhh, I knew i
                    -- shouldnt have messed with this shit. Now there are
                    -- no excuses, this is literally spagetti code
    end
    makeEnts(world)
    --[[  
    for _,tab in ipairs(worldMap) do
        print(table.concat(tab, " "))
    end
    --]]
end
function GenSys:switchWorld(world, worldMap)
    if world_tier and world_type then
        local oldWType = WorldTypes[world_type][world_tier]
        if oldWType.destruct then
            oldWType.destruct( )
        end
    end
    ccall("purge")
    Cyan.flush()
    ccall("newWorld", world, worldMap)
end
-- Win and lose conditions
do
    local cam = require("src.misc.unique.camera")
    -- lose condition
    function GenSys:lose()
        local cam = require("src.misc.unique.camera")
        if world_tier and world_type then
            local wType = WorldTypes[world_type][world_tier]
            assert(wType.lose, "worldTypes must have a lose condition")
            wType.lose(cam.x, cam.y)
        end
    end
    -- win condition callbacks.
    -- these are pretty much all the same...
    do
        function GenSys:ratioWin()
            local cam = require("src.misc.unique.camera")
            if (not StructureRules) or (not WorldTypes)then
                return -- This means that :newWorld hasnt been called yet.
                -- very bizzare situation... but oh well.
            end
            if world_tier and world_type then
                local worldType = WorldTypes[world_type][world_tier]
                assert(worldType,"?? ")
                if worldType.ratioWin then
                    worldType.ratioWin(cam.x,cam.y)
                end
            end
        end
        function GenSys:voidWin()
            local cam = require("src.misc.unique.camera")
            if (not StructureRules) or (not WorldTypes)then
                return -- This means that :newWorld hasnt been called yet.
                -- very bizzare situation... but oh well.
            end
            if world_tier and world_type then
                local worldType = WorldTypes[world_type][world_tier]
                assert(worldType,"?? ")
                if worldType.voidWin then
                    worldType.voidWin(cam.x,cam.y)
                end
            end 
        end
        function GenSys:bossWin()
            local cam = require("src.misc.unique.camera")
            if (not StructureRules) or (not WorldTypes)then
                return -- This means that :newWorld hasnt been called yet.
                -- very bizzare situation... but oh well.
            end
            if world_tier and world_type then
                local worldType = WorldTypes[world_type][world_tier]
                assert(worldType,"?? ")
                if worldType.bossWin then
                    worldType.bossWin(cam.x,cam.y)
                end
            end 
        end
    end
end
local KeyPressSys = Cyan.System() -- does not take entities.
local SHORT_THRESHOLD = 0.2 -- 0.2 seconds is considered a key tap.
local keydown = {
    -- A table holding whether a key is down or not.
    -- The key will be set to `nil` if it is not pressed.
}
local time_between_press_and_release = {
    -- A table holding the time of a key press (time the key is held)
}
local keyheld_called = {
    -- A table holding whether each key has had `keyheld` called on it.
    -- (To ensure `ccall("keyheld")` isnt done twice for the same key!)
}
function KeyPressSys:update(dt)
    local time
    for key, _ in pairs(keydown) do
        time = time_between_press_and_release[key] or 0
        if keydown[key] then
            if time > SHORT_THRESHOLD then
                keyheld_called[key] = true
                Cyan.call("keyheld", key, time)
            end
            time_between_press_and_release[key] = time + dt
        else
            time_between_press_and_release[key] = 0
        end
    end
end
function KeyPressSys:keypressed(key, scancode, isrepeat)
    keydown[key] = true
    Cyan.call("keydown", key)
end
function KeyPressSys:keyreleased(key, scancode, isrepeat)
    keydown[key] = nil
    keyheld_called[key] = false
    if time_between_press_and_release[key] then
        if time_between_press_and_release[key] < SHORT_THRESHOLD then
            Cyan.call("keytap",  key)
        end
    end
    time_between_press_and_release[key] = nil
    Cyan.call("keyup", key)
end
local LSSys = Cyan.System(
    --[[
This is a system that automatically kills physics objects if there are too
many in a small area.
(Make sure to do `ccall(kill)` as opposed to just deleting, so we get cool
death effects)
    ]]
)
-- spatial partition size
local P_SIZE = CONSTANTS.MAX_VEL * CONSTANTS.MAX_DT
-- the max num of physics objs in a partition bucket
local PHYS_CAP = CONSTANTS.PHYS_CAP 
local Cam = require("src.misc.unique.camera")
local BlockPartition = require("src.misc.unique.partition_targets").physics
function LSSys:sparseupdate(dt)
    for x=-1,1 do
        for y=-1,1 do
            local X, Y = Cam.x + x*P_SIZE, Cam.y + y*P_SIZE
            local len = BlockPartition:size(X,Y)
            if len > PHYS_CAP then
                local ct = 0
                for ent in BlockPartition:iter(X,Y) do
                    if ct >= (len - PHYS_CAP) then
                        break
                    end
                    ct = ct + 1
                    ccall("kill", ent)
                end
            end
        end
    end
end
--[[
System for dynamic emission of particles
this does NOT refer to love2d particleSystem,
but rather a system to handle dynamic creation and
emission of particles from love2d particlesystems
]]
local PSys = Cyan.System()
local DEFAULT_PARTICLES = 40
local ParticleTypes = require("src.misc.particles.types")
--[[
Remember `ParticleTypes` holds keyworded references to
"emitter objects", not love2d particleSystem objects!!!
]]
-- just quick checking ::::
for type, emitter in pairs(ParticleTypes) do
    assert(type == emitter.type, "Emitter.type confliction with filename for emitter.\nMake sure the emitter .type field has same name as the file!\n( See src.misc.particles.types )")
end
local available_emitters = setmetatable(
    {}, {__index = function(t,k) t[k] = {} return t[k] end}
    -- Arrays of available emitters, keyworded by type
)
local sset = Tools.set
local indexed_emitters = setmetatable(
    {}, {__index = function(t,k) t[k] = sset() return t[k] end}
)
local in_use = Tools.set()
local floor = math.floor
local function get_z_index(y,z)
    return floor((y+z)/2)
end
local function get_emitter(type)
    --[[
        gets emitter of certain type from the queue of that type.
        (also removes from queue)
    ]]
    local emitter
    local availables = available_emitters[type]
    if #availables > 0 then
        -- there is an available system to use!
        emitter = availables[#availables]
        availables[#availables] = nil
    else
        -- Else we gotta clone.
        emitter = ParticleTypes[type]:clone()
    end
    return emitter
end
local t_insert = table.insert
local WHITE = { 1,1,1,1 } -- default colour is white
local setColour = love.graphics.setColor
function PSys:emit(type, x,y,z , n_particles, colour) -- default colour white
    n_particles = n_particles or DEFAULT_PARTICLES
    if not ParticleTypes[type] then
        error("PSys:emit(type, x,y, num) ==> Unrecognised emitter type ==> "..tostring(type))
    end
    local emitter = get_emitter(type)
    setColour(colour or WHITE)
    emitter:emit(x,y, n_particles)
    in_use:add(emitter)
    local z_dep = get_z_index(y,z)
    emitter.z_dep = z_dep
    emitter.y = y
    emitter.z = z
    emitter.x = x
    indexed_emitters[z_dep]:add(emitter)
end
function PSys:drawIndex( z_dep )
    for _, emtr in ipairs(indexed_emitters[z_dep].objects) do
        setColour(1,1,1)
        emtr:draw(emtr.x, emtr.y, emtr.z)
    end
end
function PSys:update(dt)
    for i, emitr in ipairs(in_use.objects) do
        emitr:update(dt)
        if emitr:isFinished() then
            in_use:remove(emitr)
            indexed_emitters[emitr.z_dep]:remove(emitr)
            emitr.runtime = 0
            t_insert(available_emitters[emitr.type], emitr)
        end
    end
end
function PSys:purge()
    --
    -- Releases all memory
    --
    for i,v in ipairs(in_use.objects)do
        in_use.objects[i]:release()
    end
    in_use:clear()
    --[[   Your using `pairs`???
    With this we don't care about JIT breaking. 
    This will only be called once when mass deletions need to happen
    ]]
    for k,v in pairs(indexed_emitters)do
        local ar = indexed_emitters[k].objects
        for i=1,#ar do
            ar[i]:release( )
        end
        indexed_emitters[k]:clear()
    end
    for k,v in pairs(available_emitters)do
        local ar = available_emitters[k]
        for i=1,#ar do
            ar[i]:release()
            ar[i] = nil
        end
    end
end
local ShaderSys = Cyan.System()
local setShader = love.graphics.setShader
local shader = require("src.misc.unique.shader")
function ShaderSys:transform()
    setShader(shader)
end
function ShaderSys:untransform()
    setShader()
end
function ShaderSys:update(dt)
    --[[
        The rest of the sent variables can be found in
        LightSys.lua.
    ]]
    shader:send("amount", 0.06)
    shader:send("period", 2)
    shader:send("colourblind", CONSTANTS.COLOURBLIND)
    shader:send("devilblind",  CONSTANTS.DEVILBLIND) -- swaps RG channels
    shader:send("navyblind", CONSTANTS.NAVYBLIND) -- swaps RB 
end
local SoundSys = Cyan.System()
--[[
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
SOUND FILE NAMES MATTER !!!
System in control of sound handling.
Sounds will be automatically grouped together depending on their
filename.
`main` stands for main sounds,
`bg` stands for background sounds.
(background sounds can vary in volume)
usually the main sounds will be the loudest.
For example:
`boom_main1.ogg`, `boom_main2.ogg`, `boom_bg1.ogg`, `boom_bg2.ogg`.
In this scenario, whenever `boom` is envoked,
either main1 or main2 will play, and BOTH bg (background) sounds will be played.
each soundGroup is represented by this:
exampleSoundGroup {
    mainSounds = { };
    backgroundSounds = { }
}
]]
local sounds = require("src.misc.sound")
-- Hasher to each sound group by KW
local soundGroups = { }
local availableSourceClones = {
    -- hasher of:
    --  {  [src] = set()   }
    -- to allow us to play the same sound
    -- multiple times at the same time
}
for k,src in pairs(sounds) do
    if k:find("_") then
        local s = k:find("_")
        local groupName = k:sub(1,s-1)
        assert(groupName:len()>0, "Wtf? started with an _ ?? sound_TREE_push not working")
        -- Construction
        soundGroups[groupName] = soundGroups[groupName] or {
            mainSounds = { };
            backgroundSounds = { }
        }
        availableSourceClones[src] = Tools.set()
        local group = soundGroups[groupName]
        if k:sub(s+1,s+2)=="bg" then
            table.insert(group.backgroundSounds, src)  
        else
            table.insert(group.mainSounds, src)
        end
    end
end
local rand_choice = Tools.rand_choice
local sin = math.sin
local rand = love.math.random
local play = love.audio.play
-- Tables { [src_name] : number }
-- that keep track of the original pitch and volume of sources
local originalVolumes = { } 
local originalPitches = { }
local function getFreeSource(src)
    if not src:isPlaying() then
        return src
    else
        for _, clone in ipairs(availableSourceClones[src].objects) do
            if not clone:isPlaying() then
                return clone
            end
        end
        local newSrcClone = src:clone()
        availableSourceClones[src]:add(newSrcClone)
        return newSrcClone
    end
end
local max = math.max
local min = math.min
local function playSound(src, vol, pitch, vol_v, p_v)
    src = getFreeSource(src)
    vol = min(1, vol + vol_v * sin( rand() * 3.14 )) * CONSTANTS.MASTER_VOLUME
    src:setVolume(vol)
    src:setPitch (pitch + (p_v) * sin(rand()*3.14))
    play( src )
end
function SoundSys:sound(sound, volume, pitch,
                        volume_variance,  pitch_variance)
    --[[
        sound : string
        volume : 0 no sound   ->   1 max vol
        volume_variance : 0.2 => sound vol will vary by 0.2 (default 0)
        pitch_variance  : 0.1 => pitch will vary by 0.1     (default 0)
    ]]
    volume = volume or 1
    pitch = pitch or 1
    volume_variance = volume_variance or 0
    pitch_variance = pitch_variance or 0
    if soundGroups[sound] then
        local group = soundGroups[sound]
        playSound( rand_choice(group.mainSounds), volume, pitch, volume_variance, pitch_variance )
        for _,src in ipairs(group.backgroundSounds) do
            playSound(src, volume, pitch, volume_variance, pitch_variance )
        end
    else
        if not sounds[sound] then
            error("Missing sound : "..sound)
        end
        playSound(sounds[sound], volume, pitch, volume_variance, pitch_variance)
    end
end
--[[
This system deals with the splat effect
seen when there are multiple blocks in an area
Comes with component "splatted"
Question: Is it possible to remove splatted blocks from the physics
partition?
This would make this operation 1000 times faster...
]]
local SPLAT_TIME = 0.2
local SPLAT_TIME_VAR = 0.15
local DEFAULT_SPLAT_DIST = 70
local PartitionTargets = require("src.misc.unique.partition_targets")
local PhysPartition = PartitionTargets.physics
assert(PhysPartition, "problem, housten")
local dist = Tools.dist
local ccall = Cyan.call
local SPLAT_COLOUR = CONSTANTS.SPLAT_COLOUR-- Change this if you want
local SplatSys = Cyan.System()
local function endSplat(ent)
    -- TODO: play a sound here
    ccall("emit", "splat", ent.pos.x, ent.pos.y, ent.pos.z, 16)
    ccall("splat", ent.pos.x, ent.pos.y, nil)
    ccall("kill",ent)
end
local rand = love.math.random
local WHITE = {1,1,1,1}
local function splat(ent)
    -- splats an ent
    if ent.physicsImmune then
        -- its already been splatted, or is immune
        return
    end
    ent.physicsImmune = true
    ent:remove("targetID") -- this physics obj is gonna die anyway.
    -- we can save some time in the loop by removing from phys partition
    -- TODO: play a sound here too
    local colour = ent.colour or WHITE
    ent.colour = {colour[1] * SPLAT_COLOUR[1],
                  colour[2] * SPLAT_COLOUR[2],
                  colour[3] * SPLAT_COLOUR[3]}
    ccall("await", endSplat, SPLAT_TIME + (rand()-0.5)*SPLAT_TIME_VAR, ent)
end
function SplatSys:splat(x,y, range)
    range = range or DEFAULT_SPLAT_DIST
    local ct = 0
    for ent in PhysPartition:iter(x,y)do
        local pos = ent.pos
        if (pos.y ~= y) and (pos.x ~= x) then
            -- it has infected one entity
            if dist(x - pos.x, y - pos.y) < range then
                ct = ct + 1
                splat(ent)
            end
        end
    end
    if ct > 0 then
        ccall("shockwave", x, y, 0, range * 1.5, 8, 0.14,
            {SPLAT_COLOUR[1],
            SPLAT_COLOUR[2],
            SPLAT_COLOUR[3]})
    end
end
local TextSys = Cyan.System("text", "pos")
--[[
static system responsible for spawning block text ents
]]
local LETTER_WIDTH = 28
local newText = love.graphics.newText
local lgdraw = love.graphics.draw
local floor = math.floor
local FONT = require("src.misc.unique.font")
function TextSys:added(ent)
    assert(type(ent.text) == "string", "ent.text has gotta be type string")
    -- Remember what the initial text was, so we can change it
    ent._old_text = ent.text
    ent._textObj = newText(FONT, ent.text)
    ent.rot = 0
    if not ent.draw then
        local ox2, oy2 = ent._textObj:getDimensions( )
        ent:add("draw",{
            ox = ox2/2;
            oy = oy2/2
        })
    end
end
local cam = require("src.misc.unique.camera")
local function supdate(ent)
    if ent.text ~= ent._old_text then
        -- oh damn, its been re-initialized.
        -- make new text Obj
        ent._old_text = ent.text
        ent._textObj:release()
        ent._textObj = newText(FONT, ent.text)
        local ox2, oy2 = ent._textObj:getDimensions( )
        ent.draw = {
            ox = ox2/2;
            oy = oy2/2
        }
    end
end
local default_bob = {value = 1, magnitude = 0, oy = 0}
local default_sway = {value = 0, magnitude = 0, ox = 0}
function TextSys:drawEntity(ent)
    if ent._textObj then
        local pos = ent.pos
        local bob_comp = ent.bobbing or default_bob
        local sway_comp = ent.swaying or default_sway
        local draw = ent.draw
        lgdraw(
            ent._textObj,
            floor(pos.x), floor(pos.y - pos.z/2),
            ent.rot or 0, 1,
            bob_comp.scale,
            draw.ox + sway_comp.ox, 
            draw.oy + bob_comp.oy,
            sway_comp.value
        )
    end
end
function TextSys:sparseupdate(dt)
    for _, e in ipairs(self.group)do
        supdate(e)
    end
end
function TextSys:spawnText(x,y,str, height, height_variance)
    --[[
        Spawns block letter text (physics blocks)
    ]]
    height = height or 0
    height_variance = height_variance or 0
    local c
    local rand = love.math.random
    local x_off = str:len() * (-LETTER_WIDTH/2)
    -- size of letters is 32, we offset by string len * -32/2
    str = str:lower() -- No caps
    for i = 1, str:len() do
        c = str:sub(i,i)
        assert(c,"?")
        if c ~= " " then
            local letter_ctor = EH.Ents["letter_"..tostring(c)]
            if not(letter_ctor) then  
                error("letter " .. c .. " not configured")
            end
            local letter = letter_ctor(x + x_off + i*LETTER_WIDTH, y)
            letter.pos.z = height + ((rand()-0.5)*height_variance)
            letter.grounded = false -- tell GravitySys that letter might be airborne
        end
    end
end
--[[
    handles win conditions.
NOTE: What actually happens when a win condition is invoked depends on
the worldType!
There are multiple win conditions that are emitted.
 * ccall( ratioWin ) 
    When the enemy : total enemy ration is less than CONSTANTS.WIN_RATIO
 * ccall( voidWin )
    when enemyCount == 0
TODO:
IDEA:
    Make it so each level only has 1 win condition.
    The win condition for each level is specified inside of the worldType files.
    e.g. 
        wType.winCondition = "ratioWin"
    or
        wType.winCondition = "voidWin"
    Each worldType should also give a function that can be called
    for the win condition when it is invoked.
]]
local WinSys = Cyan.System("targetID")
local enemyCount = 0
local enemyCountTotal = 0
local bossCountTotal = 0
local bossCount = 0
local tmp_hash = { -- temporary debug hasher
}
function WinSys:added(e)
    tmp_hash[e]=true
    if e.targetID == "enemy" then
        enemyCount = enemyCount + 1
        enemyCountTotal = enemyCountTotal + 1
    end
    if e.targetID == "boss" then
        bossCount = bossCount + 1
        bossCountTotal = bossCountTotal + 1
    end
end
-- Win conditions can only be called once per world.
local ratioWinDone = false
local voidWinDone = false
local bossWinDone = false
function WinSys:update(dt)
    --[[
        TODO:
        maybe add an extra check to account
        for bosses. We dont want to spawn an exit
        portal if the player is halfway thru fighting
        a boss
        GenerationSys SHOULD handle the ratioWin world generation for this.
        SoundSys should handle the sound, and DrawSys should handle the visual feedback
    ]]
    if (enemyCount / enemyCountTotal) <= CONSTANTS.WIN_RATIO then
        if not ratioWinDone then
            ccall("ratioWin")-- yyeahhh baby
            ratioWinDone = true
        end
    end
    if enemyCount <= 0 then
        if not voidWinDone then
            ccall("voidWin")
            voidWinDone = true
        end
    end
    if bossCount <= 0 then
        if not bossWinDone then
            ccall("bossWin")
            bossWinDone = true
        end
    end
end
function WinSys:removed(e)
    if e.targetID == "enemy" then
        enemyCount = enemyCount - 1
    end
    if e.targetID == "boss" then
        bossCount = bossCount - 1
    end
end
function WinSys:newWorld()
    bossCountTotal  = 0
    enemyCountTotal = 0
    enemyCount = 0
    bossCount  = 0
    for _,ent in ipairs(self.group)do
        if ent.targetID=="enemy" then
            enemyCountTotal = enemyCountTotal + 1
            enemyCount = enemyCount + 1
        elseif ent.targetID=="boss" then
            bossCountTotal = bossCountTotal + 1
            bossCount = bossCountTotal + 1
        end
    end
end
function WinSys:purge( )
    ratioWinDone = false
    voidWinDone = false
    bossWinDone = false
end
local PATH = "src/systems"
Tools.req_TREE(PATH)
