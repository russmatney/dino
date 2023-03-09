extends State

#####################################################
# enter

func enter(_ctx={}):
	# TODO firing animation
	actor.anim.play("jump")

	bullets_til_break = break_every

#####################################################
# physics

var break_every = 3
var bullets_til_break
var last_bullet

func physics_process(delta):
	if actor.can_see_player and can_fire():
		last_bullet = fire()

		if bullets_til_break:
			bullets_til_break -= 1

	if fire_burst_ttl:
		fire_burst_ttl -= delta
		if fire_burst_ttl <= 0:
			fire_burst_ttl = null

	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED/5.0)
	actor.move_and_slide()

#####################################################
# fire control

func fire_burst_rate():
	return randf_range(0.5, 0.9)
var fire_burst_ttl
var fire_cooldown = 3

func can_fire():
	return fire_burst_ttl == null and bullets_til_break and bullets_til_break > 0

func _on_hit(bullet):
	# if bullet back_fired, we handle state change from actor.take_hit()
	if not bullet.firing_back:
		# hit player, take a break
		machine.transit("Laughing", {laugh_for=fire_cooldown, next_state="Firing"})

func _on_bullet_dying(bullet):
	bullets.erase(bullet)

	if bullets_til_break <= 0 and bullet == last_bullet:
		machine.transit("Idle", {wait_for=fire_cooldown, next_state="Warping"})

#####################################################
# fire logic

var bullets = []

var bullet_scene = preload("res://src/mvania19/bosses/beefstronaut/Bullet.tscn")
var bullet_impulse = 100
var bullet_knockback = 1

func fire():
	fire_burst_ttl = fire_burst_rate()

	var bullet = bullet_scene.instantiate()

	# meta
	bullets.append(bullet)
	bullet.bullet_dying.connect(_on_bullet_dying)
	bullet.hit.connect(_on_hit)

	# position
	bullet.position = actor.get_global_position()

	# add child
	Navi.current_scene.call_deferred("add_child", bullet)

	# rotate and impulse
	# using los.target_position for player position
	var to_player = actor.to_global(actor.los.target_position) - actor.global_position
	to_player = to_player.normalized()
	var impulse = to_player * bullet_impulse
	var rot = to_player.angle()
	bullet.fire(impulse, rot)

	# signal
	actor.fired_bullet.emit(bullet)

	# push back when firing
	var pos = actor.get_global_position()
	pos += -1 * to_player * bullet_knockback
	actor.set_global_position(pos)

	return bullet
