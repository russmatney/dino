extends KinematicBody2D

onready var light = $Light2D
export(bool) var light_enabled = false

var velocity = Vector2.ZERO

func _ready():
	#velocity = Vector2(-250, 0)
	light.enabled = light_enabled

func _physics_process(delta):
	var _collision_info = move_and_collide(velocity * delta)
	# if collision_info:
	# 	# bounce logic
	# 	velocity = velocity.bounce(collision_info.normal)

func kill():
	queue_free()

### collisions #####################################################################

func _on_Area2D_body_entered(body:Node):
	if body != self:
		print("bowling ball hit: ", body, body.name)
		if body.is_in_group("player"):
			if body.has_method("hit"):
				body.hit()

		# dies on any hit for now
		kill()
