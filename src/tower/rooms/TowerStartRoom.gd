tool
extends TowerRoom


func _on_regen():
	add_player_spawner()
	add_enemy_spawner()
	spawn_targets()
	add_pickups()
