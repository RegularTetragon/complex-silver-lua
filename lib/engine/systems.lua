require "engine.entity"
function system(obj)
    assert(obj.name)
    table.insert(systems, obj.name)
    return obj
end
