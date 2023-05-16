extends State

var more_jump_ttl
var peak_y_vel = 0.0
var did_hit_ceiling

## enter ###########################################################

func enter(_opts = {}):
	DJZ.play(DJZ.S.jump)
	actor.anim.play("jump")
	actor.anim.animation_finished.connect(_on_anim_finished)

	actor.velocity.y -= actor.base_jump_speed

	more_jump_ttl = actor.more_jump_time
	did_hit_ceiling = false


## exit ###########################################################

func exit():
	did_hit_ceiling = false
	Debug.pr("peak y", peak_y_vel)
	peak_y_vel = 0.0
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
		and actor.is_player and Input.is_action_pressed("jump")\
		and not did_hit_ceiling:
		actor.velocity.y -= actor.more_jump_speed * delta
		# min/max reversed in clamp b/c up is negative-y
		actor.velocity.y = clamp(actor.velocity.y, -actor.max_jump_speed, -actor.base_jump_speed)

	# prevent more jumping after button release
	if Input.is_action_just_released("jump"):
		more_jump_ttl = null

	if actor.velocity.y < peak_y_vel:
		peak_y_vel = actor.velocity.y

	# apply gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta * 3

	if actor.is_on_ceiling():
		# maybe want this, but it's no fun when actually climbing
		# i think we need a similar coyote treatment for this case
		# (clipping a platform when jumping)
		# did_hit_ceiling = true
		actor.velocity.y = lerp(actor.velocity.y, 0.0, 0.4)

	# apply left/right movement
	if actor.move_vector:
		var new_speed = actor.air_speed * actor.move_vector.x * delta
		actor.velocity.x = lerp(actor.velocity.x, new_speed, 0.5)
	else:
		actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.5)

	actor.move_and_slide()

	if actor.velocity.y > 0.0:
		machine.transit("Fall")
