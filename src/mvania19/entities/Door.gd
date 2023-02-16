@tool
extends AnimatableBody2D

@onready var collision_shape = $CollisionShape2D
@onready var anim = $AnimatedSprite2D

@export var initial_state = "closed" :
	set(new_state):
		initial_state = new_state
		if scene_ready:
			set_new_state(new_state)

func set_new_state(new_state):
	if new_state == "open":
		set_open()
	elif new_state == "closed":
		set_closed()

var scene_ready

func _ready():
	call_deferred("setup")
	scene_ready = true

func setup():
	set_new_state(initial_state)
	anim.animation_finished.connect(_on_animation_finished)

func _on_animation_finished():
	if anim.animation == "opening":
		anim.play("open")
	elif anim.animation == "closing":
		anim.play("closed")

func set_open():
	anim.play("opening")
	collision_shape.call_deferred("set_disabled", true)

func set_closed():
	anim.play("closing")
	collision_shape.call_deferred("set_disabled", false)
