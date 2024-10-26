extends State

var dying_time = 0.8
var ttl

## enter ###########################################################

func enter(_opts = {}):
	ttl = dying_time

	actor.anim.play("dead")
	Sounds.play(Sounds.S.enemy_dead)

	var tween = create_tween()
	tween.tween_property(actor, "modulate:a", 0.4, dying_time)
	# y u no? tween.tween_callback(actor.died.emit)
	tween.tween_callback(func(): actor.died.emit())


## exit ###########################################################

func exit():
	pass
