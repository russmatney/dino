extends State

var KNOCKBACK_X = 20
var KNOCKBACK_Y = -300
var KNOCKBACK_DYING_Y = -700
var min_kb_time = 0.3
var kb_ttl = 2


func enter(opts={}):
	kb_ttl = min_kb_time
	var dir = opts.get("direction", Vector2.RIGHT)

	var kb_y
	if actor.dead:
		kb_y = KNOCKBACK_DYING_Y
		actor.anim.play("dying")
		DJSounds.play_sound(DJSounds.soldierdead)
	else:
		kb_y = KNOCKBACK_Y
		actor.anim.play("knocked-back")
		DJSounds.play_sound(DJSounds.soldierhit)

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
		if actor.dead:
			transit("Dead")
		else:
			transit("Stunned")
