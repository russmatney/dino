extends RichTextLabel

var ttl = 1.5


func _ready():
	var tween = create_tween()
	tween.tween_callback(kill).set_delay(ttl)


func kill():
	queue_free()
