extends State

## enter ###########################################################


func enter(_arg = {}):
	actor.anim.play("run")


## process ###########################################################


func process(_delta):
	pass


## physics ###########################################################

var move_speed = 8000

func physics_process(delta):
	var move_dir = actor.input_move_dir

	if move_dir.abs().length() < 0.01:
		transit("Idle")
		return

	# move in direction
	var move_vec = move_dir * move_speed * delta
	actor.velocity = actor.velocity.lerp(move_vec, 0.9)

	actor.move_and_slide()
