tool
extends KinematicBody2D

var velocity := Vector2.ZERO

export(int) var jump_impulse := 1500
export(int) var speed := 300
export(int) var gravity := 4000

export(int) var max_health := 6
var health = max_health
signal health_change

var initial_pos
var knocked_back = false
var dead = false

onready var state_label = $StateLabel
onready var machine = $Machine
onready var anim = $AnimatedSprite
var tween

############################################################

func _ready():
	initial_pos = get_global_position()
	machine.connect("transitioned", self, "on_transit")

	call_deferred("finish_setup")

	shader_loop()

func finish_setup():
	emit_signal("health_change", health)

func on_transit(new_state):
	set_state_label(new_state)

func set_state_label(label: String):
	state_label.bbcode_text = "[center]" + label + "[/center]"

############################################################

func shader_loop():
	tween = create_tween()
	tween.set_loops(0)

	tween.tween_property(anim.get_material(), "shader_param/red_displacement", 1.0, 1)
	tween.tween_property(anim.get_material(), "shader_param/blue_displacement", 1.0, 1)
	tween.tween_property(anim.get_material(), "shader_param/green_displacement", 1.0, 1)
	tween.tween_property(anim.get_material(), "shader_param/red_displacement", -1.0, 1)
	tween.tween_property(anim.get_material(), "shader_param/blue_displacement", -1.0, 1)
	tween.tween_property(anim.get_material(), "shader_param/green_displacement", -1.0, 1)


############################################################

func _process(_delta):
	if get_global_position().y > 3000:
		position = initial_pos
		velocity = Vector2.ZERO

	if Input.is_action_just_pressed("action"):
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
	emit_signal("health_change", health)

	var dir
	if body.global_position.x > global_position.x:
		dir = Vector2.LEFT
	else:
		dir = Vector2.RIGHT

	machine.transit("Knockback", {"dir": dir, "dead": health <= 0})

func _on_Hurtbox_body_entered(body:Node):
	# ignore if we're still recovering or dead
	if knocked_back or dead:
		return
	if body.is_in_group("enemies"):
		if body.can_hit_player():
			Ghosts.create_notification(str("Player hurt by ", body.name))
			hit(body)
		elif body.player_can_hit():
			if body.has_method("hit"):
				var dir
				if body.global_position.x > global_position.x:
					dir = Vector2.RIGHT
				else:
					dir = Vector2.LEFT

				body.hit(dir)

############################################################

var burstables = []

func burst_gloomba():
	for b in burstables:
		if b.player_can_stun():
			b.stun()

	update_burst_action()

func update_burst_action():
	if burstables:
		# add if one can be burst
		for b in burstables:
			if b.player_can_stun():
				add_action(self, "burst_gloomba")
				return

	remove_action(self, "burst_gloomba")

func _on_Burstbox_body_entered(body:Node):
	if body.is_in_group("enemies"):
		burstables.append(body)
	update_burst_action()

func _on_Burstbox_body_exited(body:Node):
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
		$ActionLabel.bbcode_text = str("[center]", current_action["fname"].capitalize(), "[/center]")
	else:
		current_action = null
		$ActionLabel.bbcode_text = ""

func call_action(action):
	action["obj"].call_deferred(action["fname"])

func add_action(obj, fname):
	actions[fname] = {"obj": obj, "fname": fname}
	update_actions_ui()

func remove_action(_obj, fname):
	actions.erase(fname)
	update_actions_ui()
