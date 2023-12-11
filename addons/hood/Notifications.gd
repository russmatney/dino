@tool
extends VBoxContainer

var scene_ready

@export var add_notif = "" :
	set(txt):
		add_notif = txt
		if txt and scene_ready:
			_on_notification({"msg": txt})

@export var add_rich_notif = "" :
	set(txt):
		add_rich_notif = txt
		if txt and scene_ready:
			_on_notification({"msg": txt, "rich": true})

#############################################################

func _ready():
	Hood.notification.connect(_on_notification)
	Hood.notif("[HOOD] Notifications online.")
	scene_ready = true

#############################################################

var notif_label = preload("res://addons/hood/NotifLabel.tscn")
var notif_rich_label = preload("res://addons/hood/NotifRichLabel.tscn")

var id_notifs = {}

# TODO support 'id' on notifs so we can update them in-place
# TODO support passed icon to decorate the notif/toast
func _on_notification(notif: Dictionary):
	var lbl

	var id = notif.get("id")
	var found_existing = false
	if id != null:
		if id in id_notifs:
			var l = id_notifs[id]
			if is_instance_valid(l) and not l.is_queued_for_deletion():
				lbl = l
				found_existing = true
				# TODO reset ttl/countdown, pull up to top
			else:
				id_notifs.erase(id)

	var text = notif.get("text", notif.get("msg"))

	if not found_existing and notif.get("rich"):
		lbl = notif_rich_label.instantiate()
		lbl.text = "[right]%s[/right]" % text
	elif not found_existing:
		lbl = notif_label.instantiate()
		lbl.text = text

	if notif.get("rich"):
		lbl.text = "[right]%s[/right]" % text
	else:
		lbl.text = text
	lbl.ttl = notif.get("ttl", 3.0)

	if found_existing:
		lbl.reset_ttl()

	if id != null:
		id_notifs[id] = lbl

	if not found_existing:
		add_child(lbl)
	if Engine.is_editor_hint():
		lbl.set_owner(owner)
