extends CanvasLayer


func _ready():
	var _x = Hood.connect("notification",Callable(self,"new_notification"))

	call_deferred("find_player")


###################################################################
# player setup

var player
var player_group = "player"


func find_player():
	var ps = get_tree().get_nodes_in_group(player_group)

	if ps.size() > 1:
		Debug.pr("[WARN] HUD found multiple in player_group: ", player_group)
	if ps:
		player = ps[0]
		Debug.pr("[HUD] found player: ", player)
	else:
		Debug.pr("[WARN] HUD found zero in player_group: ", player_group)
		return

	if player:
		player.connect("health_change",Callable(self,"update_player_health"))
		update_player_health(player.health)
		player.connect("pickups_changed",Callable(self,"update_player_pickups"))
		update_player_pickups(player.pickups)


###################################################################
# Notifications

var notif_label = preload("res://addons/hood/NotifLabel.tscn")


func new_notification(notif):
	var lbl = notif_label.instantiate()
	lbl.text = notif["msg"]
	lbl.ttl = notif["ttl"]
	get_node("%Notifications").add_child(lbl)


###################################################################
# update health


func update_player_health(health):
	var hearts = get_node("%HeartsContainer")
	hearts.set_health(health)


###################################################################
# update pickups


func update_player_pickups(pickups):
	var p = get_node("%PickupsContainer")
	p.update_pickups(pickups)


###################################################################
# update targets

@onready var destroyed_label = get_node("%TargetsDestroyed")
@onready var remaining_label = get_node("%TargetsRemaining")


func update_targets_destroyed(count):
	destroyed_label.text = "Targets Destroyed: " + str(count)


func update_targets_remaining(count):
	remaining_label.text = "Targets Remaining: " + str(count)
