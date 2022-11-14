extends RigidBody2D

var spawner: Node2D

# killing a block implies killing its spawner
func kill():
	if spawner:
		spawner.queue_free()
	queue_free()

func _on_Block_body_entered(body:Node):
	# TODO this doesn't work b/c things don't 'enter', they collide

	print("block body entered", body)
	if body.is_in_group("player"):
		print("player hit block")
		if body.destroy_blocks:
			print("player should kill block")
			# TODO color change
			# TODO timeout, to let the physics playout
			kill()
