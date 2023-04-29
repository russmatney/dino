extends CanvasLayer


func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)
	_on_entry_updated(Hotel.first({is_player=true}))


func _on_entry_updated(entry={}):
	Debug.log("entry", entry)
	if entry != null and "player" in entry.get("groups", {}):
		if entry.get("health") != null:
			set_health(entry["health"])
		if entry.get("pickups") != null:
			set_pickups(entry["pickups"])


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

@onready var destroyed_label = get_node("%TargetsDestroyed")
@onready var remaining_label = get_node("%TargetsRemaining")


func update_targets_destroyed(count):
	destroyed_label.text = "Targets Destroyed: " + str(count)


func update_targets_remaining(count):
	remaining_label.text = "Targets Remaining: " + str(count)
