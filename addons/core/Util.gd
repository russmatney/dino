extends Node


func _or(a, b = null, c = null, d = null, e = null):
	if a:
		return a
	if b:
		return b
	if c:
		return c
	if d:
		return d
	if e:
		return e

func reparent(child: Node, new_parent: Node):
	# do we need to set owner?
    var old_parent = child.get_parent()
    old_parent.remove_child(child)
    new_parent.add_child(child)

# https://godotengine.org/qa/27869/how-to-get-the-nearest-object-in-a-group
func nearest_node(source: Node, targets) -> Node:
    # assume the first is closest
    var nearest_target = targets[0]

    # look through spawn nodes to see if any are closer
    for target in targets:
         if target.global_position.distance_to(source.global_position) < nearest_target.global_position.distance_to(source.global_position):
            nearest_target = target

    return nearest_target
