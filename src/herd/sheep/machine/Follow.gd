extends State


## enter ###########################################################


func enter(opts = {}):
	actor.anim.play("follow")
	actor.target = opts.get("target")


## process ###########################################################

func process(_delta):
	pass


## physics ###########################################################

var distance_threshold = 30
var move_speed = 5000


func physics_process(delta):
	if actor.target == null or not is_instance_valid(actor.target):
		transit("Idle")
		return

	var target_vec = actor.target.global_position - actor.global_position
	var dist = target_vec.abs().length()
	if dist > distance_threshold:
		var move_vec = target_vec.normalized() * move_speed * delta
		actor.velocity = actor.velocity.lerp(move_vec, 0.7)
	else:
		actor.velocity = actor.velocity.lerp(Vector2.ZERO, 0.1)

	actor.move_and_slide()
