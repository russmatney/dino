extends VBoxContainer

func _ready():
	var _x = Hood.connect("notification", self, "new_notification")
	Hood.notif("[HOOD] Notifications online.")

var notif_label = preload("res://addons/hood/NotifLabel.tscn")

func new_notification(notif):
	var lbl = notif_label.instance()
	lbl.text = notif["msg"]
	lbl.ttl = notif["ttl"]
	add_child(lbl)
