local debris = require "engine.systems.debris"

function cons_shrapnel(n, pos, sprs)
    for i = 1, n do
        local e = entity:new()
        e:add(trans:new())
        e.trans.p = pos
        e:add(rb:new())
        e.rb.v = v2:new(math.random() * 64 - 32, -48)
        local spr_i
        if n <= 1 then
            spr_i = math.floor(math.random(#sprs)) + 1
        else
            spr_i = i % #sprs + 1
        end

        e:add(anim:new(sprs[spr_i], 4))
        e:add(debris:new(math.random() * 1 + 1))
    end
end

function cons_explosion(dmg, pos, layer)
    assert(dmg)
    assert(pos)
    assert(layer)
    love.audio.newSource("assets/sounds/sfx_4.wav", "static"):play()

    for r = 1, explosion_rs do
        for i = 0, explosion_angles do
            local e = entity:new()
            e:add(trans:new())
            e.trans.p = pos
            e:add(rb:new(0, 0))
            e.rb.v = v2:angle(i / explosion_angles, explosion_speed * r / explosion_rs)
            e.rb.gravity = 1
            e:add(col:new(zero, sprite_size, false, false))
            e:add(anim:new(tileset:load("sprites"), {29, 30, 32}, 5))
            e:add(debris:new(.5))
            e:add(damager:new(dmg, layer))
        end
    end
end
