extends State

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

var bullet_scene = preload("res://addons/core/beehive/sidescroller_enemy/Spell.tscn")
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
	var to_player = actor.to_global(actor.los.target_position) - actor.global_position
	to_player = to_player.normalized()
	var impulse = to_player * bullet_impulse
	var rot = to_player.angle()
	bullet.fire(impulse, rot)

	# push back when firing
	var pos = actor.get_global_position()
	pos += -1 * to_player * bullet_knockback
	actor.set_global_position(pos)

	return bullet
