extends Node2D


func _ready():
	Game.player_found.connect(setup)
	if Game.player and is_instance_valid(Game.player):
		setup(Game.player)

	# when is this quest complete?
	Q.register_quest(self, {"check_not_failed": true, "label": "Stay Alive!"})

func _exit_tree():
	Q.unregister(self, {"check_not_failed": true, "label": "Stay Alive!"})


# signal quest_complete
signal quest_failed
# signal count_remaining_update
# signal count_total_update

var player

func setup(p):
	player = p
	U._connect(p.destroyed, _on_player_destroyed)

func _on_player_destroyed(_snake):
	quest_failed.emit()
