extends State

var jump_released
var initial_y

## enter ###########################################################

func enter(_opts = {}):
	initial_y = actor.global_position.y
	jump_released = false

	actor.anim.play("jump")
	actor.anim.animation_finished.connect(_on_anim_finished)

	actor.velocity.y = -1 * actor.jump_velocity

## exit ###########################################################

func exit():
	initial_y = null
	jump_released = false
	actor.anim.animation_finished.disconnect(_on_anim_finished)

## anims ###########################################################

func _on_anim_finished():
	if actor.anim.animation == "jump":
		actor.anim.play("air")

## physics ###########################################################

func physics_process(delta):
	if not jump_released and Input.is_action_just_released("jump"):
		jump_released = true

	if jump_released:
		var current_y = actor.global_position.y
		var traveled_y = abs(current_y - initial_y)
		var reached_jump_min = traveled_y >= actor.jump_min_height

		# kill y velocity
		if reached_jump_min:
			actor.velocity.y = lerp(actor.velocity.y, 0.0, 0.3)

	# apply gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.jump_gravity * delta

	if actor.is_on_ceiling():
		actor.velocity.y = lerp(actor.velocity.y, 0.0, 0.3)

	# apply left/right movement
	if actor.move_vector:
		var new_speed = actor.air_speed * actor.move_vector.x * delta
		actor.velocity.x = lerp(actor.velocity.x, new_speed, 0.5)
	else:
		actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.5)

	# check for hitting things like spikes
	var collided = actor.move_and_slide()
	if collided:
		var should_exit = actor.collision_check()
		if should_exit:
			return

	if actor.velocity.y > 0.0:
		machine.transit("Fall")