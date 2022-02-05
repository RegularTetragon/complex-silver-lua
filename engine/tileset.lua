tileset = {}
tileset.__index = tileset
tileset_cache = {}
function tileset:new(obj)
    assert(obj.columns)
    return setmetatable(obj, tileset)
end
function tileset:load(name)
    tileset_cache[name] = tileset_cache[name] or tileset:new(require("assets.tilesets."..name))
    return tileset_cache[name]
end
function tileset:props(index)
    self._props = self._props or {}
    if self._props[index] then
        return self._props[index]
    end
    --TODO: Binary Search
    local found = {}
    for _, tileData in pairs(self.tiles) do
        if tileData.id == index then
            found = tileData.properties
        end
    end
    self._props[index] = found
    return found
end

function tileset:quad(index)
    local wx = self.tilewidth
    local wy = self.tileheight
    local x = (index % self.columns)
    local y = math.floor(index / self.columns)
    self:texture()
    return love.graphics.newQuad(x*wx,y*wy,wx,wy,self.imagewidth, self.imageheight)
end

function tileset:texture()
    self._baseimage = self._baseimage or love.graphics.newImage("assets/"..self.name..".png")
    self._baseimage:setFilter("nearest", "nearest", 0)
    return self._baseimage
end

function tileset:sprite(index)
    self._sprites = self._sprites or {}
    if self._sprites[index] then
        return self._sprites[index]
    end

    local q = self:quad(index-1)
    local c = love.graphics.newCanvas(q.width, q.height)
    c:setFilter("nearest", "nearest", 0)
    c:renderTo(function()
        love.graphics.draw(self:texture(), q, 0, 0)
    end)
    self._sprites[index] = c
    return c
end

function tileset:draw(index, trans)
    local spr = self:sprite(index)
    love.graphics.draw(
        spr,
        (trans.p.x - global_camera.x) * zoom,
        (trans.p.y - global_camera.y) * zoom,
        trans.p.r,
        trans.p.mirror_x and -1 or 1,
        trans.p.mirror_y and -1 or 1
    )
end
