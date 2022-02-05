require "engine.constants"
local layerset = require "engine.layer"
damager = system {
    name = "damager"
}
damager.__index = damager
function damager:new(dmg, layer)
    assert(getmetatable(layer)==layerset)
    return setmetatable({
        dmg = dmg,
        layer = layer or layer_world
    }, damager)
end
function damager:update(e, dt)
    local cs = e.col.collisions
    for _, c in pairs(cs) do
        if c.health and c.health.health > 0 and (c.health.layer:intersects(self.layer)) then
            c.health.health = c.health.health - self.dmg
            e:destroy()
        end
    end
end
function damager:render()
end

health = system {
    name = "health"
}
health.__index = health
function health:new(base_health, layer)
    assert(getmetatable(layer)==layerset, stringify(layerset))
    return setmetatable({
        health = base_health,
        layer = layer or layer_all,
        max_health = base_health,
        on_death_callbacks = {},
        callbacks_done = false
    }, health)
end
function health:on_death(f)
    table.insert(self.on_death_callbacks, f)
end
function health:update(e)
    if self.health <= 0 and not self.callbacks_done then
        for _, callback in pairs(self.on_death_callbacks) do
            callback(e)
        end
    end
    self.callbacks_done = self.health <= 0
end
function health:render(e)
    if _dbg_health then
        print(self.health, e.trans.p.x, e.trans.p.y)
    end
end
