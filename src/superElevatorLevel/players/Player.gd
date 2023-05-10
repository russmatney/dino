@tool
extends BEUBody

var hud = preload("res://src/superElevatorLevel/hud/HUD.tscn")

## ready ###########################################################

func _ready():
	super._ready()

	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self})
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

func _physics_process(_delta):
	move_vector = Trolley.move_dir()

	if move_vector.abs().length() > 0:
		if move_vector.x > 0:
			facing_vector = Vector2.RIGHT
		elif move_vector.x < 0:
			facing_vector = Vector2.LEFT
		update_facing()
