extends State

var knocked_by
var has_left_floor

## properties ###########################################################

func ignore_input():
	return true

func can_bump():
	return false

func can_act():
	return false

## enter ###########################################################

func enter(opts = {}):
	if actor.anim.sprite_frames.has_animation("knocked_back"):
		actor.anim.play("knocked_back")
	knocked_by = opts.get("knocked_by")
	actor.face_body(knocked_by)

	actor.velocity.y = -1 * actor.knockback_speed_y
	actor.velocity.x = actor.knockback_speed_x * actor.facing_vector.x * -1

	has_left_floor = false

## exit ###########################################################

func exit():
	knocked_by = null

## physics ###########################################################

func physics_process(delta):
	if not actor.is_on_floor():
		has_left_floor = true
		actor.velocity.y += actor.gravity * delta

	actor.move_and_slide()

	if has_left_floor and actor.is_on_floor():
		transit("Idle")