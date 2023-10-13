extends RigidBody2D

@onready var anim = $AnimatedSprite2D
@onready var area = $Area2D

var impulse_force = 300

func _ready():
	pass

func toss(direction: Vector2):
	Debug.pr("tossing in direction", direction)
	rotation = direction.angle() + PI/2.0
	Debug.pr("rotating to angle", rotation)
	apply_central_impulse(direction * impulse_force)
