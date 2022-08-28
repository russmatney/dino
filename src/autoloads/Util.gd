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
