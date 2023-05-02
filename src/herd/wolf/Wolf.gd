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

#############################################
# hotel_data, check_out

func hotel_data():
	return {}

func check_out(_data):
	pass

#############################################

var bodies = []
func _on_body_entered(body):
	if body.is_in_group("player") or body.is_in_group("npcs"):
		if not body in bodies:
			bodies.append(body)

func _on_body_exited(body):
	bodies.erase(body)
