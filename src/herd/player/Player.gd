extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var action_detector = $ActionDetector
@onready var ah = $ActionHint

######################################################
# enter_tree

func _enter_tree():
	Hotel.book(self)

######################################################
# ready

func _ready():
	Hotel.register(self)
	Hood.ensure_hud()
	Cam.ensure_camera({player=self,
		zoom_margin_min=100,
		zoom_rect_min=150,
		})
	machine.start()
	action_detector.setup(self)


######################################################
# hotel

func hotel_data():
	return {}

func check_out(_data):
	pass

######################################################

var input_move_dir = Vector2.ZERO

var facing_dir

func _physics_process(_delta):
	input_move_dir = Trolley.move_dir()
	if input_move_dir.abs().length() > 0:
		# TODO snap/round to discrete angles
		facing_dir = input_move_dir

		# update current action while we're moving?
		# might be annoying
		action_detector.current_action()

func _unhandled_input(event):
	if Trolley.is_action(event):
		action_detector.execute_current_action()

######################################################
# grab/throw

var grabbing

func can_grab():
	return grabbing ==null

func grab(node):
	Debug.pr("grabbed", node)
	grabbing = node

func throw(node):
	Debug.pr("throw", node, facing_dir)
	grabbing = null
	# could pass throw_speed
	return {direction=facing_dir}
