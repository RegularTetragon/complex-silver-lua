local layerset = {}

layerset.__index = layerset
function layerset:__add(other)
    local new_children = {}
    for child, value in pairs(self.children) do
        new_children[child] = value
    end
    for child, value in pairs(other.children) do
        new_children[child] = value
    end
    return layerset:new(new_children)
end
function layerset:__mul(other)
    local new_children = {}
    for child, value in pairs(self.children) do
        if other.children[child] then
            new_children[child] = value
        end
    end
    return layerset:new(new_children)
end

--Table<Any, Boolean> -> Layerset
function layerset:new(children)
    return setmetatable({
        children=children
    }, layerset)
end
--List<Any> -> Layerset
function layerset:from_list(children)
    local result = {}
    for _, child in pairs(children) do
        result[child] = true
    end
    return layerset:new(result)
end
function layerset:intersects(other)
    return next((self * other).children) ~= nil
end

return layerset