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

var hud = preload("res://src/herd/hud/HUD.tscn")

func _ready():
	Hotel.register(self)
	Hood.ensure_hud(hud)
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
	Cam.screenshake(0.35)

	health = clamp(health, 0, max_health)

	if health <= 0:
		machine.transit("Dead")
	else:
		Util.play_then_return(anim, "hit")

######################################################
# DEATH

# TODO connect/remove follow/target from Sheep/Wolf
signal dying

func die():
	dying.emit(self)
	Hood.notif(name, "dying")

	# tween shrink
	var duration = 0.5
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.3, 0.3), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0.3, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(clean_up_and_free)

	# TODO respawn from Herd or Game?

func clean_up_and_free():
	Debug.pr("freeing player")
	queue_free()
