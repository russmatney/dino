extends KinematicBody2D

onready var anim = $AnimatedSprite
onready var machine = $Machine

########################################################
# ready

func _ready():
	pass # Replace with function body.

########################################################
# process

func _process(_delta):
	# if target offscreen and player close enough/line-of-sight
	if not on_screen:
		offscreen_indicator.activate(self)
	else:
		offscreen_indicator.deactivate()

########################################################
# movement

var velocity = Vector2.ZERO
var speed = 50
var gravity = 900

var facing = Vector2.LEFT
var move_dir

onready var bullet_position = $BulletPosition
onready var front_ray = $FrontRay

func face_dir(dir):
	if dir == Vector2.RIGHT:
		face_left()
	elif dir == Vector2.LEFT:
		face_right()

func turn():
	if facing == Vector2.RIGHT:
		face_left()
	elif facing == Vector2.LEFT:
		face_right()


func face_right():
	facing = Vector2.RIGHT
	anim.flip_h = true

	if bullet_position.position.x < 0:
		bullet_position.position.x *= -1

	if front_ray.position.x < 0:
		front_ray.position.x *= -1

func face_left():
	facing = Vector2.LEFT
	anim.flip_h = false

	if bullet_position.position.x > 0:
		bullet_position.position.x *= -1

	if front_ray.position.x > 0:
		front_ray.position.x *= -1

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
	else:
		dir = Vector2.RIGHT

	machine.transit("Knockback", {"dir": dir, "dead": health <= 0})

func die():
	print("enemy dead")
	emit_signal("dead")

########################################################
# offscreen indicator

onready var offscreen_indicator = $OffscreenIndicator
var on_screen = false
func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true

func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
