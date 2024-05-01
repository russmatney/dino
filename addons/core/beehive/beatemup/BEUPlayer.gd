@tool
extends BEUBody
class_name BEUPlayer

func _enter_tree():
	add_to_group("player", true)

## ready ###########################################################

func _ready():
	set_collision_layer_value(1, false) # walls,doors,env
	set_collision_layer_value(2, true) # player
	set_collision_mask_value(1, true)
	set_collision_mask_value(4, true) # enemies
	set_collision_mask_value(5, true) # enemy projectiles
	set_collision_mask_value(6, true) # items
	set_collision_mask_value(11, true) # fences, low-walls
	set_collision_mask_value(12, true) # spikes

	super._ready()


## input ###########################################################

func _unhandled_input(event):
	if Trolls.is_jump(event) and machine.state.name in ["Idle", "Walk"]:
		machine.transit("Jump")
		return

	if Trolls.is_attack(event) and machine.state.name in ["Idle", "Walk"]:
		machine.transit("Punch")
		return


## physics_process ###########################################################

func _physics_process(delta):
	super._physics_process(delta)

	move_vector = Trolls.move_vector()

	if move_vector.abs().length() > 0 and "state" in machine and machine.state.name in ["Walk", "Jump"]:
		if move_vector.x > 0:
			facing_vector = Vector2.RIGHT
		elif move_vector.x < 0:
			facing_vector = Vector2.LEFT
		update_facing()
