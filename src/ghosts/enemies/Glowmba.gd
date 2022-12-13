tool
extends KinematicBody2D

onready var kink_label = $KinkLabel

func _ready():
	Kink.new_ink_state(self)

	var msg = Kink.current_message(self)
	if msg:
		kink_label.set_text(msg)

#######################################################################33
# physics process

var dead = false
var dir = Vector2.RIGHT
export(int) var speed = 100
export(int) var gravity := 4000
var velocity = dir * speed

func _physics_process(delta):
	if not Engine.editor_hint:
		velocity.y += gravity * delta

		if not dead:
			velocity.x = dir.x * max(speed, velocity.x)
			velocity = move_and_slide(velocity, Vector2.UP)
			if is_on_wall():
				match dir:
					Vector2.LEFT: dir = Vector2.RIGHT
					Vector2.RIGHT: dir = Vector2.LEFT
