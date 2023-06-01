@tool
extends CharacterBody2D

@onready var cam_poi = $CamPOI

func _ready():
	match initial_dir:
		DIR.left:
			move_dir = Vector2.LEFT
		DIR.right:
			move_dir = Vector2.RIGHT

	match move_dir:
		Vector2.RIGHT:
			$AnimatedSprite2D.flip_h = true
		Vector2.LEFT:
			$AnimatedSprite2D.flip_h = false

	speed_factor = (randi() % speed_range) - speed_range

	velocity = move_dir * speed

	if Engine.is_editor_hint():
		request_ready()


#######################################################################33
# physics process

var stunned = false
var is_dead = false
enum DIR { left, right }
@export var initial_dir: DIR = DIR.left
var move_dir = Vector2.RIGHT
@export var speed: int = 100
@export var speed_range: int = 90
@export var gravity: int = 2000
var speed_factor = 0

@export var fly_speed: int = 900
@export var fly_range: int = 400
var flying = false


func _physics_process(delta):
	if not Engine.is_editor_hint():
		velocity.y += gravity * delta

		if stunned:
			velocity.x = lerp(velocity.x, 0.0, 0.1)
			set_velocity(velocity)
			set_up_direction(Vector2.UP)
			move_and_slide()
			velocity = velocity
			$AnimatedSprite2D.play("fly")

		elif knocked_back or is_dead:
			velocity.x = lerp(velocity.x, 0.0, 0.9)
			set_velocity(velocity)
			set_up_direction(Vector2.UP)
			move_and_slide()
			velocity = velocity
			$AnimatedSprite2D.play("fly")

		else:
			velocity.x = move_dir.x * max(speed + speed_factor, velocity.x)
			set_velocity(velocity)
			set_up_direction(Vector2.UP)
			move_and_slide()
			velocity = velocity

			if abs(velocity.x) > 0.1:
				$AnimatedSprite2D.play("walk")
			elif velocity.y < -0.1:
				$AnimatedSprite2D.play("fly")
			else:
				$AnimatedSprite2D.play("idle")

			if is_on_wall():
				match move_dir:
					Vector2.LEFT:
						move_dir = Vector2.RIGHT
						$AnimatedSprite2D.flip_h = true
					Vector2.RIGHT:
						move_dir = Vector2.LEFT
						$AnimatedSprite2D.flip_h = false


func fly():
	if not flying and can_hit_player():
		flying = true
		velocity.y = -1 * (fly_speed + (randi() % fly_range) - (fly_range / 3.0))
		await get_tree().create_timer(1).timeout
		flying = false


var knockback_impulse = 200
var knockback_y = 700
var knockback_time = 2
var knocked_back = false


func take_hit(opts={}):
	var body = opts.get("body")
	var dir
	if body.global_position.x < global_position.x:
		dir = Vector2.LEFT
	else:
		dir = Vector2.RIGHT
	$DeadLight.enabled = true
	$StunnedLight.enabled = false
	stunned = false
	knocked_back = true
	velocity = Vector2(dir.x * knockback_impulse, -1 * knockback_y)
	await get_tree().create_timer(knockback_time).timeout
	knocked_back = false
	velocity = Vector2.ZERO
	die()


func die():
	stunned = false
	is_dead = true
	$AnimatedSprite2D.play("fly")
	$AnimatedSprite2D.stop.call_deferred()
	$PointLight2D.enabled = false
	$StunnedLight.enabled = false
	$DeadLight.enabled = true

	cam_poi.active = false


func stun():
	stunned = true
	$AnimatedSprite2D.play("fly")
	$AnimatedSprite2D.stop.call_deferred()
	$PointLight2D.enabled = false
	$StunnedLight.enabled = true

	velocity = Vector2(0, -1 * knockback_y / 2.0)

	await get_tree().create_timer(4).timeout

	stunned = false

	if not is_dead and not knocked_back:
		$PointLight2D.enabled = true
		$AnimatedSprite2D.play()
		$StunnedLight.enabled = false


func player_can_stun():
	return not stunned and not is_dead and not knocked_back


func player_can_hit():
	return stunned


func can_hit_player():
	return not stunned and not is_dead and not knocked_back


#############################################################

var enemies = []
var player


func _on_Detectbox_body_entered(body: Node):
	if body.is_in_group("enemies"):
		enemies.append(body)
		fly()

	if body.is_in_group("player"):
		player = body
		fly()


func _on_Detectbox_body_exited(body: Node):
	if body.is_in_group("enemies"):
		enemies.erase(body)
	if body.is_in_group("player"):
		player = null
