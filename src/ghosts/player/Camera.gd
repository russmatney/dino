extends Camera2D

enum cam_mode { FOLLOW, ANCHOR }
@export var mode: cam_mode = cam_mode.FOLLOW

var following
@export var follow_group: String = "player"
var current_anchor  # only set in ANCHOR mode
@export var anchor_group: String = "camera_anchor"


func find_node_to_follow():
	var nodes = get_tree().get_nodes_in_group(follow_group)

	if nodes.size() > 1:
		Debug.warn("Camera found multiple nodes to follow", nodes)

	if nodes.size() > 0:
		following = nodes[0]
		match mode:
			cam_mode.FOLLOW:
				Util.change_parent(self, following)
			cam_mode.ANCHOR:
				attach_to_nearest_anchor()


func attach_to_nearest_anchor():
	# assumes `following` is set as desired

	# find nearest anchor node, reparent to that
	var anchors = get_tree().get_nodes_in_group(anchor_group)
	if anchors.size() == 0:
		Debug.warn("Camera found no anchor nodes, attaching to player")
		Util.change_parent(self, following)
	else:
		# TODO this may be too expensive to run per process-loop, there's likely an optimization...
		# maybe only run this when the player moves some distance?
		# or make it disable-able/only called from an autoload/at specific times

		# handling in case the player dies before here
		if is_instance_valid(following):
			var nearest_anchor = Util.nearest_node(following, anchors)
			if nearest_anchor != current_anchor:
				current_anchor = nearest_anchor
				Util.change_parent(self, current_anchor)
		else:
			following = null


###########################################################################


func _ready():
	if not following:
		find_node_to_follow()


###########################################################################


func _process(_delta):
	match mode:
		cam_mode.FOLLOW:
			if not following:
				find_node_to_follow()
		cam_mode.ANCHOR:
			if not following:
				find_node_to_follow()
			else:
				if is_instance_valid(following):
					attach_to_nearest_anchor()
				else:
					following = null
