extends CanvasLayer

func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)
	_on_entry_updated(Hotel.first({is_player=true}))

	var rooms = Hotel.query({group=GhostsData.rooms_group})
	# TODO sort by ready_at ? or some other 'current' flag?
	if len(rooms) > 0:
		set_room_name(rooms[0].get("name"))

func _on_entry_updated(entry):
	if "player" in entry["groups"]:
		if entry.get("health") != null:
			set_health(entry["health"])
		if entry.get("gloomba_kos") != null:
			set_gloomba_kos(entry["gloomba_kos"])
	if GhostsData.rooms_group in entry["groups"]:
		Debug.prn("Ghosts rooms group entry update", entry)
		set_room_name(entry["name"])

###################################################################
# update health

func set_health(health):
	var hearts = get_node("%HeartsContainer")
	hearts.set_health(health)

###################################################################
# gloomba count

func set_gloomba_kos(gloomba_kos):
	var label = get_node("%GloombaKOs")
	label.set_text(str("Gloomba K.O.s: ", gloomba_kos))

###################################################################
# room name

func set_room_name(room_name):
	var label = get_node("%Room")
	label.set_text(str("Room: ", room_name))
