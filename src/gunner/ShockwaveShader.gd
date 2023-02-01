extends CanvasLayer

onready var rect = $Rect
onready var pos = $Position2D

var node
var screen_size


# Called when the node enters the scene tree for the first time.
func _ready():
	if not node:
		node = rect

	update_screen_size()
	var _x = get_tree().connect("screen_resized", self, "update_screen_size")


func update_screen_size():
	screen_size = get_viewport().get_visible_rect().size

	if node:
		set_node(node)


func set_node(n):
	print("setting node for shockwave shader: ", n)
	node = n

	print("\nscreensize: ", screen_size)
	var ratio = screen_size.x / screen_size.y

	var center = node.get_global_position()
	if node == rect:
		print("half rect size", node.rect_size / 2)
		print("global pos", node.get_global_position())
		center = node.get_global_position() + (node.rect_size / 2)
		pos.set_global_position(center)

	print("center", center)
	center.x = center.x / screen_size.x
	center.x = (center.x - 0.5) / ratio + 0.5
	center.y = (screen_size.y - center.y) / screen_size.y
	print("center", center)


func _process(_delta):
	if node and is_instance_valid(node):
		# print("\nscreensize: ", screen_size)
		var ratio = screen_size.x / screen_size.y

		var center = node.get_global_position()
		if node == rect:
			# print("half rect size", (node.rect_size / 2))
			# print("global pos", node.get_global_position())
			center = node.get_global_position() + (node.rect_size / 2)
			pos.set_global_position(center)

		# print("center", center)
		center.x = center.x / screen_size.x
		center.x = (center.x - 0.5) / ratio + 0.5
		center.y = (screen_size.y - center.y) / screen_size.y
		# print("center", center)

		rect.material.set_shader_param("center", center)
		# rect.material.set_shader_param("center", Vector2(0.5, 0.5))
		# rect.material.set_shader_param("global_position", node.get_global_position())
