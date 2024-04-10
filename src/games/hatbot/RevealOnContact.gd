extends Area2D

@export var node_paths: Array[NodePath]

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("player"):
		reveal()

func reveal():
	for n in node_paths:
		var node = get_node(n)
		if node:
			node.set_visible(true)
