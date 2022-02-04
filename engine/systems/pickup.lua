local pickup = system {
    name = "pickup"
}
pickup.__index = pickup
function pickup:new(on_pickup)
    return setmetatable({
        on_pickup = on_pickup or not_implemented,
        float_t = 0
    }, pickup)
end
function pickup:update(e, dt)
    if not self.anchor then
        self.anchor = e.trans.p
    end
    self.float_t = self.float_t + dt
    e.trans.p = self.anchor + v2:new(0, math.sin(self.float_t) * 3)
end
function pickup:render()
end
return pickup