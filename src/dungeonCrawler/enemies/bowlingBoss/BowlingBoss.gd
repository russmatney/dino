@tool
extends Node2D

@export var speed: int = 500

var initial_pos

@onready var state_label = $StateLabel
@onready var machine = $Machine

#######################################################################33
# config warning


func _get_configuration_warnings():
	var warnings = []
	for n in ["StateLabel", "Machine"]:
		var node = find_child(n)
		if not node:
			warnings.append("Missing expected child named '" + n + "'")
	return warnings


#######################################################################33
# ready


func _ready():
	Log.pr("bowling boss ready")
	initial_pos = get_global_position()
	machine.transitioned.connect(on_transit)
	machine.start.call_deferred()


func on_transit(new_state):
	set_state_label(new_state)


func set_state_label(label: String):
	state_label.text = "[center]" + label + "[/center]"


#######################################################################33
# signals

var bodies = []
var detects_group = "player"


func _on_DetectBox_body_entered(body: Node):
	if body.is_in_group(detects_group):
		bodies.append(body)


func _on_DetectBox_body_exited(body: Node):
	bodies.erase(body)


#######################################################################33
# bowl attack

@onready var ball_scene = preload("res://src/dungeonCrawler/weapons/BowlingBall.tscn")
var bowl_speed = 200


func bowl_attack(target):
	var ball = ball_scene.instantiate()
	ball.position = get_global_position()
	Navi.add_child_to_current(ball)

	var bowl_dir = target.get_global_position() - ball.position
	ball.velocity = bowl_dir.normalized() * bowl_speed

	await get_tree().create_timer(1.0).timeout


#######################################################################33
# health, death

var health = 3
var dead = false

@onready var normal_body = $Body
@onready var small_body = $SmallBody


func hit():
	health -= 1
	Log.pr(name, " health: ", health)

	if health == 1:
		# switch to small body
		small_body.visible = true
		normal_body.visible = false
		Util.set_collisions_enabled(normal_body, false)
	elif health <= 0:
		kill()


func kill():
	Util.set_collisions_enabled(small_body, false)
	small_body.visible = false
	dead = true
	machine.transit("Dead")
