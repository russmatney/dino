extends RigidBody2D

var spawner

@onready var color_rect = $ColorRect


func _ready():
	print("block ready")

	if spawner.color:
		color_rect.color = spawner.color
	else:
		color_rect.color = Color(1, 0, 0, 0.5)


# killing a block implies killing its spawner
func kill():
	# TODO timeout/melt/animate
	if spawner and is_instance_valid(spawner):
		spawner.queue_free()
	queue_free()


var active_color = Color(0, 1, 0, 0.5)


func activate():
	# TODO color change
	# TODO apply to spawner
	print("block activated")
	set_color(active_color)


func set_color(c):
	color_rect.color = c
	spawner.color = c


func _on_Block_body_entered(body: Node):
	if body.is_in_group("player"):
		if body.activate_blocks:
			activate()

		if body.destroy_blocks:
			kill()
