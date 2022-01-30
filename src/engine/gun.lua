local hold = system {name="hold"}
hold.__index = hold
function hold:new()
 return setmetatable({
 }, hold)
end
function hold:update(e, dt)
 if e.controls.throw then
  e.throwable.throw = true
 end
 if not self.holding then
	 for _, c in pairs(e.col.collisions) do
	  if c.pickup then
	   if c.pickup:on_pickup(e) then
	    c:destroy()
	   end
	  end
	 end
	end
end
function hold:render()
end

local gun = system {
 name="gun",
 priority = 1/0
}
gun.__index = gun
function gun:new(
 default_ammo,
 fire_delay,
 cons_proj,
 owner,
 fire_sound,
 owner_knockback
)
	return setmetatable(
	 {
	  ammo=default_ammo,
	  fire_delay=fire_delay,
	  cons_proj=cons_proj,
	  owner=owner,
	  shot_timer=0,
	  fire_sound=fire_sound,
	  shake=0,
	  owner_knockback=owner_knockback
	 },
	 gun
	)
end
function gun:update(e, dt)
 self.shot_timer -= dt
 if self.shot_timer < 0
    and
    self.owner.controls.fire
 then
  self.owner.rb.v = self.owner.rb.v + v2:new(
   e.trans.mirror_x
   and
   self.owner_knockback
   or
   -self.owner_knockback,
   -self.owner_knockback
  )
  self.ammo -= 1
  self.cons_proj(e)
  self.shot_timer=self.fire_delay
	 e.anim_ctl.state="shoot"
	 sfx(self.fire_sound)
	end
	if self.ammo <= 0 then
	 e:destroy()
	end
end
function gun:render(e)
 if _dbg_gun then
 	print(self.shot_timer, e.trans.p.x, e.trans.p.y)
  print(self.controls.fire)
  print(self.fire_delay)
  print(self.fire_sound)
 end
end


local throwable = system {name="throwable"}
throwable.__index = throwable
function throwable:new(controls)
 return setmetatable({
  controls=controls
 }, throwable)
end
function throwable:update(e, dt)
 if self.controls.throw then
  cons_throw(anim, on_land)
  e:destroy()
 end
end
