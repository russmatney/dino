extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var collision_shape = $CollisionShape2D

var is_dead = false

########################################################
# ready


func _ready():
	OffscreenIndicator.add(self, {
		# could instead depend on a fn like this directly on the passed node
		is_active=should_show_offscreen_indicator})

func should_show_offscreen_indicator():
	return not machine.state.name == "Dead"


########################################################
# process

@export var max_y: float = 5000.0


func _process(_delta):
	if get_global_position().y >= max_y and not machine.state.name == "Dead":
		die(true)

	if player and machine.state.name in ["Idle", "Walk"]:
		vision_ray.set_target_position(to_local(player.get_global_position()))
		if vision_ray.is_colliding():
			var coll = vision_ray.get_collider()
			if coll.is_in_group("player"):
				machine.transit("Attack")


########################################################
# movement

var speed = 50
var gravity = 900

var facing_dir = Vector2.LEFT
var move_dir

@onready var arrow_position = $ArrowPosition
@onready var front_ray = $FrontRay
@onready var vision_box = $VisionBox
@onready var vision_ray = $VisionRay


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

	if arrow_position.position.x < 0:
		arrow_position.position.x *= -1

	if front_ray.position.x < 0:
		front_ray.position.x *= -1

	if vision_ray.position.x < 0:
		vision_ray.position.x *= -1

	if vision_box.position.x < 0:
		vision_box.position.x *= -1


func face_left():
	facing_dir = Vector2.LEFT
	anim.flip_h = false

	if arrow_position.position.x > 0:
		arrow_position.position.x *= -1

	if front_ray.position.x > 0:
		front_ray.position.x *= -1

	if vision_ray.position.x > 0:
		vision_ray.position.x *= -1

	if vision_box.position.x > 0:
		vision_box.position.x *= -1


############################################################
# health

var initial_health = 2
@onready var health = initial_health

signal health_change(health)
signal died

func take_hit(opts={}):
	take_damage(opts)

func take_damage(opts={}):
	var body = opts.get("body")
	var d = opts.get("damage", 1)
	Cam.freezeframe("enemy_damage_hitstop", 0.2, 0.3, 0.3)
	health -= d
	health_change.emit(health)

	Sounds.play(Sounds.S.enemy_hit)

	var dir = Vector2.DOWN
	if body and body.global_position.x > global_position.x:
		dir = Vector2.LEFT
	elif body:
		dir = Vector2.RIGHT

	machine.transit("Knockback", {"dir": dir, "dead": health <= 0})


func die(remove_at = false):
	is_dead = true
	died.emit()

	Sounds.play(Sounds.S.enemy_dead)
	if remove_at:
		queue_free()


########################################################
# vision box

var player


func _on_VisionBox_body_entered(body: Node):
	if body.is_in_group("player") and not body.is_dead:
		Sounds.play(Sounds.S.enemy_sees_you)
		player = body


func _on_VisionBox_body_exited(body: Node):
	if body.is_in_group("player") and not body.is_dead:
		player = null


########################################################
# fire

@onready var arrow_scene = preload("res://src/dino/weapons/arrow/Arrow.tscn")
var arrow_impulse = 800
var fire_rate = 0.2
var arrow_knockback = 2


func fire_at_player():
	if player and not player.is_dead and is_instance_valid(player):
		var arrow = arrow_scene.instantiate()
		arrow.position = arrow_position.get_global_position()
		arrow.add_collision_exception_with(self)
		U.add_child_to_level(self, arrow)

		var angle_to_player = arrow.position.direction_to(player.global_position + Vector2(0, -15))

		arrow.rotation = angle_to_player.angle()
		arrow.apply_impulse(angle_to_player * arrow_impulse, Vector2.ZERO)

		Sounds.play(Sounds.S.fire)
