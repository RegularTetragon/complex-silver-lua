require "engine.systems"
require "engine.constants"
rend_map = system {
    name = "rend_map"
}
rend_map.__index = rend_map
function rend_map:new(map)
    return setmetatable({
        map=map
    }, rend_map)
end
function rend_map:update(e, dt)
end
function rend_map:render(e)
    for layer_id, layer in pairs(self.map.layers) do
        local tileset = self.map:tileset(layer_id)
        for index, sprite_id in pairs(layer.data) do
            if self.map:tileset(layer_id):props(sprite_id).Solid then
                local p = self.map:tileIndexToVector(index) - global_camera
                love.graphics.draw(
                    tileset:sprite(sprite_id),
                    p.x*global_zoom,
                    p.y*global_zoom
                )
            end
        end
    end
end
