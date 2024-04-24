extends DinoLevel

## setup ###################################################

func _ready():
	connect_to_rooms()

	super._ready()

func connect_to_rooms():
	if Engine.is_editor_hint():
		return
	for ent in $Entities.get_children():
		if ent.is_in_group("arcade_machine"):
			U._connect(ent.plugged, on_arcade_machine_plugged)

## on plugged ###################################################

func on_arcade_machine_plugged():
	Log.pr("arcade machine plugged!")

	level_complete.emit()
