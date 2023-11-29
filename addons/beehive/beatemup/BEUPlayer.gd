@tool
extends BEUBody
class_name BEUPlayer

func _enter_tree():
	add_to_group("player", true)

## ready ###########################################################

var skip_cam_setup = false

func _ready():
	set_collision_layer_value(1, false) # walls,doors,env
	set_collision_layer_value(2, true) # player
	set_collision_mask_value(1, true)
	set_collision_mask_value(4, true) # enemies
	set_collision_mask_value(5, true) # enemy projectiles
	set_collision_mask_value(6, true) # items
	set_collision_mask_value(11, true) # fences, low-walls
	set_collision_mask_value(12, true) # spikes

	if not Engine.is_editor_hint() and not skip_cam_setup:
		Cam.request_camera({player=self, zoom_rect_min=50, zoom_margin_min=120})

	super._ready()


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

	if move_vector.abs().length() > 0 and "state" in machine and machine.state.name in ["Walk", "Jump"]:
		if move_vector.x > 0:
			facing_vector = Vector2.RIGHT
		elif move_vector.x < 0:
			facing_vector = Vector2.LEFT
		update_facing()
