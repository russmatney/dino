extends RigidBody2D

var player

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players:
		player = players[0]
		print("rib found player ", player)
		# Util.ensure_connection("")

# func _physics_process(delta):
# 	pass
