tool
extends TowerRoom

func _ready():
	print("tower start room ready")

func _on_regen():
	add_player_spawner()
	spawn_targets()
