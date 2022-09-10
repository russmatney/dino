extends Area2D


export(String) var label

func weapon_def():
	var def = {"type": "bow"}
	if label:
		def["label"] = label
	return def

func _on_Bow_body_entered(body:Node):
	if body.has_method("add_weapon"):
		body.add_weapon(weapon_def())
		queue_free()
