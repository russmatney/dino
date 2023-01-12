# Jump
extends State

var jump_count = 0

onready var jump_ring_scene = preload("res://src/gunner/player/JumpRing.tscn")


func label():
	return "Jump: " + str(jump_count)


func enter(_ctx = {}):
	actor.anim.animation = "jump"
	actor.velocity.y -= actor.jump_impulse
	actor.velocity.y = max(-actor.jump_impulse, actor.velocity.y)
	Gunner.play_sound("jump")
	actor.can_wall_jump = false

	create_jump_ring()

	jump_count += 1


func create_jump_ring():
	var jr = jump_ring_scene.instance()
	jr.position = actor.get_global_position()
	Navi.add_child_to_current(jr)
	if jump_count > 0:
		actor.notif("Wall Jump!", {"dupe": true})
	# we might care about z-index


func physics_process(delta):
	actor.velocity.y += actor.gravity * delta

	if actor.move_dir:
		actor.velocity.x = actor.air_speed * actor.move_dir.x
		# TODO clamp jump speed
	else:
		# slow down
		actor.velocity.x = actor.velocity.x * 0.99 * delta

	actor.velocity = actor.move_and_slide(actor.velocity, Vector2.UP)

	if not actor.firing:
		actor.update_facing()

	if actor.is_on_floor():
		jump_count = 0
		machine.transit("Idle")

	if actor.is_on_wall():
		if not actor.can_wall_jump:
			Gunner.play_sound("step")
			actor.can_wall_jump = true
