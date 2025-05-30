extends State

var dying_time = 0.8
var dying_ttl
var direction

# bodies collided with while dying
var hit_bodies = []

var killed_by
var hit_ground
var og_collision_mask

## enter ###########################################################

func enter(opts = {}):
	actor.anim.play("thrown")

	killed_by = opts.get("killed_by")

	dying_ttl = U.get_(opts, "dying_time", dying_time)
	direction = U.get_(opts, "direction", direction)

	hit_ground = false

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE*1.8, dying_ttl/3.0)
	tween.tween_property(actor, "scale", Vector2.ONE, dying_ttl/3.0)
	tween.tween_callback(on_first_bounce)
	tween.tween_property(actor, "scale", Vector2.ONE*1.4, dying_ttl/6.0)
	tween.tween_property(actor, "scale", Vector2.ONE, dying_ttl/6.0)

	og_collision_mask = actor.punch_box.collision_mask

	actor.punch_box.set_collision_mask_value(2, true)
	actor.punch_box.set_collision_mask_value(4, true)
	actor.punch_box.set_collision_mask_value(10, true)

func on_first_bounce():
	Sounds.play(Sounds.S.heavy_fall)
	Juice.screenshake(0.4)
	hit_ground = true
	actor.punch_box.collision_mask = og_collision_mask

## exit ###########################################################

func exit():
	direction = null
	hit_bodies = []

## physics ###########################################################

func physics_process(delta):
	if dying_ttl == null:
		return

	dying_ttl -= delta

	if dying_ttl <= 0:
		transit("Dead")
		return

	var move_vec = direction * actor.dying_knockback_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.6)
	actor.move_and_slide()

	if not hit_ground:
		for b in actor.punch_box_bodies:
			if not b.is_dead and not b in hit_bodies and "machine" in b and b != actor and b != killed_by:
				b.machine.transit("HitByThrow", {
					direction=direction,
					hit_by=actor})
				hit_bodies.append(b)
