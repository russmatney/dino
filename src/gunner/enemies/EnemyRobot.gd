extends KinematicBody2D

onready var anim = $AnimatedSprite
onready var machine = $Machine
onready var collision_shape = $CollisionShape2D

var dead = false

########################################################
# ready

func _ready():
	Respawner.register_respawn(self)

########################################################
# process

export(float) var max_y = 5000.0

func _process(_delta):
	# if target offscreen and player close enough/line-of-sight
	if not on_screen and not machine.state.name == "Dead":
		offscreen_indicator.activate(self)
	else:
		offscreen_indicator.deactivate()

	if get_global_position().y >= max_y and not machine.state.name == "Dead":
		die(true)

	if player and machine.state.name in ["Idle", "Walk"]:
		vision_ray.set_cast_to(to_local(player.get_global_position()))
		if vision_ray.is_colliding():
			var coll = vision_ray.get_collider()
			if coll.is_in_group("player"):
				machine.transit("Attack")

########################################################
# movement

var velocity = Vector2.ZERO
var speed = 50
var gravity = 900

var facing_dir = Vector2.LEFT
var move_dir

onready var bullet_position = $BulletPosition
onready var front_ray = $FrontRay
onready var vision_box = $VisionBox
onready var vision_ray = $VisionRay

func face_dir(dir):
	if dir == Vector2.RIGHT:
		face_left()
	elif dir == Vector2.LEFT:
		face_right()

func turn():
	if facing_dir == Vector2.RIGHT:
		face_left()
	elif facing_dir == Vector2.LEFT:
		face_right()

func face_right():
	facing_dir = Vector2.RIGHT
	anim.flip_h = true

	if bullet_position.position.x < 0:
		bullet_position.position.x *= -1

	if front_ray.position.x < 0:
		front_ray.position.x *= -1

	if vision_ray.position.x < 0:
		vision_ray.position.x *= -1

	if vision_box.position.x < 0:
		vision_box.position.x *= -1

func face_left():
	facing_dir = Vector2.LEFT
	anim.flip_h = false

	if bullet_position.position.x > 0:
		bullet_position.position.x *= -1

	if front_ray.position.x > 0:
		front_ray.position.x *= -1

	if vision_ray.position.x > 0:
		vision_ray.position.x *= -1

	if vision_box.position.x > 0:
		vision_box.position.x *= -1

############################################################
# health

var initial_health = 2
onready var health = initial_health

signal health_change(health)
signal dead

func take_damage(body=null, d = 1):
	health -= d
	emit_signal("health_change", health)

	var dir = Vector2.DOWN
	if body and body.global_position.x > global_position.x:
		dir = Vector2.LEFT
	elif body:
		dir = Vector2.RIGHT

	machine.transit("Knockback", {"dir": dir, "dead": health <= 0})

func die(remove=false):
	dead = true
	emit_signal("dead")
	if remove:
		queue_free()

########################################################
# offscreen indicator

onready var offscreen_indicator = $OffscreenIndicator
var on_screen = false
func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true

func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false


########################################################
# vision box

var player

func _on_VisionBox_body_entered(body:Node):
	if body.is_in_group("player") and not body.dead:
		player = body

func _on_VisionBox_body_exited(body:Node):
	if body.is_in_group("player") and not body.dead:
		player = null

########################################################
# fire

onready var bullet_scene = preload("res://src/gunner/weapons/Bullet.tscn")
var bullet_impulse = 800
var fire_rate = 0.2
var bullet_knockback = 2

signal fired_bullet(bullet)

func fire_at_player():
	if player and not player.dead and is_instance_valid(player):
		var bullet = bullet_scene.instance()
		bullet.position = bullet_position.get_global_position()
		bullet.add_collision_exception_with(self)
		Navi.current_scene.call_deferred("add_child", bullet)

		var angle_to_player = bullet.position.direction_to(player.global_position)

		bullet.rotation = angle_to_player.angle()
		bullet.apply_impulse(Vector2.ZERO, angle_to_player * bullet_impulse)

		GunnerSounds.play_sound("fire")
		emit_signal("fired_bullet", bullet)
