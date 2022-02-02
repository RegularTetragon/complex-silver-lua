anim = system {
    name = "anim"
}
anim.__index = anim
function anim:new(frames, speed)
    local speed = speed or 4
    return setmetatable({
        t = 0,
        speed = speed,
        frames = frames,
        frame = 0,
        eol_callbacks = {},
        looped = false
    }, anim)
end
function anim:loop_e(f)
    table.insert(self.e0l_callbacks, f)
end

function anim:update(e, dt)
    self.looped = false
    self.t = self.t + dt
    local new_frame = (math.floor(self.t * self.speed) % #self.frames) + 1
    if self.frame > new_frame then
        self.looped = true
        for _, f in pairs(self.eol_callbacks) do
            f(e)
        end
    end
    self.frame = new_frame
end

function anim:render(e)
    spr(self.frames[self.frame], e.trans.p.x, e.trans.p.y, e.trans.s.x, e.trans.s.y, e.trans.mirror_x, e.trans.mirror_y)
    self.last_frame = frm
end

anim_ctl = system {
    name = "anim_ctl"
}
anim_ctl.__index = anim_ctl
function anim_ctl:new(states)
    local self = {}
    self.states = states
    self.state = "start"
    self.old_state = "start"
    self.looped = false
    assert(self.states[self.state])
    self.transitions = {}
    return setmetatable(self, anim_ctl)
end
function anim_ctl:render(e)
    self.states[self.state]:render(e)
    if _dbg_anim_ctl then
        print(self.state, e.trans.p.x, e.trans.p.y - 8)
        print(self.states[self.state].looped, e.trans.p.x + 8 + e.id, e.trans.p.y - 32)
    end
end
function anim_ctl:update(e, dt)
    for _, t in pairs(self.transitions[self.state] or {}) do
        local nxt = t(e)
        if nxt then
            self.state = nxt
        end
    end
    if self.state ~= self.old_state then
        self.states[self.state].t = 0
    end
    self.states[self.state]:update(e, dt)
    self.old_state = self.state
end
function anim_ctl:trans(st, f)
    self.transitions[st] = self.transitions[st] or {}
    table.insert(self.transitions[st], f)
end

local flipper = system {
    name = "flipper"
}
flipper.__index = flipper
function flipper:new()
    return setmetatable({}, flipper)
end
function flipper:update(e)
    if abs(e.rb.v.x) > .1 then
        e.trans.mirror_x = e.rb.v.x < 0
    end
end
function flipper:render()
end
