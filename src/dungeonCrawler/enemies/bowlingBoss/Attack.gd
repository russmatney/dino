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
var bowl_speed = 5

func bowl_attack(_target):
	var ball = ball_scene.instance()
	ball.position = actor.get_global_position()
	Navi.current_scene.call_deferred("add_child", ball)

	# TODO angle toward target
	var impulse_dir = Vector2(-200, 0)
	ball.velocity = impulse_dir * bowl_speed
