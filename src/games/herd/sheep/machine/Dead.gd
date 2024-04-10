extends State

## enter ###########################################################

var dead_anim_finished = false

func enter(_opts = {}):
	dead_anim_finished = false
	U._connect(actor.anim.animation_finished, on_anim_finished)
	actor.anim.play("dead")

func on_anim_finished():
	dead_anim_finished = true
	actor.die()


## physics ###########################################################

# func physics_process(_delta):
# 	pass
