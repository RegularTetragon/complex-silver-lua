function cons_shrapnel(n, pos, sprs)
    for i = 1, n do
        local e = entity:new()
        e:add(trans:new())
        --[[e:add(col:new(
      one*2,
      one*6,
      false,
      false,
      m_world,
      m_shrapnel
     ))]]
        e.trans.p = pos
        e:add(rb:new())
        e.rb.v = v2:new(rnd() * 64 - 32, -48)
        local spr_i
        if n <= 1 then
            spr_i = math.floor(rnd(#sprs)) + 1
        else
            spr_i = i % #sprs + 1
        end

        e:add(anim:new(sprs[spr_i], 4))
        e:add(debris:new(rnd() * 1 + 1))
    end
end

function cons_explosion(dmg, pos, layer)
    assert(dmg)
    assert(pos)
    assert(layer)
    sfx(4)

    for r = 1, explosion_rs do
        for i = 0, explosion_angles do
            local e = entity:new()
            e:add(trans:new())
            e.trans.p = pos
            e:add(rb:new(0, 0))
            e.rb.v = v2:angle(i / explosion_angles, explosion_speed * r / explosion_rs)
            e.rb.gravity = 1
            e:add(col:new(zero, sprite_size, false, false))
            e:add(anim:new({28, 29, 31}, 5))
            e:add(debris:new(.5))
            e:add(damager:new(dmg, layer))
        end
    end
end
