extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var action_detector = $ActionDetector
@onready var ah = $ActionHint

var max_health = 6
var health = 6

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

	# BulletUpHell global signal
	Spawning.bullet_collided_body.connect(_on_bullet_collided)

######################################################
# hotel

func hotel_data():
	return {health=health}

func check_out(data):
	health = Util.get_(data, "health", health)

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

######################################################
# bullets

func _on_bullet_collided(
		body:Node, _body_shape_index:int, _bullet:Dictionary,
		_local_shape_index:int, _shared_area:Area2D
	):
	if body == self:
		bullet_hit()

func bullet_hit():
	health -= 1
	Hotel.check_in(self)

	health = clamp(health, 0, max_health)

	if health <= 0:
		machine.transit("Die")
	else:
		machine.transit("Hit")
