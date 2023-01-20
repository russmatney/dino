tool
extends TowerRoom

func _ready():
	print("tower end room ready")

func _on_regen():
	spawn_targets()
