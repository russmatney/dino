extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine

######################################################
# enter_tree

func _enter_tree():
	Hotel.book(self)

######################################################
# ready

func _ready():
	Hotel.register(self)
	Hood.ensure_hud()
	Cam.ensure_camera({player=self})
	machine.start()

######################################################
# hotel

func hotel_data():
	return {}

func check_out(_data):
	pass

######################################################

var input_move_dir = Vector2.ZERO

func _physics_process(_delta):
	input_move_dir = Trolley.move_dir()
