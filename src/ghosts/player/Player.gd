@tool
extends CharacterBody2D

@export var jump_impulse: int = 1500
@export var speed: int = 300
@export var gravity: int = 4000

@export var max_health: int = 6
var health = max_health
signal health_change

var initial_pos
var knocked_back = false
var dead = false

@onready var state_label = $StateLabel
@onready var machine = $Machine
@onready var anim = $AnimatedSprite2D
var tween

@onready var action_detector = $ActionDetector
@onready var action_hint = $ActionHint

############################################################

signal player_died


func die():
	player_died.emit()


############################################################

var hud = preload("res://src/ghosts/hud/HUD.tscn")

func _ready():
	Hood.ensure_hud(hud, self)
	Cam.ensure_camera(Cam.mode.FOLLOW_AND_POIS, {
		zoom_rect_min=400
		}, self)

	action_detector.setup(self, null, action_hint)

	initial_pos = get_global_position()
	machine.transitioned.connect(on_transit)
	machine.start.call_deferred()

	finish_setup.call_deferred()
	shader_loop()


func finish_setup():
	health_change.emit(health)


func on_transit(new_state):
	set_state_label(new_state)


func set_state_label(label: String):
	state_label.text = "[center]" + label + "[/center]"


############################################################


func shader_loop():
	tween = create_tween()
	tween.set_loops(0)

	tween.tween_property(anim.get_material(), "shader_parameter/red_displacement", 1.0, 1)
	tween.tween_property(anim.get_material(), "shader_parameter/blue_displacement", 1.0, 1)
	tween.tween_property(anim.get_material(), "shader_parameter/green_displacement", 1.0, 1)
	tween.tween_property(anim.get_material(), "shader_parameter/red_displacement", -1.0, 1)
	tween.tween_property(anim.get_material(), "shader_parameter/blue_displacement", -1.0, 1)
	tween.tween_property(anim.get_material(), "shader_parameter/green_displacement", -1.0, 1)


############################################################


func _process(_delta):
	if Input.is_action_just_pressed("action"):
		Cam.screenshake(0.2)
		var did_execute = action_detector.execute_current_action()
		if not did_execute:
			if current_action:
				call_action(current_action)
			# TODO update when gloombas become unstunned, maybe via signals
			update_burst_action()


############################################################

enum DIR { left, right }
var facing_direction = DIR.left


func face_right():
	facing_direction = DIR.right
	anim.flip_h = true

	if $Flashlight.position.x < 0:
		$Flashlight.position.x = -$Flashlight.position.x
		$Flashlight.scale.x = -$Flashlight.scale.x
		$Burstbox.position.x = -$Burstbox.position.x


func face_left():
	facing_direction = DIR.left
	anim.flip_h = false

	if $Flashlight.position.x > 0:
		$Flashlight.position.x = -$Flashlight.position.x
		$Flashlight.scale.x = -$Flashlight.scale.x
		$Burstbox.position.x = -$Burstbox.position.x


############################################################


func hit(body):
	health -= 1
	health_change.emit(health)

	var dir
	if body.global_position.x > global_position.x:
		dir = Vector2.LEFT
	else:
		dir = Vector2.RIGHT

	machine.transit("Knockback", {"dir": dir, "dead": health <= 0})


func _on_Hurtbox_body_entered(body: Node):
	# ignore if we're still recovering or dead
	if knocked_back or dead:
		return
	if body.is_in_group("enemies"):
		if body.can_hit_player():
			hit(body)
			Hood.notif("Youch!")
		elif body.player_can_hit():
			if body.has_method("hit"):
				var dir
				if body.global_position.x > global_position.x:
					dir = Vector2.RIGHT
				else:
					dir = Vector2.LEFT

				body.hit(dir)
				gloomba_ko()


############################################################

signal gloomba_koed
var gloomba_kos = 0


func gloomba_ko():
	Hood.notif("Gloomba K.O.!")
	gloomba_kos += 1
	gloomba_koed.emit(gloomba_kos)


var burstables = []


func burst_gloomba():
	var did_burst = false
	for b in burstables:
		if b.player_can_stun():
			b.stun()
			did_burst = true

	update_burst_action()

	if did_burst:
		Hood.notif("Gloomba stunned!")
		$Flashlight/AnimatedSprite2D.visible = true
		$Flashlight/AnimatedSprite2D.play("burst")
		await get_tree().create_timer(0.4).timeout
		$Flashlight/AnimatedSprite2D.visible = false
		$Flashlight/AnimatedSprite2D.stop()


func update_burst_action():
	if burstables:
		# add if one can be burst
		for b in burstables:
			if b.player_can_stun():
				add_action(self, "burst_gloomba")
				return

	remove_action(self, "burst_gloomba")


func _on_Burstbox_body_entered(body: Node):
	if body.is_in_group("enemies"):
		burstables.append(body)
	update_burst_action()


func _on_Burstbox_body_exited(body: Node):
	if body.is_in_group("enemies"):
		burstables.erase(body)
	update_burst_action()


############################################################

var actions = {}
var current_action


func update_actions_ui():
	if actions:
		# TODO support multiple actions, or preferred action?
		# maybe actions can pass a priority
		current_action = actions.values()[0]
		$ActionLabel.text = str(
			"[center]", current_action["fname"].capitalize(), "[/center]"
		)
	else:
		current_action = null
		$ActionLabel.text = ""


func call_action(action):
	action["obj"].call_deferred(action["fname"])


func add_action(obj, fname):
	actions[fname] = {"obj": obj, "fname": fname}
	update_actions_ui()


func remove_action(_obj, fname):
	actions.erase(fname)
	update_actions_ui()
