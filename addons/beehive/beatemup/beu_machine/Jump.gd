extends State


var jump_time = 0.6
var jump_ttl

var direction: Vector2

var kick_pressed
var kicked_bodies = []


## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("jump")
	DJZ.play(DJZ.S.jump)
	kick_pressed = false
	jump_ttl = Util.get_(opts, "jump_time", jump_time)
	direction = Util.get_(opts, "direction", actor.move_vector)

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*1.8, jump_ttl/2.0)
	tween.tween_property(actor, "scale", Vector2.ONE, jump_ttl/2.0)


## exit ###########################################################

func exit():
	kicked_bodies = []


## input ###########################################################

func unhandled_input(event):
	if Trolley.is_attack(event) and not kick_pressed:
		kick_pressed = true
		actor.anim.play("jump_kick")
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
			if is_instance_valid(b) and not b in kicked_bodies:
				if "is_dead" in b and not b.is_dead and "machine" in b:
					b.machine.transit("Kicked", {
						direction=actor.facing_vector,
						kicked_by=actor})
					kicked_bodies.append(b)
				elif b.is_in_group("destructibles"):
					b.take_hit({hit_type="kick", body=actor})
					kicked_bodies.append(b)
