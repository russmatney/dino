@tool
extends BEUBody

@onready var palettes = [null,
	preload("res://src/superElevatorLevel/enemies/GoonAlt1.tres"),
	preload("res://src/superElevatorLevel/enemies/GoonAlt2.tres"),
	]

## ready ###########################################################

func _ready():
	super._ready()

	var pal = Util.rand_of(palettes)

	if pal != null:
		anim.material = pal


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
