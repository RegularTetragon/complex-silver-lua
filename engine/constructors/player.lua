require "engine.systems.graphics"
local Gun = require "engine.systems.gun"
local controls = require "engine.systems.controls"
local camera = require "engine.systems.camera"
player_instance=nil

function cons_player(pos)
    local p = entity:new()
    player_instance = p
    local p_anim = anim_ctl:new{
        start = anim:new(tileset:load("sprites"), {2}),
        walk = anim:new(tileset:load("sprites"), {2, 3}),
        rise = anim:new(tileset:load("sprites"), {19}),
        fall = anim:new(tileset:load("sprites"), {5, 6}),
        slid = anim:new(tileset:load("sprites"), {4}),
        crch = anim:new(tileset:load("sprites"), {18})
    }
    function t_motion(e)
        if e.controls.crouch then
            if e.controls.p.x == 0 then
                return "crch"
            else
                return "slid"
            end
        end
        if e.rb.is_grounded then
            local is_moving = math.abs(e.rb.v.x) > .1
            if is_moving then
                return "walk"
            else
                return "start"
            end
        elseif e.rb.v.y < 0 then
            return "rise"
        else
            return "fall"
        end
    end
    p:add(
        camera:new()
    )
    p:add(
        col:new(
            v2:new(),
            v2:new(8, 8),
            false,
            false,
            layer_world + layer_player,
            layer_player
        )
    )
    p:add(controls:new())
    p:add(trans:new())
    p:add(Gun.hold:new())
    p.trans.p = pos
    p:add(p_anim)
    p:add(rb:new())
    p.rb.v = v2:new(30, -60)
    p_anim:trans("start", t_motion)
    p_anim:trans("rise", t_motion)
    p_anim:trans("fall", t_motion)
    p_anim:trans("walk", t_motion)
    p_anim:trans("crch", t_motion)
    p_anim:trans("slid", t_motion)
    return p
end
