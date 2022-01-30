local debris = system {name="debris"}
debris.__index = debris
function debris:new(t)
 return setmetatable({
  t=t,
  callbacks={}
 }, debris)
end
function debris:update(e, dt)
 self.t -= dt
 if self.t <= 0 then
  for _, f in pairs(callbacks) do
   f(e)
  end
  e:destroy()
 end
end
function debris:on_destroy(f)
 add(self.callbacks, f)
end
function debris:render()

end
