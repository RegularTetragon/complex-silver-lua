require "engine.constructors.pickups"
require "engine.entity"
require "engine.systems.rendering"
require "engine.v2"
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

level = { }
level.__index = level
function level:new(obj)
    return setmetatable(obj, level)
end

function level:load(str)
    return level:new(require("assets.maps."..str))
end

function level:construct()
    local lvl = entity:new()
    local lb = zero
    local ub = v2:new(self.width, self.height)
    lvl:add(rend_map:new(lb, ub, nil))
    local rects = {}
    for _, layer in pairs(self.layers) do
        for tile_id, sprite in pairs(layer.data) do
            local x = tile_id % layer.width + layer.x
            local y = math.floor(tile_id/layer.width) + layer.y
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
