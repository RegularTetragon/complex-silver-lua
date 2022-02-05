local worlds = {}
function getWorld(id)
    worlds[id] = worlds[id] or love.physics.newWorld()
end

rb = system {
    name = "rb",
    priority = 1
}
rb.__index = rb
function rb:new(friction, gravity)
    return setmetatable({
        v = v2:new(),
        is_grounded = false,
        ground_timer = 0,
        friction = friction or .3,
        gravity = gravity or 1
    }, rb)
end
function rb:update(e, dt)
    self.v = self.v + v2:new(0, grav * self.gravity) * dt
    self.ground_timer = self.ground_timer - 1
    self.is_grounded = self.ground_timer > 0
    e.trans.p = e.trans.p + self.v * dt
    -- calculate collisions
    local col_offset = zero
    if e.col and entities[e] then
        local hitting_solid = false
        e.col:check(e)
        for _, col in pairs(e.col.collisions) do
            if col.col.solid then
                hitting_solid = true
                local offset = e.col:deintersect(e, col)
                if offset then
                    col_offset = offset
                end
            end
        end
        if hitting_solid and self.v.y > 0 and col_offset:magnitude() > 0 then
            local diff = self.v:proj(col_offset:unit())
            if diff < 0 then
                assert(col_offset:magnitude() > 0)
                self.v = self.v - (diff * col_offset:unit())
            end
        end
    end

    self.is_grounded = col_offset.y < 0
    -- apply ground friction
    if self.is_grounded then
        self.v = self.v * (1 - self.friction)
    end
end
function rb:render(e)
    if _dbg_rb then
        print(self.v, e.trans.p.x, e.trans.p.y - 8)
        print(self.is_grounded)
    end
end

col = system {
    name = "col"
}
col.__index = col
function col:new(lb, ub, static, solid, mask, layer)
    if solid == nil then
        solid = true
    end
    assert(lb.x < ub.x)
    assert(lb.y < ub.y)

    return setmetatable({
        lb = lb,
        ub = ub,
        static = static,
        solid = solid,
        collisions = {},
        callbacks = {},
        mask = mask or layer_all,
        layer = layer or mask or layer_all
    }, col)
end
function col:on_collision(f)
    table.insert(self.callbacks, f)
end
function col:update(e)

end
function col:check(e)
    if self.static then
        return
    end
    self.collisions = {}
    local p = e.trans.p
    for other, active in pairs(entities) do
        if active then
            local ocol = other.col
            if ocol and (self.mask:intersects(ocol.layer)) ~= 0 then
                local opos = other.trans.p
                if e ~= other and self:overlap(ocol, p, opos) then
                    table.insert(self.collisions, other)
                end
            end
        end
    end
    for _, f in pairs(self.callbacks) do
        for _, c in pairs(self.collisions) do
            f(e, c)
        end
    end
end

function col:deintersect(e, from_e)
    local s_p, f_p, from = e.trans.p, from_e.trans.p, from_e.col

    local s_ub, f_ub, s_lb, f_lb = self.ub + s_p, from.ub + f_p, self.lb + s_p, from.lb + f_p

    local s_t, s_b, s_r, s_l, f_t, f_b, f_r, f_l = s_ub.y, s_lb.y, s_ub.x, s_lb.x, f_ub.y, f_lb.y, f_ub.x, f_lb.x
    assert(s_t > s_b)
    assert(s_r > s_l)
    assert(f_t > f_b)
    assert(f_r > f_l)
    local options = {}
    -- need to move down (up in game)
    if s_t > f_b and s_t < f_t then
        table.insert(options, v2:new(0, f_b - s_t))
    end
    -- need to move up (down in game)
    if s_b < f_t and s_b > f_b then
        table.insert(options, v2:new(0, f_t - s_b))
    end
    if false then

        -- need to move left
        if s_r > f_l and s_r < f_r then
            table.insert(options, v2:new(f_l - s_r, 0))
        end
        -- need to move right
        if s_l > f_r and s_l < f_l then
            table.insert(options, v2:new(f_r - s_l, 0))
        end
    end
    if #options > 0 then
        self.diffs = options
    end
    local min_sm
    local min_val = options[1]
    --[[for _, option in pairs(options) do
  local sm = option.x * option.x + option.y * option.y
  if not min_sm or sm < min_sm then
   min_sm = sm
   min_val = option
  end
 end]]
    for _, option in pairs(options) do
        min_val = min_val or zero + option
    end
    if min_val then
        e.trans.p = e.trans.p + min_val
        -- assert(min_val:magnitude() > .01)
        return min_val
    end
end

function col:overlap(other, p_self, p_other)
    local e_lb = self.lb + p_self
    local e_ub = self.ub + p_self
    local o_lb = other.lb + p_other
    local o_ub = other.ub + p_other
    return (e_lb.x < o_ub.x and e_ub.x > o_lb.x and e_ub.y > o_lb.y and e_lb.y < o_ub.y)
end
function col:render(e)
    if _dbg_col then
        local lb = e.trans.p + self.lb
        local ub = e.trans.p + self.ub
        rect(lb.x, lb.y, ub.x, ub.y, (#self.collisions > 0) and 8 or 6)
        local mp = (lb + ub) * .5
        print(#self.collisions, mp.x, mp.y)
        if self.diffs then
            print(stringify(self.diffs, true), mp.x, mp.y - 50)
        end
    end
end

weld = system {
    name = "weld",
    priority = 2
}
weld.__index = weld
function weld:new(to, offset)
    return setmetatable({
        to = to,
        offset = offset
    }, weld)
end
function weld:update(e, dt)
    local mod_offset = v2:new(self.offset.x * (self.to.trans.mirror_x and -1 or 1),
        self.offset.y * (self.to.trans.mirror_y and -1 or 1))
    e.trans.p = self.to.trans.p + mod_offset
    e.trans.mirror_x = self.to.trans.mirror_x
    e.trans.mirror_y = self.to.trans.mirror_y
end
function weld:render(e)
end
