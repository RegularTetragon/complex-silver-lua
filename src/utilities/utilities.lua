function stringify(t, n)
    local mt = getmetatable(t)
    if mt and mt.__tostring then
     return tostring(t)
    end
    
    local out = "{\n"
    for k, v in pairs(t) do
     if type(k) == "string" then
      out ..= k .. "="
     else
      out ..= "["..tostring(k).."]=";
     end
     if type(v) == "table" then
      out ..= stringify(v,n)
     elseif type(v) == "function" then
      out ..= "function()"
     elseif type(v) == "string" then
      out ..= '"'..v..'"'
     else
      out ..= tostring(v)
     end
     out ..= ","
     if n then
      out ..= "\n"
     end
    end
    out ..= "}"
    return out
   end
   
   function not_implemented()
    assert(false, "not implemented")
   end
   
   
   function sort(xs, key)
    if #xs <= 1 then
     return xs
    end
    local mp = flr(#xs/2)
    local left = {}
    local right = {}
    for i=1,#xs do
     if i <= mp then
      add(left, xs[i])
     else
      add(right, xs[i])
     end
    end
    local merged = {}
    local s_left = sort(left, key)
    local s_right= sort(right,key)
    local l, r = 1, 1
    while s_left[l] and s_right[r] do
     if key(s_left[l]) < key(s_right[r]) then
      add(merged, s_left[l])
      l =      l + 1
     else
      add(merged, s_right[r])
      r =      r + 1
     end
    end
    if l <= #s_left then
     for i=l, #s_left do
      add(merged, s_left[i])
     end
    end
    if r <= #s_right then
     for i=r, #s_right do
      add(merged, s_right[i])
     end
    end
    return merged
   end