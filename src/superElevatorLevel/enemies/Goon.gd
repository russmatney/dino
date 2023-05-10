@tool
extends BEUBody

# func _enter_tree():
# 	Debug.prn("id", get_instance_id())
# 	Debug.prn("inst", instance_from_id(get_instance_id()))
# 	Debug.prn("inst.name", instance_from_id(get_instance_id()).name)
# 	Debug.prn("name", name)
# 	Debug.prn(
# 	Util.packed_scene_data(self.scene_file_path, true)
# 		)

## physics ###########################################################

# func _physics_process(delta):
# 	# very basic enemy fighting back
# 	# needs delete and better effort
# 	if len(punch_box_bodies) > 0 and machine.state.name in ["Idle", "Wander"]:
# 		machine.transit("Punch")
