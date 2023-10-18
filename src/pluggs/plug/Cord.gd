extends Line2D

## vars ###########################################

var opts = {
	short={color=Color.BLACK, max_length=100},
	med={color=Color.PERU, max_length=125},
	long={color=Color.RED, max_length=150},
	}

var max_reached = false
var last_thresh

## _process ###########################################

func _process(_delta):
	update_opts()

## update_opts ###########################################

func update_opts():
	var l = length()

	var os = opts.values().filter(func(opt): return opt.max_length > l)

	if len(os) == 0:
		max_reached = true
		Debug.pr("pull the plug!")
		return

	os.sort_custom(func(a, b): return a.max_length < b.max_length)
	var opt = os[0]
	if opt == last_thresh:
		# no change, do nothing.
		return

	last_thresh = opt
	set_default_color(opt.color)

## length ###########################################

var last_point_count
var last_len
func length():
	var point_count = get_point_count()
	if last_point_count == point_count:
		return last_len
	last_point_count = point_count

	var dist = 0
	var last_p
	for i in range(point_count):
		if last_p != null:
			dist += last_p.distance_to(get_point_position(i))
		last_p = get_point_position(i)
	last_len = dist
	return dist
