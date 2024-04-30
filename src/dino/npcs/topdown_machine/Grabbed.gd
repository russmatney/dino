extends State

## enter ###########################################################

func enter(_opts = {}):
	actor.anim.play("grabbed")

	actor.set_collision_mask_value(10, false)
	actor.set_collision_mask_value(11, false)

## exit ###########################################################

func exit(_opts = {}):
	actor.grabbed_by = null

	actor.set_collision_mask_value(10, true)
	actor.set_collision_mask_value(11, true)

## physics ###########################################################

var grab_offset = Vector2(0, -20)
var lerp_amount = 0.8

func physics_process(_delta):
	var player = actor.grabbed_by
	if player == null or not is_instance_valid(player):
		transit("Idle", {home_position=actor.global_position})
		return

	# move toward just above the player
	var target_pos = player.global_position + grab_offset
	actor.global_position = actor.global_position.lerp(target_pos, lerp_amount)

	actor.move_and_slide()
