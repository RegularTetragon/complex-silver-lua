local camera = {}
camera.__index = camera
function camera:new()
    return setmetatable({}, camera)
end
function camera:update()
end
function camera:render(e)
    love.graphics.translate(e.trans.p.x, e.trans.p.y)
end
return camera