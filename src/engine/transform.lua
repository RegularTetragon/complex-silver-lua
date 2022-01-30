trans=system {name="trans"}
trans.__index = trans
function trans:new()
 return setmetatable(
  {
   p=v2:new(),
   s=v2:new(1,1),
   mirror_x=false,
   mirror_y=false
  },
  trans
 )
end
function trans:update(e, dt)
end
function trans:render(e)
 --print(e.id.."\n"..tostring(self), self.p.x+12, self.p.y)
end
function trans:__tostring()
 return ""
     	.."p"..tostring(self.p).."\n"
      .."s"..tostring(self.s).."\n"
      .."mx"..tostring(self.mirror_x).."\n"
      .."my"..tostring(self.mirror_y)
end