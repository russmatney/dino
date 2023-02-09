extends RigidBody2D

#var mouse_pos
#var ang_to_mouse
@onready var player = super.get_node("../Player")
@onready var handle_pinjoint = super.get_node("../RodHandlePin")
@onready var player_machine = super.get_node("../Player/Machine")
@onready var angler_chain = get_node("../AnglerChainAndLight")

@onready var initial_pos = position
@onready var initial_x_rel = abs(player.position.x - position.x)
@onready var initial_y_rel = abs(player.position.y - position.y)
#var colors = [Color(1.0, 0.0, 0.0, 1.0),
#		  Color(0.0, 1.0, 0.0, 1.0),
#		  Color(0.0, 0.0, 1.0, 0.0)]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


#func _input(event):
#	randomize()
#	modulate = colors[randi() % colors.size()]


func _process(_delta):
	# if this pinjoint as been freed, we don't manually position the rod anymore
	if handle_pinjoint and is_instance_valid(handle_pinjoint):
		if player.velocity.y != 0:
			position.y = player.position.y + initial_y_rel

		# TODO move to reaction to player signal to get out of process loop
		match player.facing_direction:
			player.DIR.right:
				position.x = player.position.x + initial_x_rel
				# for ch in angler_chain.get_children():
				# 	ch.position.x *= -1
			player.DIR.left:
				position.x = player.position.x - initial_x_rel
				# for ch in angler_chain.get_children():
				# 	ch.position.x *= -1

		handle_pinjoint.position = position

#func _integrate_forces(state):
#	state.apply_torque(global_position.angle_to_point(get_global_mouse_position()))
# state.apply_torque(angular_damp)
