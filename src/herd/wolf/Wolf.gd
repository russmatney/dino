extends CharacterBody2D


@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var los = $LineOfSight
@onready var detect_box = $DetectBox

#############################################
# enter_tree, ready

func _ready():
	Hotel.register(self)
	Cam.add_offscreen_indicator(self, {label="Wolf"})
	machine.start()
	detect_box.body_entered.connect(_on_body_entered)
	detect_box.body_exited.connect(_on_body_exited)

#############################################
# hotel_data, check_out

func hotel_data():
	return {}

func check_out(_data):
	pass

#############################################
# proc

func _physics_process(_delta):
	pass

#############################################
# bodies

var bodies = []
func _on_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("npcs"):
		if not body in bodies:
			bodies.append(body)

func _on_body_exited(body):
	bodies.erase(body)
	if body == target:
		target = null

#############################################
# target

func can_see(body):
	los.target_position = body.global_position - global_position
	var coll = los.get_collider()
	return body and coll and coll == body

var target

func find_target():
	var old_target = target
	target = closest_target()
	if target and "dying" in target:
		U._connect(target.dying, on_target_dying)
	if target and target != old_target:
		DJZ.play(DJZ.S.enemy_spawn)

func on_target_dying(node):
	target = null
	bodies.erase(node)

func closest_target():
	if len(bodies) == 0:
		return
	var bds = bodies.filter(can_see)
	return U.nearest_node(self, bds)


#############################################
# fire

func fire():
	if not target:
		return

	# clear target, idle searches again
	target = null
	# find_target()

	machine.transit("Idle")
