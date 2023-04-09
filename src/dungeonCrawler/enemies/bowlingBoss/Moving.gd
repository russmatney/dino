extends State

var move_time: int
var move_speed = 50

var move_dir


func next_direction():
	match move_dir:
		Vector2.UP:
			return Vector2.LEFT
		Vector2.LEFT:
			return Vector2.DOWN
		Vector2.DOWN:
			return Vector2.RIGHT
		Vector2.RIGHT:
			return Vector2.UP
		_:
			return Vector2.RIGHT


func enter(_msg = {}):
	Debug.pr("[MOVING]", actor)
	move_time = 100
	move_dir = next_direction()


func process(delta):
	if actor.dead:
		machine.transit("Dead")

	if move_time > 0:
		move_time -= delta
		actor.position -= move_dir.normalized() * move_speed * delta
	else:
		machine.transit("Engaged")
