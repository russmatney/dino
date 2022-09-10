extends KinematicBody2D

onready var anim = $AnimatedSprite


func hit():
	print("hit!!!")

	kill()


func kill():
	anim.animation = "death"
	yield(get_tree().create_timer(1.0), "timeout")
	# emit drops
	queue_free()
