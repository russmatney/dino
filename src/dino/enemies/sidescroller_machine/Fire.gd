extends State

## properties ###################################

func can_bump():
	return true

func can_attack():
	return false

func can_hop():
	return false

## enter ####################################################

func enter(_ctx={}):
	actor.anim.play("shoot")

	bullets_til_break = break_every
	cool_down = 0

## physics ####################################################

var break_every = 2
var bullets_til_break
var last_bullet

var cool_down = 0

func physics_process(delta):
	if actor.can_see_player and can_fire():
		fire()
		cool_down = fire_cooldown

	if cool_down > 0:
		cool_down -= delta

	if not actor.can_see_player and cool_down <= 0:
		machine.transit("Run")
		return

	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed/5.0)
	actor.velocity.y = move_toward(actor.velocity.y, 0, actor.speed/5.0)
	actor.move_and_slide()

## fire control ####################################################

var fire_cooldown = 1
func can_fire():
	return cool_down <= 0

func _on_hit(bullet):
	# if bullet back_fired, we handle state change from actor.take_hit()
	if not bullet.firing_back:
		# hit player, take a break
		machine.transit("Laugh", {laugh_for=fire_cooldown, next_state="Fire"})

func _on_bullet_dying(_bullet):
	if not actor.can_see_player:
		machine.transit("Run")

## fire ####################################################

var bullet_scene = preload("res://src/dino/weapons/spell/Spell.tscn")
var bullet_impulse = 100
var bullet_knockback = 0

func fire():
	DJZ.play(DJZ.S.boss_shoot)

	var bullet = bullet_scene.instantiate()

	# meta
	bullet.bullet_dying.connect(_on_bullet_dying)
	bullet.hit.connect(_on_hit)

	# position
	bullet.position = actor.get_global_position()

	# add child
	U.add_child_to_level(self, bullet)

	# rotate and impulse
	var to_target = actor.to_global(actor.los.target_position) - actor.global_position
	to_target = to_target.normalized()
	var impulse = to_target * bullet_impulse
	var rot = to_target.angle()
	bullet.fire(impulse, rot)

	# push back when firing
	var pos = actor.get_global_position()
	pos += -1 * to_target * bullet_knockback
	actor.set_global_position(pos)

	return bullet


# @onready var arrow_scene = preload("res://src/dino/weapons/Arrow.tscn")
# var arrow_impulse = 800
# var fire_rate = 0.2
# var arrow_knockback = 2
# func fire_at_player():
# 	if player and not player.is_dead and is_instance_valid(player):
# 		var arrow = arrow_scene.instantiate()
# 		arrow.position = arrow_position.get_global_position()
# 		arrow.add_collision_exception_with(self)
# 		U.add_child_to_level(self, arrow)

# 		var angle_to_player = arrow.position.direction_to(player.global_position + Vector2(0, -15))

# 		arrow.rotation = angle_to_player.angle()
# 		arrow.apply_impulse(angle_to_player * arrow_impulse, Vector2.ZERO)

# 		DJZ.play(DJZ.S.fire)
