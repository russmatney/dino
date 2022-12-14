tool
extends KinematicBody2D

var velocity := Vector2.ZERO

export(int) var jump_impulse := 1500
export(int) var speed := 300
export(int) var gravity := 4000

var initial_pos

onready var state_label = $StateLabel
onready var machine = $Machine
onready var anim = $AnimatedSprite
var tween

func _ready():
	initial_pos = get_global_position()
	machine.connect("transitioned", self, "on_transit")

	shader_loop()

func shader_loop():
	tween = get_tree().create_tween()
	tween.set_loops(0)

	tween.parallel().tween_property(anim.get_material(), "shader_param/red_displacement", 1.0, 1)
	tween.parallel().tween_property(anim.get_material(), "shader_param/blue_displacement", 1.0, 1)
	tween.parallel().tween_property(anim.get_material(), "shader_param/green_displacement", 1.0, 1)
	tween.parallel().tween_property(anim.get_material(), "shader_param/red_displacement", -1.0, 1)
	tween.parallel().tween_property(anim.get_material(), "shader_param/blue_displacement", -1.0, 1)
	tween.parallel().tween_property(anim.get_material(), "shader_param/green_displacement", -1.0, 1)

func on_transit(new_state):
	set_state_label(new_state)


func _process(_delta):
	if get_global_position().y > 3000:
		position = initial_pos
		velocity = Vector2.ZERO


func set_state_label(label: String):
	state_label.bbcode_text = "[center]" + label + "[/center]"


############################################################

enum DIR {left, right}
var facing_direction = DIR.left

func face_right():
	facing_direction = DIR.right
	anim.flip_h = true

func face_left():
	facing_direction = DIR.left
	anim.flip_h = false
