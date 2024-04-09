@tool
extends StaticBody2D

@export var max_width: float = 128.0:
	set(w):
		max_width = w
		if is_node_ready():
			update_width(w)

func _ready():
	update_width(max_width)

func update_width(w):
	# naive impl!
	var shape = shape_owner_get_shape(0, 0)
	shape.size.x = w

	for ch in get_children():
		if ch is ColorRect:
			ch.size.x = w
			ch.position.x = w / -2.0
