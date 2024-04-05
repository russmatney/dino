@tool
extends VBoxContainer

@export var max_children: int = 3

var status_scene = preload("res://addons/core/hood/EntityStatus.tscn")

func find_existing_status(entry):
	for ch in get_children():
		if ch.key == entry.get("key", entry.get("name")):
			return ch

var warned_once = false

# Expects to be handed a Hotel entry (a dict)
func update_status(entry):
	var nm = entry.get("display_name", entry.get("name"))

	var existing = find_existing_status(entry)
	if existing and is_instance_valid(existing):
		# assume it's just a health update
		existing.set_status({health=entry.get("health"), name=nm})
	else:
		if len(get_children()) >= max_children:
			if not warned_once:
				Log.warn("Too many entity_statuses, skipping add", nm)
				warned_once = true
			# should evict least-relevant/next-to-go status instead
			return

		var status = status_scene.instantiate()
		add_child(status)

		var opts = {key=entry.get("key"), name=nm, ttl=entry.get("ttl"), health=entry.get("health")}

		if entry.get("texture"):
			opts["texture"] = entry.get("texture")

		# call after adding so _ready has added elems
		status.set_status(opts)
