@tool
extends PanelContainer

@onready var portrait = $%Portrait
@onready var hearts_container = $%HeartsContainer
@onready var entity_name = $%EntityName

var delete_in
var key

func set_status(opts):
	if opts.get("texture"):
		portrait.set_texture(opts.get("texture"))

	if opts.get("name"):
		key = opts.get("name")
		entity_name.text = "%s" % opts.get("name")

	var h = opts.get("health")
	if h != null:
		hearts_container.h = h
		if h == 0:
			var ttl = opts.get("ttl", 5)
			delete_in = ttl if ttl else 5

	var ttl = opts.get("ttl", 5)
	if ttl > 0:
		delete_in = ttl

func _process(delta):
	if delete_in != null:
		delete_in -= delta
		if delete_in <= 0:
			queue_free()
