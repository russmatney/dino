tool
extends TowerRoom

func _ready():
	print("tower middle room ready")

func _on_regen():
	spawn_targets()
