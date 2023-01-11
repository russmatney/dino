extends AnimatedSprite

var ttl = 0.5

func _ready():
	modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.2)
	tween.tween_property(self, "modulate:a", 0.0, 0.3)

func _process(delta):
	ttl -= delta
	if ttl <= 0:
		queue_free()
