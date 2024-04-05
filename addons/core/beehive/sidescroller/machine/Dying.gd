extends State

var killed_by
var has_left_floor

## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("dying")
	killed_by = opts.get("killed_by")
	actor.face_body(killed_by)

	actor.velocity.y = -1 * actor.knockback_speed_y
	actor.velocity.x = actor.knockback_speed_x * actor.facing_vector.x * -1 * 2

	has_left_floor = false

## exit ###########################################################

func exit():
	killed_by = null

## physics ###########################################################

func physics_process(delta):
	if not actor.is_on_floor():
		has_left_floor = true
		actor.velocity.y += actor.gravity * delta

	actor.move_and_slide()

	if has_left_floor and actor.is_on_floor():
		transit("Dead")
