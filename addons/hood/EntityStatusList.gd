@tool
extends VBoxContainer

@export var max_children: int = 3

var status_scene = preload("res://addons/hood/EntityStatus.tscn")

func find_existing_status(entry):
	for ch in get_children():
		if ch.key == entry.get("name"):
			return ch

# Expects to be handed a Hotel entry (a dict)
func update_status(entry):
	var nm = entry.get("name")

	var existing = find_existing_status(entry)
	if existing and is_instance_valid(existing):
		# assume it's just a health update
		existing.set_status({health=entry.get("health")})
	else:
		if len(get_children()) >= max_children:
			Debug.pr("Too many entity_statuses, skipping add", entry)
			# TODO evict least-relevant/next-to-go status instead
			return

		var status = status_scene.instantiate()
		add_child(status)

		var ttl = entry.get("ttl")
		if ttl == null:
			ttl = 0 if "bosses" in entry.get("groups", []) else 5

		var opts = {name=nm, ttl=ttl, health=entry.get("health")}

		if opts.get("texture"):
			opts["texture"] = opts.get("texture")

		# call after adding so _ready has added elems
		status.set_status(opts)
