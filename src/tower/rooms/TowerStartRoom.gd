tool
extends TowerRoom

func _ready():
	print("tower start room ready")

func _on_regen():
	spawn_targets()
