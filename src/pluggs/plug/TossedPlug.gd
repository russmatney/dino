extends RigidBody2D

## vars ############################################################################

@onready var anim = $AnimatedSprite2D
@onready var area = $Area2D
var cord_scene = preload("res://src/pluggs/plug/Cord.tscn")

var max_cord_length = 170
var impulse_force = 300

# sibling - not a child
var cord

## ready ############################################################################

var cord_point_time = 0.1
var cord_point_ttl = 0.0

## process ############################################################################

func _process(delta):
	if is_latched:
		return
	if cord != null and is_instance_valid(cord):
		cord_point_ttl -= delta
		if cord_point_ttl < 0:
			# TODO some minimum distance before adding another point
			# TODO check against max-allowed length
			cord_point_ttl = cord_point_time
			# TODO Util, don't fail me now!
			cord.add_point(global_position)

			if cord.length() >= max_cord_length:
				reached_length()

var killed_velocity = false
func _integrate_forces(state):
	if not killed_velocity and is_at_max and state.linear_velocity.abs().length() > 1:
		state.linear_velocity = Vector2.ZERO
		killed_velocity = true

## toss ############################################################################

func toss(player, direction: Vector2):
	cord = cord_scene.instantiate()
	cord.player = player
	get_tree().current_scene.add_child(cord)

	rotation = direction.angle() + PI/2.0

	apply_central_impulse(direction * impulse_force)

## reached_length ############################################################################

var is_at_max = false
func reached_length():
	is_at_max = true

	# TODO convert cord into a 'rope'
	# TODO reel it back in

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.1, 0.5)
	tween.parallel().tween_property(cord, "modulate:a", 0.1, 0.5)
	tween.tween_callback(func():
		queue_free()
		cord.queue_free()).set_delay(1.0)

## latch ############################################################################

var is_latched = false
func latch(socket) -> bool:
	cord.socket = socket

	if is_at_max:
		return false
	is_latched = true

	set_deferred("freeze", true)
	var target_pos = socket.global_position
	cord.add_point(target_pos)

	var tween = create_tween()
	tween.tween_property(self, "position", target_pos, 0.3)
	return true
