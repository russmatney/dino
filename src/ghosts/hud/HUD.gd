extends CanvasLayer

var player


func _ready():
	# TODO connect to player spawn signals instead
	call_deferred("find_player")

	var _x = Ghosts.connect("notification", self, "new_notification")
	var _y = Ghosts.connect("room_entered", self, "update_room_name")


###################################################################
# find player

export(String) var player_group = "player"


func find_player():
	if not player_group:
		print("[WARN] HUD has not player_group set")
		return

	var ps = get_tree().get_nodes_in_group(player_group)
	if ps.size() > 1:
		print("[WARN] HUD found multiple in player_group: ", player_group)

	if ps:
		player = ps[0]
		print("[HUD] found player: ", player)
	else:
		print("[WARN] HUD found zero in player_group: ", player_group)
		return

	if player:
		player.connect("health_change", self, "update_player_health")
		player.connect("gloomba_koed", self, "update_gloomba_kos")

		update_player_health(player.health)
		update_gloomba_kos(player.gloomba_kos)

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

var notif_label = preload("res://src/ghosts/hud/NotifLabel.tscn")

func new_notification(notif):
	var lbl = notif_label.instance()
	lbl.text = notif["msg"]
	lbl.ttl = notif["ttl"]
	get_node("%Notifications").add_child(lbl)
