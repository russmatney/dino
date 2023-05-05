extends CanvasLayer


func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)
	_on_entry_updated(Hotel.first({is_player=true}))

func _on_entry_updated(entry):
	if "player" in entry.get("groups", []):
		set_health(entry.get("health"))
	if "sheep" in entry.get("groups", []):
		update_sheep(entry)

func set_health(health):
	if health == null:
		return
	$%HeartsContainer.h = health

var sheep_status = preload("res://src/herd/hud/SheepStatus.tscn")

func update_sheep(entry):
	for c in $%SheepList.get_children():
		if c.get_node("SheepName").get_parsed_text() == entry.get("name"):
			c.set_health(entry.get("health"))
			return

	var new_sheep = sheep_status.instantiate()
	new_sheep.ready.connect(func():
		new_sheep.set_sheep_name(entry.get("name"))
		new_sheep.set_health(entry.get("health")))
	$%SheepList.add_child(new_sheep)
