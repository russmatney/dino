@tool
extends AnimatedSprite2D

var offset_rads = PI / 4

var target
var showing = false
var player


func _ready():
	player = Util.first_node_in_group("player")


func point_at(pos):
	look_at(pos)
	rotate(offset_rads)


# func _input(event):
# 	if event is InputEventMouseButton:
# 		point_at(get_global_mouse_position())
# if event is InputEventMouseMotion:
# 	print("mouse: ", get_global_mouse_position())


func _physics_process(_delta):
	if target and is_instance_valid(target) and showing:
		point_at(target.get_global_position())
		position_onscreen()


func find_player():
	if not Engine.is_editor_hint():
		player = Util.first_node_in_group("player")


func position_onscreen():
	if not player:
		find_player()

	if not Cam.cam:
		return

	if player and Cam.cam:
		var player_pos = player.get_global_position() + Vector2(0, -16)
		var target_pos = target.get_global_position()
		var direction = (target_pos - player_pos).normalized()

		var window_rect = Cam.cam_window_rect()

		var is_x_off_screen = not window_rect.has_point(Vector2(target_pos.x, player_pos.y))
		var is_y_off_screen = not window_rect.has_point(Vector2(player_pos.x, target_pos.y))

		var x_offset = 30
		var y_offset = 30
		var new_pos = Vector2()
		if is_x_off_screen:
			if direction.x > 0:
				new_pos.x = window_rect.end.x - x_offset
			else:
				new_pos.x = window_rect.position.x + x_offset
		else:
			if direction.x > 0:
				new_pos.x = target_pos.x - x_offset
			else:
				new_pos.x = target_pos.x + x_offset

		if is_y_off_screen:
			if direction.y > 0:
				new_pos.y = window_rect.end.y - y_offset
			else:
				new_pos.y = window_rect.position.y + y_offset
		else:
			if direction.y > 0:
				new_pos.y = target_pos.y - y_offset
			else:
				new_pos.y = target_pos.y + y_offset

		global_position = new_pos


func activate(node):
	target = node
	if not showing:
		showing = true
		set_visible(true)
	point_at(node.get_global_position())


func deactivate():
	if showing:
		showing = false
		set_visible(false)
