extends State

var more_jump_ttl

## enter ###########################################################

func enter(_opts = {}):
	DJZ.play(DJZ.S.jump)
	actor.anim.play("jump")
	actor.anim.animation_finished.connect(_on_anim_finished)

	actor.velocity.y -= actor.base_jump_speed

	more_jump_ttl = actor.more_jump_time


## exit ###########################################################

func exit():
	more_jump_ttl = null
	actor.anim.animation_finished.disconnect(_on_anim_finished)

## anims ###########################################################

func _on_anim_finished():
	if actor.anim.animation == "jump":
		actor.anim.play("air")


## physics ###########################################################

func physics_process(delta):
	if more_jump_ttl != null:
		more_jump_ttl -= delta
		if more_jump_ttl <= 0:
			more_jump_ttl = null

	# extra jump velocity while held, for some time
	if more_jump_ttl != null and more_jump_ttl > 0.0 \
		and actor.is_player and Input.is_action_pressed("jump"):
		actor.velocity.y -= actor.more_jump_speed * delta

	# apply gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	# apply left/right movement
	if actor.move_vector:
		var new_speed = actor.air_speed * actor.move_vector.x * delta
		actor.velocity.x = lerp(actor.velocity.x, new_speed, 0.5)
	else:
		actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.5)

	actor.move_and_slide()

	if actor.velocity.y > 0.0:
		machine.transit("Fall")
