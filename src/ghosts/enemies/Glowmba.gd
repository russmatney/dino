tool
extends KinematicBody2D

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

var stunned = false
var dead = false
enum DIR { left, right }
export(DIR) var initial_dir = DIR.left
var move_dir = Vector2.RIGHT
export(int) var speed = 100
export(int) var speed_range = 90
export(int) var gravity := 2000
var speed_factor = 0

var velocity = move_dir * speed

export(int) var fly_speed := 900
export(int) var fly_range := 400
var flying = false

func _physics_process(delta):
	if not Engine.editor_hint:
		if not stunned:
			velocity.y += gravity * delta

		if stunned:
			velocity.x = lerp(velocity.x, 0, 0.1)
			velocity = move_and_slide(velocity, Vector2.UP)

		elif knocked_back or dead:
			velocity.x = lerp(velocity.x, 0, 0.9)
			velocity = move_and_slide(velocity, Vector2.UP)
			$AnimatedSprite.animation = "fly"

		else:
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
	if not flying and can_hit_player():
		flying = true
		velocity.y = -1 * (fly_speed + (randi() % fly_range) - (fly_range/3.0))
		yield(get_tree().create_timer(1), "timeout")
		flying = false

var knockback_impulse = 200
var knockback_y = 700
var knockback_time = 2
var knocked_back = false

func hit(dir):
	$DeadLight.enabled = true
	$StunnedLight.enabled = false
	stunned = false
	knocked_back = true
	velocity = Vector2(dir.x * knockback_impulse, -1 * knockback_y)
	yield(get_tree().create_timer(knockback_time), "timeout")
	knocked_back = false
	velocity = Vector2.ZERO
	die()

func die():
	stunned = false
	dead = true
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.playing = false
	$Light2D.enabled = false
	$StunnedLight.enabled = false
	$DeadLight.enabled = true

func stun():
	stunned = true
	$AnimatedSprite.animation = "idle"
	$AnimatedSprite.playing = false
	$Light2D.enabled = false
	$StunnedLight.enabled = true

	yield(get_tree().create_timer(4), "timeout")

	stunned = false

	if not dead and not knocked_back:
		$Light2D.enabled = true
		$AnimatedSprite.playing = true
		$StunnedLight.enabled = false

func player_can_stun():
	return not stunned and not dead and not knocked_back

func player_can_hit():
	return stunned

func can_hit_player():
	return not stunned and not dead and not knocked_back

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
