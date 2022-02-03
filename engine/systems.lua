require "engine.entity"
systems = {}
function system(obj)
    assert(obj.name)
    table.insert(systems, obj.name)
    return obj
end
