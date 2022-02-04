local layerset = require "engine.layer"
_dbg_rb = false
_dbg_col = false
_dbg_gun = false
_dbg_anim_ctl = false
_dbg_systems = false
_dbg_ctl = false

layer_world = layerset:from_list {1}
layer_enemy = layerset:from_list {2}
layer_player = layerset:from_list{3}
layer_projectile = layerset:from_list{4}
layer_shrapnel = layerset:from_list{5}
layer_all = layer_world + layer_enemy + layer_player + layer_projectile + layer_shrapnel

grav = 300
air_accel = 200
gnd_accel = 100
walkspeed = 60
jump_v = 90
max_jump_time = .15
screen_shake = 0
explosion_speed = 60
explosion_angles = 4
explosion_rs = 1

zoom = 2