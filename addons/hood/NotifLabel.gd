@tool
extends Label

var default_ttl = 3.0
var ttl
var tween

func _ready():
	if not ttl:
		ttl = default_ttl

	if not Engine.is_editor_hint():
		kill_in_ttl.call_deferred()

func kill_in_ttl():
	var time_to_kill = ttl
	if not time_to_kill:
		time_to_kill = 3.0

	tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 2.0).set_delay(time_to_kill)
	tween.tween_callback(queue_free)

func reset_ttl(t=null):
	if t != null:
		ttl = t
	tween.kill()
	modulate.a = 1.0
	kill_in_ttl.call_deferred()
