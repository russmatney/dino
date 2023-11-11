extends State

var directions = [
	Vector2.UP,
	Vector2.UP + Vector2.LEFT,
	Vector2.UP + Vector2.RIGHT,
	Vector2.DOWN,
	Vector2.DOWN + Vector2.LEFT,
	Vector2.DOWN + Vector2.RIGHT,
	Vector2.LEFT,
	Vector2.RIGHT,
	]

var distances = [
	10, 12, 14, 8
	]

var direction
var og_pos
var time = 0.5
var ttl
var distance = 30
var dtl
var hop_speed = 9000

var home_threshold = 100

## enter ###########################################################

func enter(opts = {}):
	og_pos = actor.global_position
	actor.anim.play("idle")

	var home_pos = opts.get("home_position")
	if home_pos != null:
		var dist_from_home = actor.global_position.distance_to(opts.get("home_position"))
		var too_far_from_home = dist_from_home > home_threshold
		if too_far_from_home:
			direction = actor.global_position - opts.get("home_position")

	if direction == null:
		direction = U.rand_of(directions)

	dtl = U.get_(opts, "distance", U.rand_of(distances) * 1.4)

	ttl = U.get_(opts, "time", time)
	hop_speed = U.get_(opts, "hop_speed", hop_speed)

	var tween = create_tween()
	tween.tween_property(actor, "scale", Vector2.ONE * 1.5, ttl/2.0)
	tween.tween_property(actor, "scale", Vector2.ONE, ttl/2.0)

func exit():
	direction = null

## physics ###########################################################

func physics_process(delta):
	if og_pos == null:
		return

	var dist = og_pos.distance_to(actor.global_position)
	ttl -= delta

	if ttl <= 0 or dtl < dist:
		transit("Idle")
		return

	var move_vec = direction * hop_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.9)
	actor.move_and_slide()
