extends Node
# expects to be autoloaded

var current_scene = null

var last_scene_stack = []

###########################################################################
# ready
###########################################################################


func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)

	if "node_path" in current_scene:
		last_scene_stack.push_back(current_scene.node_path)
	print("[Navi] Current scene: ", current_scene)


###########################################################################
# goto_scene
###########################################################################


func nav_to(path):
	last_scene_stack.push_back(path)
	call_deferred("_deferred_goto_scene", path)


func _deferred_goto_scene(path):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(path)

	# Instance the new scene.
	current_scene = s.instance()
	print("[Navi] Current scene: ", current_scene)
	print("[Navi] last scene stack: ", last_scene_stack)

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
