extends RigidBody2D

var player

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players:
		player = players[0]
		print("rib found player ", player)

func _on_Rib_body_entered(body: Node):
	if body.is_in_group("player") and body.has_method("hit"):
		body.hit(self)
