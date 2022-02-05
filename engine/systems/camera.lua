require "engine.state"
require "engine.systems"

local camera = system {name="camera"}
camera.__index = camera
function camera:new()
    return setmetatable({}, camera)
end
function camera:update(e)
    local x, y = love.graphics.getDimensions()
    global_camera = e.trans.p - v2:new(
        x/4/global_zoom - 4,
        y/4/global_zoom - 4
    )
end
function camera:render(e)
end
return camera