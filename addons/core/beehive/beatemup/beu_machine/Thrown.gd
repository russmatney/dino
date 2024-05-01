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

var next_state

## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("thrown")
	next_state = opts.get("next_state")

	actor.anim.animation_finished.connect(on_animation_finished)

	thrown_ttl = U.get_(opts, "thrown_time", thrown_time)
	direction = U.get_(opts, "direction", direction)
	thrown_by = U.get_(opts, "thrown_by", thrown_by)

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
	actor.punch_box.set_collision_mask_value(10, true)

func on_first_bounce():
	actor.take_hit({hit_type="throw", body=thrown_by})
	Sounds.play(Sounds.S.heavy_fall)
	Juice.screenshake(0.3)
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
		if next_state:
			transit(next_state)
		else:
			actor.anim.play("get_up")
		return

	var move_vec = direction * thrown_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.6)
	actor.move_and_slide()

	if not hit_ground:
		for b in actor.punch_box_bodies:
			if is_instance_valid(b) and not b in hit_bodies:
				if "is_dead" in b and not b.is_dead and "machine" in b and b != actor and b != thrown_by:
					b.machine.transit("HitByThrow", {
						direction=direction,
						hit_by=actor})
					hit_bodies.append(b)
				elif b.is_in_group("destructibles"):
					b.take_hit({hit_type="hit_by_throw", body=actor})
					hit_bodies.append(b)
