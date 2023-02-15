extends State

func enter(_ctx={}):
	MvaniaSounds.play_sound("jump")
	actor.anim.play("jump")
	actor.anim.animation_finished.connect(_on_anim_finished)

	# apply jump velocity
	actor.velocity.y = actor.JUMP_VELOCITY

func _on_anim_finished():
	if actor.anim.animation == "jump":
		actor.anim.play("air")

func exit():
	actor.anim.animation_finished.disconnect(_on_anim_finished)

func process(_delta):
	pass

func physics_process(delta):
	# gravity
	if not actor.is_on_floor():
		actor.velocity.y += actor.GRAVITY * delta

	# apply move dir
	# TODO consider different air horizontal speed
	if actor.move_dir:
		actor.velocity.x = actor.move_dir.x * actor.SPEED
	else:
		actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED)

	actor.move_and_slide()

	if actor.velocity.y > 0:
		machine.transit("Fall")
