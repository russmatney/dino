@tool
extends AnimatedSprite2D
class_name OffscreenIndicator

## static ########################################################

static var fallback_indicator_scene = "res://src/components/offscreen_indicator/OffscreenIndicator.tscn"

static func maybe_activate(indicator, node, opts={}):
	var is_active = opts.get("is_active", func(): return true)
	if is_active.call():
		indicator.activate(node)

static func add(node, opts={}):
	var indicator_scene = opts.get("indicator_scene", fallback_indicator_scene)
	if indicator_scene is String:
		indicator_scene = load(indicator_scene)

	if not indicator_scene:
		Log.err("Failed to load indicator scene", indicator_scene, "on node", node)
		return

	var indicator = indicator_scene.instantiate()
	indicator.ready.connect(indicator.set_label_text.bind(opts.get("label")))

	var vis = VisibleOnScreenNotifier2D.new()
	vis.screen_exited.connect(OffscreenIndicator.maybe_activate.bind(indicator, node, opts))
	vis.screen_entered.connect(indicator.deactivate)

	node.add_child(indicator)
	node.add_child(vis)


## vars ########################################################

@onready var label = $%Label
var label_x_offset = 8

var offset_rads = PI / 4

var target
var showing = false

## label ########################################################

var label_side
func set_label_side(side):
	if side == label_side:
		return

	label_side = side
	match label_side:
		"left":
			label.pivot_offset.x = label.size.x + label_x_offset
			label.position.x = -label.size.x - label_x_offset
		"right":
			label.pivot_offset.x = -label_x_offset
			label.position.x = label_x_offset

func set_label_text(text):
	label.set_text("[center]%s" % text)

## point at ########################################################

func point_at(pos):
	look_at(pos)
	rotate(offset_rads)
	label.rotation = -rotation

	if rotation_degrees > 90.0 or rotation_degrees < 0.0:
		set_label_side("right")
	else:
		set_label_side("left")


# debug code for pointing at the mouse
# func _input(event):
# 	if event is InputEventMouseButton:
# 		point_at(get_global_mouse_position())
# if event is InputEventMouseMotion:
# 	Log.info("mouse: ", get_global_mouse_position())

## process ########################################################

func _physics_process(_delta):
	if target and is_instance_valid(target) and showing:
		point_at(target.get_global_position())
		position_onscreen()

## position on screen ########################################################

func cam_window_rect():
	var v = get_viewport()
	var viewportRect: Rect2 = v.get_visible_rect()

	# https://github.com/godotengine/godot/issues/34805
	# restore this size correction
	# var viewport_base_size = (
	# 	v.get_size_2d_override()
	# 	if v.get_size_2d_override()
	# 	else v.size
	# )
	var viewport_base_size = v.size

	var scale_factor = DisplayServer.window_get_size() / viewport_base_size
	viewportRect.size = (viewport_base_size * scale_factor) as Vector2

	# https://www.reddit.com/r/godot/comments/m8ltmd/get_screen_in_global_coords_get_visible_rect_not/
	var globalToViewportTransform: Transform2D = v.get_final_transform() * v.canvas_transform
	var viewportToGlobalTransform: Transform2D = globalToViewportTransform.affine_inverse()
	var viewportRectGlobal: Rect2 = viewportToGlobalTransform * viewportRect

	return viewportRectGlobal

func position_onscreen():
	var player = Dino.current_player_node()

	if player:
		# TODO why use the player here? why not just the center of the screen?
		var player_pos = player.get_global_position() + Vector2(0, -16)
		var target_pos = target.get_global_position()
		var direction = (target_pos - player_pos).normalized()

		var window_rect = cam_window_rect()

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

## act/deactivate ########################################################

func activate(node):
	target = node
	showing = true
	set_visible(true)


func deactivate():
	showing = false
	set_visible(false)
