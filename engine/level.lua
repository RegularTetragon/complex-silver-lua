require "engine.constructors.pickups"
require "engine.constructors.player"
require "engine.constructors.guns"
require "engine.constructors.tiles"
require "engine.entity"
require "engine.systems.rendering"
require "engine.v2"
require "engine.tileset"
require "engine.systems.transform"
require "engine.systems.physics"
require "engine.utilities.utilities"
require "engine.layer"
-- sprite index -> entity constructor
map_cons = {
    [2] = cons_player,
    [9] = cons_pickup({9}, cons_pistol),
    [7] = cons_pickup({7}, cons_shotgun),
    [14] = cons_pickup({14}, cons_rocket_launcher),
    [25] = cons_pickup({25}, cons_rifle),
    [38] = cons_pickup({38}, cons_grenade_launcher),
    [28] = cons_breakable
}

level = { }
level.__index = level
function level:new(obj)
    assert(obj.layers)
    return setmetatable(obj, level)
end

function level:load(str)
    return level:new(require("assets.maps."..str))
end

function level:tileset(index)
    self._tilesets = self._tilesets or {}
    self._tilesets[index] = self._tilesets[index] or tileset:new(require(
        "assets.tilesets." .. self.tilesets[index].name
    ))
    return self._tilesets[index]
end

function level:tileIndexToXY(tile_id)
    local x = (tile_id - 1) % self.width
    local y = math.floor((tile_id - 1)/self.width)
    return x,y
end

function level:tileIndexToVector(tile_id)
    assert(tile_id)
    local x, y = self:tileIndexToXY(tile_id)
    return v2:new(
        x * self.tilewidth,
        y * self.tileheight
    )
end

function level:construct()
    local lvl = entity:new()
    local lb = zero
    local ub = v2:new(self.width, self.height)
    lvl:add(rend_map:new(self))
    local rects = {}
    for layer_id, layer in pairs(self.layers) do
        for tile_id, sprite_id in pairs(layer.data) do
            local p = self:tileIndexToVector(tile_id, layer_id)
            if map_cons[sprite_id] then
                map_cons[sprite_id](p)
            end
            local tile_props = self:tileset(layer_id):props(sprite_id)
            if tile_props.Solid then
                local col_entity = entity:new()
                col_entity:add(trans:new())
                col_entity.trans.p = p
                col_entity:add(col:new(v2:new(), v2:new(8, 8), true, true, layer_world))
            end
        end
    end

    return lvl
end
