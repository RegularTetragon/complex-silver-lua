function stringify(t, n)
    local mt = getmetatable(t)
    if mt and mt.__tostring then
        return tostring(t)
    end

    local out = "{\n"
    for k, v in pairs(t) do
        if type(k) == "string" then
            out = out .. k .. "="
        else
            out = out .. "[" .. tostring(k) .. "]=";
        end
        if type(v) == "table" then
            out = out .. stringify(v, n)
        elseif type(v) == "function" then
            out = out .. "function()"
        elseif type(v) == "string" then
            out = out .. '"' .. v .. '"'
        else
            out = out .. tostring(v)
        end
        out = out .. ","
        if n then
            out = out .. "\n"
        end
    end
    out = out .. "}"
    return out
end

function not_implemented()
    assert(false, "not implemented")
end

function sort(xs, key)
    if #xs <= 1 then
        return xs
    end
    local mp = math.floor(#xs / 2)
    local left = {}
    local right = {}
    for i = 1, #xs do
        if i <= mp then
            table.insert(left, xs[i])
        else
            table.insert(right, xs[i])
        end
    end
    local merged = {}
    local s_left = sort(left, key)
    local s_right = sort(right, key)
    local l, r = 1, 1
    while s_left[l] and s_right[r] do
        if key(s_left[l]) < key(s_right[r]) then
            table.insert(merged, s_left[l])
            l = l + 1
        else
            table.insert(merged, s_right[r])
            r = r + 1
        end
    end
    if l <= #s_left then
        for i = l, #s_left do
            table.insert(merged, s_left[i])
        end
    end
    if r <= #s_right then
        for i = r, #s_right do
            table.insert(merged, s_right[i])
        end
    end
    return merged
end

function sign(n)
    if sign == 0 then
        return 0
    elseif sign > 0 then
        return 1
    else
        return -1
    end
end
