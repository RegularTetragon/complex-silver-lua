v2 = {}
v2.__index = v2
function v2:new(x, y)
    x = x or 0
    y = y or 0
    assert(type(x) == "number", "x ("..stringify(x)..") must be a number")
    assert(type(y) == "number", "y ("..stringify(y)..") must be a number")
    return setmetatable({
        x = x,
        y = y
    }, v2)
end
function v2:angle(th, d)
    return v2:new(math.cos(th) * d, math.sin(th) * d)
end
function v2:unit(unsafe)
    local magnitude = self:magnitude()
    if not unsafe then
        assert(magnitude > 0)
    end
    return self * (1 / self:magnitude())
end
function v2:magnitude()
    return math.sqrt(self:dot(self))
end
function v2:dot(other)
    return self.x * other.x + self.y * other.y
end
function v2:proj(other)
    return self:dot(other) / other:magnitude()
end
function v2:__add(other)
    return v2:new(self.x + other.x, self.y + other.y)
end
function v2:__mul(other)
    if type(self) == "number" then
        self, other = other, self
    end
    return v2:new(self.x * other, self.y * other)
end
function v2:__tostring()
    return "<" .. math.floor(self.x) .. ", " .. math.floor(self.y) .. ">"
end
function v2:__sub(other)
    return v2:new(self.x - other.x, self.y - other.y)
end

right = v2:new(1, 0)
left = v2:new(-1, 0)
up = v2:new(0, -1)
down = v2:new(0, 1)
zero = v2:new(0, 0)
one = v2:new(1, 1)
sprite_size = v2:new(8, 8)
