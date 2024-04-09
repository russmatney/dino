extends CanvasLayer


func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)


	# starting to feel like we want a hotel-data init right before the game starts
	_on_entry_updated(Hotel.first({is_player=true}))
	var quests = Hotel.query({group="quests"})
	quests.map(_on_entry_updated)


func _on_entry_updated(entry={}):
	if entry == null:
		return
	if "player" in entry.get("groups"):
		if entry.get("health") != null:
			set_health(entry["health"])


###################################################################
# update health


func set_health(health):
	var hearts = get_node("%HeartsContainer")
	hearts.set_health(health)
