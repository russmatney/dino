extends Node2D


func _ready():
	var _x = Hood.connect("found_player", self, "setup")
	if Hood.player and is_instance_valid(Hood.player):
		setup(Hood.player)

	# when is this quest complete?
	Quest.register_quest(self, {"check_not_failed": true, "label": "Stay Alive!"})

func _exit_tree():
	Quest.unregister(self, {"check_not_failed": true, "label": "Stay Alive!"})


# signal quest_complete
signal quest_failed
# signal count_remaining_update
# signal count_total_update

var player

func setup(p):
	player = p
	p.connect("destroyed", self, "_on_player_destroyed")

func _on_player_destroyed(_snake):
	emit_signal("quest_failed")
