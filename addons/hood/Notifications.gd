extends VBoxContainer

func _ready():
	var _x = Hood.connect("notification", self, "new_notification")
	Hood.notif("[HOOD] Notifications online.")

var notif_label = preload("res://addons/hood/NotifLabel.tscn")
var notif_rich_label = preload("res://addons/hood/NotifRichLabel.tscn")

func new_notification(notif):
	var lbl
	if "rich" in notif and notif["rich"]:
		lbl = notif_rich_label.instance()
		lbl.bbcode_text = str("[right]", notif["msg"], "[/right]")
	else:
		lbl = notif_label.instance()
		lbl.text = notif["msg"]
	lbl.ttl = notif.get("ttl", 3.0)
	add_child(lbl)
