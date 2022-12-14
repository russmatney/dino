extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
#var mouse_pos
#var ang_to_mouse
onready var player_node = .get_node("../Player")
onready var handle_pinjoint = .get_node("../RodHandlePin")
onready var player_machine = .get_node("../Player/Machine")

onready var initial_pos = position
onready var initial_x_rel = abs(player_node.position.x - position.x)
onready var initial_y_rel = abs(player_node.position.y - position.y)
#var colors = [Color(1.0, 0.0, 0.0, 1.0),
#		  Color(0.0, 1.0, 0.0, 1.0),
#		  Color(0.0, 0.0, 1.0, 0.0)]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


#func _input(event):
#	randomize()
#	modulate = colors[randi() % colors.size()]
	

func _process(_delta):
	if player_node.velocity.y != 0:
		position.y = player_node.position.y + initial_y_rel
	if player_node.velocity.x > 0:
		position.x = player_node.position.x + initial_x_rel
	elif player_node.velocity.x < 0:
		position.x = player_node.position.x - initial_x_rel
	handle_pinjoint.position = position
		
	
	
#func _integrate_forces(state):
#	state.add_torque(global_position.angle_to_point(get_global_mouse_position()))
	# state.add_torque(angular_damp)
