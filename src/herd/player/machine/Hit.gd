extends State

## enter ###########################################################

var hit_anim_finished
func enter(_opts = {}):
	hit_anim_finished = false
	Util._connect(actor.anim.animation_finished, on_anim_finished)
	actor.anim.play("hit")

func on_anim_finished():
	hit_anim_finished = true


## physics ###########################################################

func physics_process(_delta):
	var move_dir = actor.input_move_dir
	if hit_anim_finished and move_dir.abs().length() > 0.01:
		transit("Run")
		return
	elif hit_anim_finished:
		transit("Idle")
		return

	actor.move_and_slide()
