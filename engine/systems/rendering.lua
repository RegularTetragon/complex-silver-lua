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
            if sprite_id ~= 0 then
                local p = self.map:tileIndexToVector(index)
                love.graphics.draw(
                    tileset:sprite(sprite_id),
                    p.x*zoom, p.y*zoom
                )
            end
        end
    end
end
