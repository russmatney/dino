extends CharacterBody2D

@onready var machine = $Machine
@onready var anim = $AnimatedSprite2D
@onready var los = $LineOfSight

#####################################################
# ready

func _ready():
	if not Engine.is_editor_hint():
		machine.start()
		machine.transitioned.connect(_on_transit)

	restore()
	Hotel.check_in(self)

func _on_transit(state_label):
	Debug.pr(state_label)

#####################################################
# hotel

func restore():
	var data = Hotel.check_out(self)
	if data:
		health = data.get("health", initial_health)

func hotel_data():
	return {health=health}

#####################################################
# movement

const SPEED = 200

#####################################################
# process

func _physics_process(delta):
	if MvaniaGame.player:
		var player_pos = MvaniaGame.player.global_position
		los.target_position = to_local(player_pos)

		if los.is_colliding():
			can_see_player = true

		if can_see_player:
			fire()

	if fire_cooldown_ttl:
		fire_cooldown_ttl -= delta
		if fire_cooldown_ttl <= 0:
			fire_cooldown_ttl = null
	if fire_burst_ttl:
		fire_burst_ttl -= delta
		if fire_burst_ttl <= 0:
			fire_burst_ttl = null

#####################################################
# attack

var can_see_player
var max_bullets = 3

func can_fire():
	return len(bullets) < max_bullets and fire_cooldown_ttl == null and fire_burst_ttl == null

var bullet_scene = preload("res://src/mvania19/bosses/beefstronaut/Bullet.tscn")
var bullet_impulse = 100
var bullet_knockback = 0.2

signal fired_bullet(bullet)

var bullets = []

func fire_burst_rate():
	return randf_range(0.3, 0.8)
var fire_burst_ttl
var fire_cooldown = 5
var fire_cooldown_ttl

func _on_hit(bullet):
	if not bullet.firing_back:
		# take a break
		fire_cooldown_ttl = fire_cooldown

func _on_bullet_dying(bullet):
	bullets.erase(bullet)

func fire():
	if can_fire():
		var bullet = bullet_scene.instantiate()
		bullets.append(bullet)

		fire_burst_ttl = fire_burst_rate()
		if len(bullets) >= max_bullets:
			fire_cooldown_ttl = fire_cooldown

		bullet.bullet_dying.connect(_on_bullet_dying)
		bullet.hit.connect(_on_hit)

		bullet.position = get_global_position()
		bullet.add_collision_exception_with(self)

		Navi.current_scene.call_deferred("add_child", bullet)

		var to_player = to_global(los.target_position) - global_position
		to_player = to_player.normalized()

		var impulse = to_player * bullet_impulse
		var rot = to_player.angle()
		bullet.fire(impulse, rot)

		emit_signal("fired_bullet", bullet)

		# push back when firing
		var pos = get_global_position()
		pos += -1 * to_player * bullet_knockback
		set_global_position(pos)

#####################################################
# take_hit

var initial_health = 5
var health

func take_hit(opts={}):
	var damage = opts.get("damage", 1)
	var _dir = opts.get("direction", Vector2.UP)

	health -= damage
	Debug.pr("took hit! health", health)

	# TODO knockback state, animations, handle death there
	if health <= 0:
		queue_free()

