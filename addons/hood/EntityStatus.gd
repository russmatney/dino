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

	var ent = opts.get("entity")

	var texture = opts.get("texture", ent.get_icon_texture() if ent else null)
	if texture:
		portrait.set_texture(texture)

	if opts.get("key"):
		key = opts.get("key")

	var display_name = opts.get("name", ent.get_display_name() if ent else null)
	if display_name:
		if key == null:
			key = display_name
		entity_name.text = "%s" % display_name

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
