function cons_breakable(pos)
    local e = entity:new()
    e:add(trans:new())
    e.trans.p = pos
    e:add(health:new(1, 1))
    e:add(col:new(zero, sprite_size, true, true))
    e:add(anim:new(tileset:load("sprites"), {27}))
    e.health:on_death(function(e)
        cons_shrapnel(3, e.trans.p, {{32}, {33}, {34}})
        love.audio.newSource("assets/sounds/sfx_3.wav", "static"):play()
        e:destroy()
    end)
end
