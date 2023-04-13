extends CanvasLayer

func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)
	_on_entry_updated(Hotel.first({is_player=true}))

func _on_entry_updated(entry):
	if "player" in entry["groups"]:
		if entry.get("health") != null:
			set_health(entry["health"])
		if entry.get("gloomba_kos") != null:
			set_gloomba_kos(entry["gloomba_kos"])
	if Ghosts.rooms_group in entry["groups"]:
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
