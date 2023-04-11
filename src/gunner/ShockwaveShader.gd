extends CanvasLayer

@onready var rect = $Rect
@onready var pos = $Marker2D

var node
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	if not node:
		node = rect

	update_screen_size()
	var _x = get_tree().screen_resized.connect(update_screen_size)


func update_screen_size():
	screen_size = get_viewport().get_visible_rect().size

	if node:
		set_node(node)


func set_node(n):
	Debug.pr("setting node for shockwave shader: ", n)
	node = n

	Debug.pr("\nscreensize: ", screen_size)
	var ratio = screen_size.x / screen_size.y

	var center = node.get_global_position()
	if node == rect:
		Debug.pr("half rect size", node.size / 2)
		Debug.pr("global pos", node.get_global_position())
		center = node.get_global_position() + (node.size / 2)
		pos.set_global_position(center)

	Debug.pr("center", center)
	center.x = center.x / screen_size.x
	center.x = (center.x - 0.5) / ratio + 0.5
	center.y = (screen_size.y - center.y) / screen_size.y
	Debug.pr("center", center)


func _process(_delta):
	if node and is_instance_valid(node):
		# Debug.pr("\nscreensize: ", screen_size)
		var ratio = screen_size.x / screen_size.y

		var center = node.get_global_position()
		if node == rect:
			# Debug.pr("half rect size", (node.size / 2))
			# Debug.pr("global pos", node.get_global_position())
			center = node.get_global_position() + (node.size / 2)
			pos.set_global_position(center)

		# Debug.pr("center", center)
		center.x = center.x / screen_size.x
		center.x = (center.x - 0.5) / ratio + 0.5
		center.y = (screen_size.y - center.y) / screen_size.y
		# Debug.pr("center", center)

		rect.material.set_shader_parameter("center", center)
		# rect.material.set_shader_parameter("center", Vector2(0.5, 0.5))
		# rect.material.set_shader_parameter("global_position", node.get_global_position())
