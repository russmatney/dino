@tool
extends BEUBody


## ready ###########################################################

func _ready():
	super._ready()

	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self})
		Hood.ensure_hud()


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
	move_vector = Trolley.move_dir()
	super._physics_process(delta)
