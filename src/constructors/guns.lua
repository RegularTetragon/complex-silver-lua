function cons_gun(
	ammo,
	fire_rate,
	cons_proj,
	anim_ctl,
	offset,
	fire_sound,
	owner_knockback
)
 return function(
  spawner,
  player
 )
  sfx(5)
  local e = entity:new()
  e:add(trans:new())
  e:add(anim_ctl)
  e.anim_ctl:trans("shoot",
   function()
    if e.anim_ctl.states.shoot.looped then
    	return "start"
    end
   end
  )
  e:add(
  	weld:new(
  	 player,
  	 offset
  	)
  )
  e:add(
   gun:new(
    ammo,
    fire_rate,
    cons_proj, 
    player,
    fire_sound,
    owner_knockback
   )
  )
		return true
 end
end;

function cons_proj(
 n,
 spread,
 speed,
 anim
)
 return function(e)
  local projs = {}
  for i = 1, n do
   local p = entity:new()
   add(projs, p)
   p:add(trans:new())
   p.trans.p = e.trans.p
   p.trans.mirror_x = e.trans.mirror_x
   p:add(anim)
   p:add(rb:new(0, 0))
   p:add(col:new(
   	v2:new(2,2),
   	v2:new(6,6),
   	false,
   	false,
   	m_world | m_enemy,
   	m_projectile
   ))
   p.rb.v =
   	v2:new(
   	 e.trans.mirror_x and -speed or speed,
   	 (2*rnd() - 1) * spread
   	)
   p:add(debris:new(1))
  end
  return projs
 end
end

function cons_grenade(e)
 local ps = cons_proj(
  1,0,100, anim:new {35, 36}
 )(e)
 for _, p in pairs(ps) do
	 p.rb.gravity = 2
	 p.rb.v =	 p.rb.v + up * 128
	 p.debris:on_destroy(
	  function()
	 	 cons_explosion(
	 	  1,
	 	  p.trans.p,
	 	  p_enemy
	 	 )
	  end
	 )
	end
end

function cons_bullet(
 n,
 spread,
 speed,
 anim,
 dmg,
 layer
)
 return function(e)
  local bs = cons_proj(n, spread, speed, anim)(e)
  for _, b in pairs(bs) do
   b:add(damager:new(dmg, layer))
 		b:add(debris:new(1))
 	end
 end
end

function cons_rocket(e)
 local rs = cons_proj(
  1,
  0,
  80,
  anim:new {14,30}
 )(e)
 for _, r in pairs(rs) do
  r.col.mask = m_world
		r.col:on_collision(
	  function(r, with)
	   if with != player then
	   cons_explosion(
	    1,
	    r.trans.p,
	    1
	   )
	   r:destroy()
	   end
	  end
	 )
	end
	return rs
end

function cons_throw(
 anim,
 on_land,
 from
)
  local e = entity:new()
  
  e:add(
  	trans:new()
  )
  e.trans.p = from.trans.p
  e:add(col:new(
  	v2:new(),
  	v2:new(8,8),
  	false,
  	false,
  	world
  ))
  e:add(rb:new())
  e.rb.v = v2:new(
   from.trans.mirror_x
   and
   -throw_speed
   or
   throw_speed,
   20
  )
end

local cons_shotgun = cons_gun(
 4, --ammo
 1, --rate
 cons_bullet(
  4, --pellets
  75, --spread
  150, --speed
  anim:new {10}, --sprite,
  1,--dmg,
  1--layer
 ),
 anim_ctl:new{
  start=anim:new {6},
  shoot=anim:new {7, 6}
 },
 v2:new(4,-1),
 1,
 60
)

local cons_grenade_launcher =
cons_gun(
 8, --ammo
 1, --rate
 cons_grenade,
 anim_ctl:new{
  start=anim:new {37},
  shoot=anim:new {37}
 },
 v2:new(4,-1),
 1,
 60
)

local cons_rifle = cons_gun(
 16, --ammo
 .25, --rate
 cons_bullet(
  1, --pellets
  30, --spread
  400, --speed
  anim:new {9}, --spr,
  1, --dmg
  1 --layer
 ),
 anim_ctl:new{
  start=anim:new {24},
  shoot=anim:new {24}
 },
 v2:new(4,-1),
 0,
 10
)

local cons_rocket_launcher = cons_gun(
 16, --ammo
 1, --rate
 cons_rocket,
 anim_ctl:new{
  start=anim:new {13},
  shoot=anim:new {13}
 },
 v2:new(0, -2),
 2,
 75
)

local cons_pistol = cons_gun(
 8, --ammo
 .5, --rate
 cons_bullet(
  1, --pellets
  2, --spread
  300, --speed
  anim:new {9}, -- sprite,
  1, --damage
  1  --layer
 ),
 anim_ctl:new{
  start=anim:new {8},
  shoot=anim:new {25, 8}
 },
 v2:new(4,-1),
 0, --sound,
 30 -- knockback
)
