@tool
extends VBoxContainer

var scene_ready

@export var add_notif = "" :
	set(txt):
		add_notif = txt
		if txt and scene_ready:
			on_debug_notification({"msg": txt})

@export var add_rich_notif = "" :
	set(txt):
		add_rich_notif = txt
		if txt and scene_ready:
			on_debug_notification({"msg": txt, "rich": true})

@export var _clear : bool :
	set(v):
		_clear = v
		for ch in get_children():
			ch.queue_free()

@export var side = "left"

#############################################################

func _ready():
	Debug.debug_notification.connect(on_debug_notification)
	Debug.notif("[DEBUG] Notifications online.", {id="initial"})
	scene_ready = true

#############################################################

var notif_label = preload("res://src/components/notifications/NotifLabel.tscn")
var notif_rich_label = preload("res://src/components/notifications/NotifRichLabel.tscn")

var id_notifs = {}

func on_debug_notification(notif: Dictionary):
	var lbl

	var text = notif.get("text", notif.get("msg"))

	var id = notif.get("id", text)
	var found_existing = false
	if id != null:
		if id in id_notifs:
			var l = id_notifs[id]
			if is_instance_valid(l) and not l.is_queued_for_deletion():
				lbl = l
				found_existing = true
			else:
				id_notifs.erase(id)

	if not found_existing:
		if notif.get("rich"):
			lbl = notif_rich_label.instantiate()
		else:
			lbl = notif_label.instantiate()

	if notif.get("rich"):
		lbl.text = "[%s]%s[/%s]" % [side, text, side]
	else:
		lbl.text = text

	lbl.ttl = notif.get("ttl", 3.0)

	if found_existing:
		lbl.reset_ttl()
		lbl.reemphasize()

	if id != null:
		id_notifs[id] = lbl

	if not found_existing:
		add_child(lbl)
