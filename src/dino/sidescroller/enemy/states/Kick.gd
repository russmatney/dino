extends State

## properties ###################################

func can_bump():
	return true # ?

func can_attack():
	return false

## vars ###################################

var kicked_bodies = []

## enter #####################################################################

func enter(ctx={}):
	var _body = ctx.get("body")
	actor.anim.play("kick")
	actor.move_vector = Vector2.ZERO
	kicked_bodies = []

## exit #####################################################################

func exit():
	kicked_bodies = []

## animations #####################################################################

func on_animation_finished():
	if actor.anim.animation == "kick":
		if kicked_bodies.is_empty():
			# consider 'woosh' if nothing was kicked
			pass
		machine.transit("Idle")

func on_frame_changed():
	if actor.anim.animation == "kick" and actor.anim.frame in [3, 4, 5, 6]:
		# check hitbox_bodies again to see if the body is still there
		for b in actor.hitbox_bodies:
			if b.has_method("take_hit"):
				if not b in kicked_bodies:
					# Cam.hitstop("kickhit", 0.3, 0.1)
					kicked_bodies.append(b)
					b.take_hit({body=actor})

## process #####################################################################

func physics_process(delta):
	if not actor.is_on_floor():
		actor.velocity.y += actor.gravity * delta

	actor.velocity.x = lerp(actor.velocity.x, 0.0, 0.1)

	actor.move_and_slide()
