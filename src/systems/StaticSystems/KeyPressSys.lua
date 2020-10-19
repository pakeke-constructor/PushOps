

local KeyPressSys = Cyan.System() -- does not take entities.


local SHORT_THRESHOLD = 0.25 -- 0.25 seconds is considered a key tap.



local keydown = {
    -- A table holding whether a key is down or not.
    -- The key will be set to `nil` if it is not pressed.
}


local time_between_press_and_release = {
    -- A table holding the time of a key press (time the key is held)
}



function KeyPressSys:update(dt)
    local time
    for key, _ in pairs(keydown) do
        time = time_between_press_and_release[key] or 0
        if keydown[key] then
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
    if time_between_press_and_release[key] then
        if time_between_press_and_release[key] < SHORT_THRESHOLD then
            Cyan.call("keytap",  key)
        end
    end
    time_between_press_and_release[key] = nil
    Cyan.call("keyup", key)
end








