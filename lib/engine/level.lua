require "lib/constructors/pickups"
require "lib/engine/entity"
require "lib/engine/rendering"
-- sprite index -> entity constructor
map_cons = {
    [1] = cons_player,
    [8] = cons_pickup({8}, cons_pistol),
    [6] = cons_pickup({6}, cons_shotgun),
    [13] = cons_pickup({13}, cons_rocket_launcher),
    [24] = cons_pickup({24}, cons_rifle),
    [37] = cons_pickup({37}, cons_grenade_launcher),
    [27] = cons_breakable
}

function level(lb, ub)
    local lvl = entity:new()
    lvl:add(rend_map:new(lb, ub, nil))
    local rects = {}
    for x = lb.x, ub.x do
        for y = lb.y, ub.y do
            local sprite = mget(x, y)
            if map_cons[sprite] then
                map_cons[sprite](v2:new(x * 8, y * 8))
            end
            if fget(sprite) == 0x1 then
                local col_entity = entity:new()
                col_entity:add(trans:new())
                col_entity.trans.p = v2:new(x * 8, y * 8)
                col_entity:add(col:new(v2:new(), v2:new(8, 8), true, true, m_world))
            end
        end
    end

    return lvl
end
