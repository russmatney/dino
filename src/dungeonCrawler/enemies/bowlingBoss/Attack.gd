extends State


func enter(_msg = {}):
	print("entering attack state for actor: ", actor)

var once = true

func process(_delta: float):
	if actor.bodies.size() == 0:
		machine.transit("Idle")
		return

	var target = actor.bodies[0]

	# TODO tell before attacking, pause/move after
	if once:
		bowl_attack(target)
		once = false

onready var ball_scene = preload("res://src/dungeonCrawler/weapons/BowlingBall.tscn")
var bowl_speed = 200

func bowl_attack(target):
	var ball = ball_scene.instance()
	ball.position = actor.get_global_position()
	Navi.current_scene.call_deferred("add_child", ball)

	var bowl_dir = target.get_global_position() - ball.position
	ball.velocity = bowl_dir.normalized() * bowl_speed
