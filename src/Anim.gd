@tool
extends Object
class_name Anim

# NOTE node.current_position() can be impled to force a return/target position

static func slide_in(node, dist=10, t=0.6):
	var og_position = node.current_position() if node.has_method("current_position") else node.position
	# jump + shrink to starting position :/
	node.position = node.position - Vector2.ONE * dist
	node.scale = Vector2.ONE * 0.5

	if not node.is_inside_tree() or not is_instance_valid(node):
		return

	var tween = node.create_tween()
	tween.tween_property(node, "scale", Vector2.ONE, t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(node, "position", og_position, t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

static func slide_out(node, t=0.6):
	var og_position = node.current_position() if node.has_method("current_position") else node.position
	var target_position = og_position - Vector2.ONE * 10

	if not node.is_inside_tree() or not is_instance_valid(node):
		return

	var tween = node.create_tween()
	tween.tween_property(node, "scale", Vector2.ONE * 0.5, t)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(node, "position", target_position, t)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(node, "modulate:a", 0.0, t)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

static func slide_from_point(node, pos=Vector2.ZERO, t=0.6, delay_ts=[]):
	var delay_t = U.rand_of(delay_ts)
	var og_position = node.current_position() if node.has_method("current_position") else node.position
	# jump + shrink to starting position :/
	node.position = pos
	node.scale = Vector2.ONE * 0.5
	node.modulate.a = 0.5

	if not node.is_inside_tree() or not is_instance_valid(node):
		return

	var tween = node.create_tween()
	if delay_t:
		tween.tween_interval(delay_t)
	tween.tween_property(node, "scale", Vector2.ONE, t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(node, "position", og_position, t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(node, "modulate:a", 1.0, t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

static func slide_to_point(node, target_position=Vector2.ZERO, t=0.6, delay_ts=[]):
	var delay_t = U.rand_of(delay_ts)

	if not node.is_inside_tree() or not is_instance_valid(node):
		return

	var tween = node.create_tween()
	if delay_t:
		tween.tween_interval(delay_t)
	tween.tween_property(node, "scale", Vector2.ONE * 0.5, t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(node, "position", target_position, t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(node, "modulate:a", 0.0, t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)

# helper

static func tween_on_node(node, tween_name):
	if not node.is_inside_tree():
		return
	if tween_name in node:
		node[tween_name] = node.create_tween()
		return node[tween_name]
	else:
		return node.create_tween()

# move

static func move_to_coord(node, coord, t, trans=Tween.TRANS_CUBIC, _ease=Tween.EASE_OUT):
	var target_pos = coord * node.square_size
	var tween = tween_on_node(node, "move_tween")
	if not tween:
		return
	tween.tween_property(node, "position", target_pos, t).set_trans(trans).set_ease(_ease)

static func move_attempt_pull_back(node, og_position, target_position, t):
	var tween = tween_on_node(node, "move_tween")
	if not tween:
		return
	tween.tween_property(node, "position", target_position, t/2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "position", og_position, t/2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

static func float_a_bit(node, og_position, t=0.8, trans=Tween.TRANS_CUBIC, _ease=Tween.EASE_OUT):
	var tween = tween_on_node(node, "float_tween")
	if not tween:
		return
	var dist = 3
	var dir = Vector2(randfn(0.0, 1.0), randfn(0.0, 1.0)).normalized()
	var offset = dir * dist
	tween.tween_property(node, "position", og_position + offset, t).set_trans(trans).set_ease(_ease)
	tween.tween_interval(t/2)
	tween.tween_property(node, "position", og_position, t).set_trans(trans).set_ease(_ease)
	tween.tween_interval(t/3)
	tween.tween_callback(Anim.float_a_bit.bind(node, og_position, t, trans, _ease))

# Scales

static func scale_up_down_up(node, t):
	var tween = tween_on_node(node, "scale_tween")
	if not tween:
		return
	tween.tween_property(node, "scale", 1.3*Vector2.ONE, t/2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", 0.8*Vector2.ONE, t/4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", 1.0*Vector2.ONE, t/4).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

static func scale_down_up(node, t):
	var tween = tween_on_node(node, "scale_tween")
	if not tween:
		return
	tween.tween_property(node, "scale", 0.8*Vector2.ONE, t/2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", 1.0*Vector2.ONE, t/2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

static func scale_up_down(node, t):
	var tween = tween_on_node(node, "scale_tween")
	if not tween:
		return
	tween.tween_property(node, "scale", 1.3*Vector2.ONE, t/2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(node, "scale", 1.0*Vector2.ONE, t/2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

# fade

static func fade_in(node, t=0.5):
	var tween = tween_on_node(node, "fade_tween")
	if not tween:
		return
	tween.tween_property(node, "modulate:a", 1.0, t).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

static func fade_out(node, t=0.5):
	var tween = tween_on_node(node, "fade_tween")
	if not tween:
		return
	tween.tween_property(node, "modulate:a", 0.0, t).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

## whole scene transitions ###########################################################

static func animate_intro_from_point(opts: Dictionary):
	var node = opts.get("node")
	var nodes = opts.get("nodes")
	var from_pos = opts.get("position", Vector2())
	var t = opts.get("t", 0.6)

	for n in nodes:
		n.modulate.a = 0.0

	for n in nodes:
		var delays = []
		if U.rand_of([true, false, false, false]):
			delays.append(0.05)
		Anim.slide_from_point(n, from_pos, t, delays)

	return node.get_tree().create_timer(t).timeout

static func animate_outro_to_point(opts: Dictionary):
	var node = opts.get("node")
	var nodes = opts.get("nodes")
	var to_pos = opts.get("position", Vector2())
	var t = opts.get("t", 0.6)

	for n in nodes:
		var delays = []
		if U.rand_of([true, false, false, false]):
			delays.append(0.05)
		Anim.slide_to_point(n, to_pos, t, delays)

	return node.get_tree().create_timer(t).timeout

## toast ###########################################################

static func toast(node, opts={}):
	if opts.get("wait_frame", false):
		node.set_visible(false)
		await node.get_tree().process_frame

	var screen_rect = node.get_viewport_rect()
	var margin = opts.get("margin", 20)
	var target_pos = screen_rect.end - node.get_size() - Vector2.ONE * margin
	var initial_pos = Vector2(target_pos.x, screen_rect.size.y)
	var in_t = opts.get("in_t", 0.7)
	var out_t = opts.get("out_t", 0.7)
	var delay_t = opts.get("delay_t", 1.0)

	node.global_position = initial_pos
	node.set_visible(true)

	var t = node.create_tween()
	t.tween_property(node, "global_position", target_pos, in_t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

	t.tween_property(node, "global_position", initial_pos, out_t)\
		.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)\
		.set_delay(delay_t)

	if opts.get("free_node", true):
		t.tween_callback(node.queue_free)
