extends State

var thrown_time = 0.8
var thrown_ttl
var thrown_speed
var thrown_by

var direction

# bodies collided with while thrown
var hit_bodies = []

var hit_ground
var og_collision_mask

## enter ###########################################################

func enter(opts = {}):
	# TODO perfect the thrown + bounce animation timing
	actor.anim.play("thrown")

	actor.anim.animation_finished.connect(on_animation_finished)

	thrown_ttl = Util.get_(opts, "thrown_time", thrown_time)
	direction = Util.get_(opts, "direction", direction)
	thrown_by = Util.get_(opts, "thrown_by", thrown_by)

	actor.face_body(thrown_by)
	actor.flip_facing()

	thrown_speed = thrown_by.throw_speed
	thrown_by.remove_attacker(actor)

	hit_ground = false

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*1.8, thrown_ttl/3.0)
	tween.tween_property(actor, "scale", Vector2.ONE, thrown_ttl/3.0)
	tween.tween_callback(on_first_bounce)
	tween.tween_property(actor, "scale", Vector2.ONE*1.4, thrown_ttl/6.0)
	tween.tween_property(actor, "scale", Vector2.ONE, thrown_ttl/6.0)

	og_collision_mask = actor.punch_box.collision_mask

	actor.punch_box.set_collision_mask_value(2, true)
	actor.punch_box.set_collision_mask_value(4, true)
	actor.punch_box.set_collision_mask_value(8, true)
	actor.punch_box.set_collision_mask_value(10, true)

func on_first_bounce():
	actor.take_damage("throw", thrown_by)
	DJZ.play(DJZ.S.heavy_fall)
	Cam.screenshake(0.4)
	hit_ground = true
	actor.punch_box.collision_mask = og_collision_mask

## exit ###########################################################

func exit():
	direction = null
	hit_bodies = []

	actor.anim.animation_finished.disconnect(on_animation_finished)

## anim finished ###########################################################

func on_animation_finished():
	if actor.anim.animation == "get_up":
		transit("Idle")

## physics ###########################################################

func physics_process(delta):
	if thrown_ttl == null:
		return

	thrown_ttl -= delta

	if thrown_ttl <= 0:
		actor.anim.play("get_up")
		return

	var move_vec = direction * thrown_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.6)
	actor.move_and_slide()

	if not hit_ground:
		for b in actor.punch_box_bodies:
			if not b in hit_bodies and "machine" in b and b != actor and b != thrown_by:
				b.machine.transit("HitByThrow", {
					direction=direction,
					hit_by=actor})
				hit_bodies.append(b)