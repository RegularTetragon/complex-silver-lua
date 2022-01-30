function system(obj)
    assert(obj.name)
    add(systems, obj.name)
    return obj
end