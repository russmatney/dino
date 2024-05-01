extends State

## properties #####################################################

func should_ignore_hit():
	return true

func can_bump():
	return false

## vars #####################################################

var KNOCKBACK_X = 20
var KNOCKBACK_Y = -300
var KNOCKBACK_DYING_Y = -700
var min_kb_time = 0.3
var kb_ttl = 2

## enter #####################################################

func enter(opts={}):
	kb_ttl = min_kb_time
	var dir = opts.get("direction", Vector2.RIGHT)

	var kb_y
	if actor.is_dead:
		kb_y = KNOCKBACK_DYING_Y
		actor.anim.play("dying")
		Sounds.play(Sounds.S.soldierdead)
	else:
		kb_y = KNOCKBACK_Y
		actor.anim.play("knocked_back")
		Sounds.play(Sounds.S.soldierhit)

	if dir == Vector2.LEFT:
		actor.face_right()
	elif dir == Vector2.RIGHT:
		actor.face_left()

	actor.velocity += Vector2(0, kb_y) + dir * KNOCKBACK_X

## process #####################################################

func physics_process(delta):
	actor.velocity.x = move_toward(actor.velocity.x, 0, actor.speed/5.0)
	actor.velocity.y += actor.gravity * delta

	actor.move_and_slide()

	kb_ttl -= delta
	if actor.is_on_floor() and kb_ttl <= 0:
		if actor.is_dead:
			transit("Dead")
		else:
			transit("Stunned")
