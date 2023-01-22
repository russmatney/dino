tool
extends TowerRoom

func _on_regen():
	add_player_spawner()
	spawn_targets()
	add_pickups()
