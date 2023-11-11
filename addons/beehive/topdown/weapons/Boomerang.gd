extends TDWeapon

var aim_vector
var throw_offset = Vector2.ONE * -12

func aim(aim: Vector2):
	aim_vector = aim.normalized()

func activate():
	Log.pr("activating", self)
	actor.notif(self.name)
	DJZ.play(DJZ.S.laser)

func deactivate():
	pass

func use():
	if not throwing:
		throw()

func stop_using():
	pass


## ready #####################################################

func _ready():
	super._ready()
	modulate.a = 0

func _on_animation_finished():
	pass

func _on_frame_changed():
	pass


## throw #####################################################

var throwing = false
var returning = false
var bodies_this_throw = []

var throw_time = 0.4
var throw_distance = 120

var spin_tween
var throw_tween
var return_tween

func throw():
	throwing = true
	returning = false
	bodies_this_throw = []
	modulate.a = 1

	if aim_vector == null:
		aim_vector = Vector2.RIGHT

	# reparent to scene?
	# reparent.call_deferred(Navi.current_scene)

	# use offset?
	# global_position += throw_offset

	if spin_tween:
		spin_tween.kill()
	spin_tween = create_tween()
	spin_tween.set_loops(0)
	spin_tween.tween_property(self, "rotation", 2*PI, 0.2).as_relative()

	var initial_pos = global_position
	var new_pos = initial_pos + throw_distance * aim_vector
	if throw_tween:
		throw_tween.kill()
	throw_tween = create_tween()
	throw_tween.tween_property(self, "global_position", new_pos, throw_time)
	throw_tween.tween_callback(start_return)

	DJZ.play(DJZ.S.fire)

func start_return():
	returning = true

func finish_return():
	throwing = false
	returning = false
	global_position = actor.global_position
	modulate.a = 0

## process #####################################################

func _physics_process(delta):
	if returning:
		global_position = global_position.lerp(actor.global_position, 1 - pow(0.01, delta))
		var dist = global_position.distance_to(actor.global_position)
		if dist <= 15:
			finish_return()

	if throwing:
		for b in bodies:
			if not b in bodies_this_throw:
				bodies_this_throw.append(b)
				if b.has_method("take_hit"):
					b.take_hit({type="boomerang", body=self})
