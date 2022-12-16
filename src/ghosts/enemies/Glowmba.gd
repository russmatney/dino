tool
extends KinematicBody2D

onready var kink_label = $KinkLabel

export(Resource) var kink_file = preload("res://src/ghosts/enemies/glowmba.ink.json")

var ink_player


func _ready():
	match initial_dir:
		DIR.left:
			move_dir = Vector2.LEFT
		DIR.right:
			move_dir = Vector2.RIGHT

	match move_dir:
		Vector2.RIGHT:
			$AnimatedSprite.flip_h = true
		Vector2.LEFT:
			$AnimatedSprite.flip_h = false

	speed_factor = (randi() % speed_range) - speed_range

	Ghosts.create_notification("Gloomba alive!")

	if Engine.editor_hint:
		request_ready()

#######################################################################33
# physics process

var dead = false
enum DIR { left, right }
export(DIR) var initial_dir = DIR.left
var move_dir = Vector2.RIGHT
export(int) var speed = 100
export(int) var speed_range = 90
export(int) var gravity := 4000
var speed_factor = 0

var velocity = move_dir * speed

export(int) var fly_speed := 1500
export(int) var fly_range := 400
var flying = false

func _physics_process(delta):
	if not Engine.editor_hint:
		velocity.y += gravity * delta

		if not dead:
			velocity.x = move_dir.x * max(speed + speed_factor, velocity.x)
			velocity = move_and_slide(velocity, Vector2.UP)

			if abs(velocity.x) > 0.1:
				$AnimatedSprite.animation = "walk"
			elif velocity.y < -0.1:
				$AnimatedSprite.animation = "fly"
			else:
				$AnimatedSprite.animation = "idle"

			if is_on_wall():
				match move_dir:
					Vector2.LEFT:
						move_dir = Vector2.RIGHT
						$AnimatedSprite.flip_h = true
					Vector2.RIGHT:
						move_dir = Vector2.LEFT
						$AnimatedSprite.flip_h = false

func fly():
	if not flying:
		flying = true
		velocity.y = -1 * (fly_speed + (randi() % fly_range) - (fly_range/3.0))
		yield(get_tree().create_timer(1), "timeout")
		flying = false


#############################################################

var enemies = []
var player

func _on_Detectbox_body_entered(body:Node):
	if body.is_in_group("enemies"):
		enemies.append(body)
		fly()

	if body.is_in_group("player"):
		player = body
		fly()

func _on_Detectbox_body_exited(body:Node):
	if body.is_in_group("enemies"):
		enemies.erase(body)
	if body.is_in_group("player"):
		player = null
