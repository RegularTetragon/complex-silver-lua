require("engine.constants")
local controls = system {
    name = "controls"
}
controls.__index = controls
function controls:new()
    return setmetatable({
        linear_jump_timer = 0,
        crouch = false,
        fire = false,
        throw = false
    }, controls)
end
function controls:update(e, dt)
    local p = v2:new()
    self.crouch = love.keyboard.isDown("s")
    if love.keyboard.isDown("a") and not self.crouch and not (e.rb.v.x < -walkspeed) then -- left
        p = left
    end
    if love.keyboard.isDown("d") and not self.crouch and not (e.rb.v.x > walkspeed) then -- right
        p = right
    end
    if love.keyboard.isDown("w") then -- up
        self.u = true
        if e.rb.is_grounded or self.linear_jump_timer < max_jump_time then
            self.linear_jump_timer = self.linear_jump_timer + dt
            e.rb.v = v2:new(e.rb.v.x, -jump_v)
        end
    elseif not e.rb.is_grounded then
        self.linear_jump_timer = 1 / 0
    end
    self.fire = love.keyboard.isDown("space")
    if p.x ~= 0 and sign(e.rb.v.x) ~= sign(p.x) then
        e.rb.v = v2:new(0, e.rb.v.y)
    end

    if e.rb.is_grounded then
        self.linear_jump_timer = 0
    end
    if p.x > 0 then
        e.trans.mirror_x = false
    end
    if p.x < 0 then
        e.trans.mirror_x = true
    end
    self.p = p
    e.rb.friction = (self.p.x ~= 0 or self.crouch) and 0 or .3
    local speed_desired = e.rb.v.x + p.x * dt * (e.rb.is_grounded and ground_accel or air_accel)
    e.rb.v = v2:new(speed_desired, e.rb.v.y)
end
function controls:render(e)
    if _dbg_ctl then
        print(self.p, e.trans.p.x, e.trans.p.y - 16)
    end
end
return controls