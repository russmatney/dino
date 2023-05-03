extends CharacterBody2D


@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var los = $LineOfSight
@onready var detect_box = $DetectBox

#############################################
# enter_tree, ready

func _enter_tree():
	Hotel.book(self)

func _ready():
	Hotel.register(self)
	Cam.add_offscreen_indicator(self)
	machine.start()
	detect_box.body_entered.connect(_on_body_entered)
	detect_box.body_exited.connect(_on_body_exited)

	Spawning.create_pool("bulletPattern1", "EnemyBullets", 50)

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
		Hood.notif("Target lost")

#############################################
# target

func can_see(body):
	los.target_position = body.global_position
	return not los.is_colliding()

var target

func find_target():
	var old_target = target
	target = closest_target()
	if target and target != old_target:
		Hood.notif("Target Acquired")

func closest_target():
	if len(bodies) == 0:
		return
	var bds = bodies.filter(can_see)
	return Util.nearest_node(self, bds)


#############################################
# fire

func fire():
	if not target:
		return

	Spawning.change_property("bullet", "bulletPattern1", "homing_target", target.get_path())
	Spawning.change_property("bullet", "bulletPattern1", "homing_steer", 100)
	Spawning.change_property("bullet", "bulletPattern1", "homing_duration", 3)

	Debug.pr(name, "firing")
	# TODO create pool
	Spawning.spawn(self, "spawnPattern1", "EnemyBullets")

	# TODO cooldown
	machine.transit("Idle")
