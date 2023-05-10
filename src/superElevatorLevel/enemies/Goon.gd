@tool
extends BEUBody


## physics ###########################################################

func _physics_process(delta):
	super._physics_process(delta)

	# very basic enemy fighting back
	# needs delete and better effort
	if len(punch_box_bodies) > 0 and machine.state.name in ["Idle", "Wander"]:
		machine.transit("Punch")
