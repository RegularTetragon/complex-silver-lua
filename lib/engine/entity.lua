local e_counter = 0
entity = {}
entity.__index = entity
function entity:new()
    local e = {
        components = {},
        id = e_counter
    }
    e_counter = e_counter + 1
    entities[e] = true
    setmetatable(e, entity)
    return e
end
function entity:destroy()
    entities[self] = nil
end
function entity:render()
    for _, r in pairs(self.components) do
        r:render(self)
    end
end
function entity:add(c)
    assert(type(c.update) == "function", stringify(c) .. " not valid component")
    table.insert(self.components, c)
    if c.name and self[c.name] == nil then
        self[c.name] = c
    end
    self.components = sort(self.components, function(c)
        return c.priority or 1 / 0
    end)
end
