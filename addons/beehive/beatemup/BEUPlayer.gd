@tool
extends BEUBody
class_name BEUPlayer

var hud = preload("res://src/superElevatorLevel/hud/HUD.tscn")

func _enter_tree():
	add_to_group("player", true)
	super._enter_tree()

## ready ###########################################################

func _ready():
	super._ready()

	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self, zoom_rect_min=50, zoom_margin_min=120})
		Hood.ensure_hud(hud)


## input ###########################################################

func _unhandled_input(event):
	if Trolley.is_jump(event) and machine.state.name in ["Idle", "Walk"]:
		machine.transit("Jump")
		return

	if Trolley.is_attack(event) and machine.state.name in ["Idle", "Walk"]:
		machine.transit("Punch")
		return


## physics_process ###########################################################

func _physics_process(delta):
	super._physics_process(delta)

	move_vector = Trolley.move_vector()

	if move_vector.abs().length() > 0 and machine.state.name in ["Walk", "Jump"]:
		if move_vector.x > 0:
			facing_vector = Vector2.RIGHT
		elif move_vector.x < 0:
			facing_vector = Vector2.LEFT
		update_facing()
