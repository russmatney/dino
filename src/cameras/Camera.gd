extends Camera2D


var following
export(String) var follow_group = "player"

func find_node_to_follow():
	var nodes = get_tree().get_nodes_in_group(follow_group)

	if nodes.size() > 1:
		print("Camera found multiple nodes to follow", nodes)

	if nodes.size() > 0:
		following = nodes[0]
		print("camera found player!", following)

###########################################################################

func _ready():
	if not following:
	    find_node_to_follow()

###########################################################################

func _process(_delta):
	if not following:
	    find_node_to_follow()
