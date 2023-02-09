extends RichTextLabel

var default_ttl = 2
var ttl


func _ready():
	if not ttl:
		ttl = default_ttl

	call_deferred("kill_in_ttl")


func kill_in_ttl():
	var time_to_kill = ttl
	if not time_to_kill:
		time_to_kill = 2

	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.5).set_delay(time_to_kill)
	tween.tween_callback(Callable(self,"queue_free"))
