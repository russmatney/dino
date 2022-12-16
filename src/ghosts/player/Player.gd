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
	tween = get_tree().create_tween()
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

############################################################

enum DIR { left, right }
var facing_direction = DIR.left


func face_right():
	facing_direction = DIR.right
	anim.flip_h = true


func face_left():
	facing_direction = DIR.left
	anim.flip_h = false

############################################################

func hit():
	health -= 1
	emit_signal("health_change", health)

func knockback(dir):
	machine.transit("Knockback", {"dir": dir})

func _on_Hurtbox_body_entered(body:Node):
	if body.is_in_group("enemies"):
		# ignore if we're still recovering
		if not knocked_back:
			Ghosts.create_notification(str("Player hurt by ", body.name))
			hit()

			var dir
			if body.global_position.x > global_position.x:
				dir = Vector2.LEFT
			else:
				dir = Vector2.RIGHT

			knockback(dir)
