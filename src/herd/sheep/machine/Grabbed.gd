extends State

## enter ###########################################################


func enter(_opts = {}):
	actor.anim.play("grabbed")

func exit(_opts = {}):
	actor.grabbed_by = null

## physics ###########################################################

var grab_offset = Vector2(0, -20)
var lerp_amount = 0.8

func physics_process(_delta):
	var player = actor.grabbed_by
	if player == null or not is_instance_valid(player):
		transit("Idle")
		return

	var target_pos = player.global_position + grab_offset

	# move toward
	# TODO incorporate delta?
	actor.global_position = actor.global_position.lerp(target_pos, lerp_amount)

	actor.move_and_slide()
