extends Area2D

enum key_type {SMALL, BOSS}

export(key_type) var type = key_type.SMALL

func item_def():
	return {"item": "key", "key_type": type}

func _on_Key_body_entered(body:Node):
	if body.has_method("add_item"):
		body.add_item(item_def())
		queue_free()
