extends CanvasLayer

var player


func _ready():
	# TODO connect to player spawn signals instead
	find_player.call_deferred()

	var _x = Ghosts.notification.connect(new_notification)
	var _y = Ghosts.room_entered.connect(update_room_name)


###################################################################
# find player

@export var player_group: String = "player"


func find_player():
	if player_group == null:
		Debug.pr("[WARN] HUD has not player_group set")
		return

	var ps = get_tree().get_nodes_in_group(player_group)
	if ps.size() > 1:
		Debug.pr("[WARN] HUD found multiple in player_group: ", player_group)

	if ps.size() > 0:
		player = ps[0]
		Debug.pr("[HUD] found player: ", player)
	else:
		Debug.pr("[WARN] HUD found zero in player_group: ", player_group)
		return

	if player:
		player.health_change.connect(update_player_health)
		player.gloomba_koed.connect(update_gloomba_kos)

		# TODO restore zero state
		# update_player_health(player.health)
		# update_gloomba_kos(player.gloomba_kos)


###################################################################
# process


func _process(_delta):
	if not player:
		find_player()


###################################################################
# update health


func update_player_health(health):
	var hearts = get_node("%HeartsContainer")
	hearts.set_health(health)


###################################################################
# gloomba count


func update_gloomba_kos(gloomba_kos):
	var label = get_node("%GloombaKOs")
	label.set_text(str("Gloomba K.O.s: ", gloomba_kos))


###################################################################
# gloomba count


func update_room_name(room):
	var label = get_node("%Room")
	label.set_text(str("Room: ", room.name))


###################################################################
# Notifications

var notif_label = preload("res://addons/hood/NotifLabel.tscn")


func new_notification(notif):
	var lbl = notif_label.instantiate()
	lbl.text = notif["msg"]
	lbl.ttl = notif["ttl"]
	get_node("%Notifications").add_child(lbl)
