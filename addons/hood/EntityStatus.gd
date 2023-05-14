@tool
extends PanelContainer

@onready var portrait = $%Portrait
@onready var hearts_container = $%HeartsContainer
@onready var entity_name = $%EntityName

var delete_in
var key
var ttl

func set_status(opts):
	ttl = opts.get("ttl", ttl)

	if opts.get("texture"):
		portrait.set_texture(opts.get("texture"))

	if opts.get("key"):
		key = opts.get("key")

	if opts.get("name"):
		if key == null:
			key = opts.get("name")
		entity_name.text = "%s" % opts.get("name")

	var h = opts.get("health")
	if h != null:
		hearts_container.h = h
		if h == 0:
			if ttl != null:
				delete_in = ttl if ttl else 5

	if ttl != null:
		delete_in = ttl

func _process(delta):
	if delete_in != null:
		delete_in -= delta
		if delete_in <= 0:
			queue_free()
