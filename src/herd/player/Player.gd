extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var machine = $Machine
@onready var action_detector = $ActionDetector
@onready var ah = $ActionHint
@onready var facing_arrow = $FacingArrow

var max_health = 6
var health = 6

######################################################
# ready

var hud = preload("res://src/herd/hud/HUD.tscn")

func _ready():
	DJZ.play(DJZ.S.land)
	Hotel.register(self)
	Hood.ensure_hud(hud)
	Cam.request_camera({player=self,
		zoom_margin_min=100,
		zoom_rect_min=150,
		})
	machine.start()
	action_detector.setup(self)

######################################################
# hotel

func hotel_data():
	return {health=health}

func check_out(data):
	health = U.get_(data, "health", health)

######################################################
# facing_arrow

var arrow_offset = PI/4
func update_facing_arrow():
	facing_arrow.rotation = facing_dir.angle() + arrow_offset

######################################################
# input

var input_move_dir = Vector2.ZERO

var facing_dir

func _physics_process(_delta):
	input_move_dir = Trolley.move_vector()
	if input_move_dir.abs().length() > 0:
		# could snap/round to discrete angles
		facing_dir = input_move_dir
		update_facing_arrow()

	action_detector.current_action()


func _unhandled_input(event):
	if Trolley.is_action(event):
		action_detector.execute_current_action()
	if Trolley.is_cycle_prev_action(event):
		DJZ.play(DJZ.S.walk)
		action_detector.cycle_prev_action()
	elif Trolley.is_cycle_next_action(event):
		DJZ.play(DJZ.S.walk)
		action_detector.cycle_next_action()
	if Trolley.is_jump(event):
		machine.transit("Jump")

######################################################
# grab/throw

var grabbing

func can_grab():
	return grabbing == null

func grab(node):
	DJZ.play(DJZ.S.candleout)
	grabbing = node
	U._connect(node.dying, on_grabbing_dying)

func on_grabbing_dying(_node):
	grabbing = null

func throw(_node):
	DJZ.play(DJZ.S.laser)
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
	if is_dead:
		return

	DJZ.play(DJZ.S.playerhurt)
	health -= 1
	Hotel.check_in(self)
	Cam.screenshake(0.35)

	health = clamp(health, 0, max_health)

	if health <= 0:
		machine.transit("Dead")
	else:
		U.play_then_return(anim, "hit")

######################################################
# DEATH

signal dying
var is_dead

func die():
	if is_dead:
		return

	is_dead = true
	dying.emit(self)

	# tween shrink
	var duration = 0.5
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.3, 0.3), duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "modulate:a", 0.3, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	if Game.is_managed:
		tween.tween_callback(restart_level)
	else:
		tween.tween_callback(Game.respawn_player.bind({setup_fn=func(p):
			Hotel.check_in(p, {health=p.max_health})}))

func restart_level():
	Jumbotron.jumbo_notif({header="You died.", body="Sorry about it!",
		action="close", action_label_text="Restart Level",
		on_close=retry_level})

func retry_level():
	var level_idx = HerdData.levels.find(Navi.current_scene_path())
	if len(HerdData.levels) <= level_idx:
		Log.err("level_idx too high, can't retry level")
		return
	Navi.nav_to(HerdData.levels[level_idx])
