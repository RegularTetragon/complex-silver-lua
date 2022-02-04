require "engine.systems.physics"
require "engine.systems.health"
require "engine.constructors.effects"
local debris = require "engine.systems.debris"
local Gun = require "engine.systems.gun"
local layerset = require "engine.layer"

function cons_gun(
    ammo,
    fire_rate,
    cons_proj,
    anim_ctl,
    offset,
    fire_sound,
    owner_knockback
)
    return function(spawner, player)
        love.audio.newSource("assets/sounds/sfx_5.wav", "static"):play()
        local e = entity:new()
        e:add(trans:new())
        e:add(anim_ctl)
        e.anim_ctl:trans("shoot", function()
            if e.anim_ctl.states.shoot.looped then return "start" end
        end)
        e:add(weld:new(player, offset))
        e:add(Gun.gun:new(ammo, fire_rate, cons_proj, player, fire_sound,
                      owner_knockback))
        return true
    end
end

function cons_proj(n, spread, speed, anim)
    return function(e)
        local projs = {}
        for i = 1, n do
            local p = entity:new()
            table.insert(projs, p)
            p:add(trans:new())
            p.trans.p = e.trans.p
            p.trans.mirror_x = e.trans.mirror_x
            p:add(anim)
            p:add(rb:new(0, 0))
            p:add(col:new(v2:new(2, 2), v2:new(6, 6), false, false,
                          layer_world + layer_enemy, layer_projectile))
            p.rb.v = v2:new(e.trans.mirror_x and -speed or speed,
                            (2 * math.random() - 1) * spread)
            p:add(debris:new(1))
        end
        return projs
    end
end

function cons_grenade(e)
    local ps =
        cons_proj(1, 0, 100, anim:new(tileset:load("sprites"), {35, 36}))(e)
    for _, p in pairs(ps) do
        p.rb.gravity = 2
        p.rb.v = p.rb.v + up * 128
        p.debris:on_destroy(function()
            cons_explosion(1, p.trans.p, p_enemy)
        end)
    end
end

function cons_bullet(n, spread, speed, anim, dmg, layer)
    return function(e)
        local bs = cons_proj(n, spread, speed, anim)(e)
        for _, b in pairs(bs) do
            b:add(damager:new(dmg, layer))
            b:add(debris:new(1))
        end
    end
end

function cons_rocket(e)
    local rs = cons_proj(1, 0, 80, anim:new(tileset:load("sprites"), {14, 30}))(
                   e)
    for _, r in pairs(rs) do
        r.col.mask = layer_world
        r.col:on_collision(function(r, with)
            if with ~= player then
                cons_explosion(1, r.trans.p, 1)
                r:destroy()
            end
        end)
    end
    return rs
end

function cons_throw(anim, on_land, from)
    local e = entity:new()

    e:add(trans:new())
    e.trans.p = from.trans.p
    e:add(col:new(v2:new(), v2:new(8, 8), false, false, layer_world))
    e:add(rb:new())
    e.rb.v = v2:new(from.trans.mirror_x and -throw_speed or throw_speed, 20)
end

cons_shotgun = cons_gun(
    4, -- ammo
    1, -- rate
    cons_bullet(
        4, -- pellets
        75, -- spread
        150, -- speed
        anim:new(tileset:load("sprites"), {11}), -- sprite,
        1, -- dmg,
        1 -- layer
    ),
    anim_ctl:new{
        start = anim:new(tileset:load("sprites"), {7}),
        shoot = anim:new(tileset:load("sprites"), {8, 7})
    },
    v2:new(4, -1), -- offset
    "assets/sounds/sfx_1.wav", -- sound effect
    60
)

cons_grenade_launcher = cons_gun(
    8, -- ammo
    1, -- rate
    cons_grenade,
    anim_ctl:new{
        start = anim:new(tileset:load("sprites"), {38}),
        shoot = anim:new(tileset:load("sprites"), {38})
    },
    v2:new(4, -1),
    "assets/sounds/sfx_1.wav",
    60
)

cons_rifle = cons_gun(
    16, -- ammo
    .25, -- rate
    cons_bullet(1, -- pellets
        30, -- spread
        400, -- speed
        anim:new(tileset:load("sprites"), {10}), -- spr,
        1, -- dmg
        1 -- layer
    ),
    anim_ctl:new{
        start = anim:new(tileset:load("sprites"), {25}),
        shoot = anim:new(tileset:load("sprites"), {25})
    },
    v2:new(4, -1),
    "assets/sounds/sfx_0.wav",
    10
)

cons_rocket_launcher = cons_gun(
    16, -- ammo
    1, -- rate
    cons_rocket,
    anim_ctl:new{
        start = anim:new(tileset:load("sprites"), {14}),
        shoot = anim:new(tileset:load("sprites"), {14})
    },
    v2:new(0, -2),
    "assets/sounds/sfx_2.wav",
    75
)

cons_pistol = cons_gun(
    8, -- ammo
    .5, -- rate
    cons_bullet(
        1, -- pellets
        2, -- spread
        300, -- speed
        anim:new(tileset:load("sprites"), {10}), -- sprite,
        1, -- damage
        1 -- layer
    ),
    anim_ctl:new{
        start = anim:new(tileset:load("sprites"), {9}),
        shoot = anim:new(tileset:load("sprites"), {26, 9})
    },
    v2:new(4, -1),
    "assets/sounds/sfx_0.wav", -- sound,
    30 -- knockback
)
