@tool
extends SSBody
class_name SSPlayer

## enter tree ###########################################################

func _enter_tree():
	add_to_group("player", true)
	super._enter_tree()


## ready ###########################################################

func _ready():
	super._ready()
	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self, zoom_rect_min=50, zoom_margin_min=120})
		Hood.ensure_hud()


## input ###########################################################

func _unhandled_input(event):
	if Trolley.is_jump(event) and machine.state.name in ["Idle", "Run"]:
		machine.transit("Jump")
		return


## physics_process ###########################################################

func _physics_process(_delta):
	# super._physics_process(delta)

	move_vector = Trolley.move_dir()

	if move_vector.abs().length() > 0 and machine.state.name in ["Run", "Jump", "Fall"]:
		if move_vector.x > 0:
			facing_vector = Vector2.RIGHT
		elif move_vector.x < 0:
			facing_vector = Vector2.LEFT
		update_facing()
