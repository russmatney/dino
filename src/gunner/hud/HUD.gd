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
		if entry.get("pickups") != null:
			set_pickups(entry["pickups"])
	if "quests" in entry.get("groups"):
		# yucky string deps
		if entry.get("destroyed_count") != null:
			set_targets_destroyed(entry.get("destroyed_count"))
		if entry.get("remaining_count") != null:
			set_targets_remaining(entry.get("remaining_count"))


###################################################################
# update health


func set_health(health):
	var hearts = get_node("%HeartsContainer")
	hearts.set_health(health)


###################################################################
# update pickups


func set_pickups(pickups):
	var p = get_node("%PickupsContainer")
	p.update_pickups(pickups)


###################################################################
# update targets

func set_targets_destroyed(count):
	var destroyed_label = get_node("%TargetsDestroyed")
	destroyed_label.text = "Targets Destroyed: " + str(count)


func set_targets_remaining(count):
	var remaining_label = get_node("%TargetsRemaining")
	remaining_label.text = "Targets Remaining: " + str(count)
