extends State

var dying

var KNOCKBACK_X = 20
var KNOCKBACK_Y = 200
var KNOCKBACK_DYING_Y = 300
var min_kb_time = 2
var kb_ttl = 2


func enter(opts={}):
	kb_ttl = min_kb_time
	var dir = opts.get("direction", Vector2.RIGHT)
	dying = opts.get("dying", false)

	var kb_y
	if dying:
		kb_y = KNOCKBACK_DYING_Y
		actor.anim.play("dying")
		# TODO beefy sounds
		MvaniaSounds.play_sound("soldierdead")
	else:
		kb_y = KNOCKBACK_Y
		actor.anim.play("knockback")
		# TODO beefy sounds
		MvaniaSounds.play_sound("soldierhit")

	if dir == Vector2.LEFT:
		actor.face_right()
	elif dir == Vector2.RIGHT:
		actor.face_left()

	actor.velocity += Vector2(0, kb_y) + dir * KNOCKBACK_X

func physics_process(delta):
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.SPEED/5.0)
	actor.velocity.y += actor.GRAVITY * delta

	actor.move_and_slide()

	kb_ttl -= delta
	if actor.is_on_floor() and kb_ttl <= 0:
		if dying:
			transit("Dead")
		elif not dying:
			transit("Stunned")
