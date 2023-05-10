extends State


var jump_time = 0.6
var jump_ttl

var direction: Vector2

var kick_pressed
var kicked_bodies = []


## enter ###########################################################

func enter(opts = {}):
	kick_pressed = false
	kicked_bodies = []
	jump_ttl = Util.get_(opts, "jump_time", jump_time)
	direction = Util.get_(opts, "direction", actor.move_vector)

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*1.8, jump_ttl/2.0)
	tween.tween_property(actor, "scale", Vector2.ONE, jump_ttl/2.0)


## input ###########################################################

func unhandled_input(event):
	if Trolley.is_attack(event) and not kick_pressed:
		kick_pressed = true
		# TODO jump-kick animation
		return


## physics ###########################################################

func physics_process(delta):
	if jump_ttl == null:
		return

	jump_ttl -= delta

	if jump_ttl <= 0:
		transit("Idle")
		return

	var move_vec = direction * actor.jump_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.6)
	actor.move_and_slide()

	if kick_pressed:
		for b in actor.punch_box_bodies:
			if not b in kicked_bodies and "machine" in b:
				b.machine.transit("Kicked", {
					direction=actor.facing_vector,
					kicked_by=actor})
				kicked_bodies.append(b)
