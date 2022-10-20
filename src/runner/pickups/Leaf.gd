tool
extends Node2D

enum leaf_colors {green, greenred, redorange, yellow, purple}
func to_anim(c):
	match c:
		leaf_colors.green: return "green"
		leaf_colors.greenred: return "greenred"
		leaf_colors.redorange: return "redorange"
		leaf_colors.yellow: return "yellow"
		leaf_colors.purple: return "purple"

export(leaf_colors) var color = leaf_colors.redorange

onready var anim = $AnimatedSprite

###################################################
# ready

func _ready():
	anim.animation = to_anim(color)

	if Engine.editor_hint:
		request_ready()

###################################################
# interactions

func _on_Area2D_body_entered(body: Node):
	if body.has_method("caught_leaf"):
		body.caught_leaf({"color": color})
		queue_free()
