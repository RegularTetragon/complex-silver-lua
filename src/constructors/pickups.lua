function cons_pickup(
	anim_roll,
	on_pickup
)
	return function (pos)
 	local e = entity:new()
	 e:add(trans:new())
	 e:add(pickup:new(on_pickup))
	 e:add(col:new(
	 	v2:new(),
	 	v2:new(8,8),
	 	false,
	 	false,
	 	m_player
	 ))
	 e.trans.p = pos
	 local e_ctl = anim_ctl:new {
	 	start=anim:new(anim_roll)
	 }
	 e:add(e_ctl)
	end
end