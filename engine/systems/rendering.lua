require "engine.systems"
rend_map = system {
    name = "rend_map"
}
rend_map.__index = rend_map
function rend_map:new(lower_bound, upper_bound, cam)
    return setmetatable({
        lower_bound = lower_bound,
        upper_bound = upper_bound,
        cam = cam
    }, rend_map)
end
function rend_map:update(e, dt)
end
function rend_map:render(e)
    map(self.lower_bound.x, self.lower_bound.y, 0, 0, self.upper_bound.x - self.lower_bound.x,
        self.upper_bound.y - self.lower_bound.y, 0x1)
end
