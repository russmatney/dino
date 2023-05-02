extends State


## enter ###########################################################


func enter(opts = {}):
	actor.anim.play("follow")
	actor.target = opts.get("target")


## process ###########################################################


func process(_delta):
	pass


## physics ###########################################################


func physics_process(_delta):
	pass
