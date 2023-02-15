@tool
extends VBoxContainer

var scene_ready

@export var add_notif = "Some new notification" :
	set(txt):
		add_notif = txt
		print("setting notif: ", txt)
		if scene_ready:
			new_notification({"msg": txt})

@export var add_rich_notif = "Some rich notification" :
	set(txt):
		add_rich_notif = txt
		print("setting notif: ", txt)
		if scene_ready:
			new_notification({"msg": txt, "rich": true})

func _ready():
	var _x = Hood.connect("notification",Callable(self,"new_notification"))
	Hood.notif("[HOOD] Notifications online.")
	scene_ready = true

var notif_label = preload("res://addons/hood/NotifLabel.tscn")
var notif_rich_label = preload("res://addons/hood/NotifRichLabel.tscn")

func new_notification(notif: Dictionary):
	var lbl
	if "rich" in notif and notif["rich"]:
		lbl = notif_rich_label.instantiate()
		lbl.text = str("[right]", notif["msg"], "[/right]")
	else:
		lbl = notif_label.instantiate()
		lbl.text = notif["msg"]
	lbl.ttl = notif.get("ttl", 3.0)
	add_child(lbl)
	if Engine.is_editor_hint():
		lbl.set_owner(owner)
