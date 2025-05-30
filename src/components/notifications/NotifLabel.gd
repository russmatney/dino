@tool
extends Label

## vars ##############################################################

var default_ttl = 3.0
var ttl
var tween

## ready ##############################################################

func _ready():
	if not ttl:
		ttl = default_ttl

	if not Engine.is_editor_hint():
		kill_in_ttl.call_deferred()

## kill ##############################################################

func kill_in_ttl():
	if not is_inside_tree():
		return
	var time_to_kill = ttl
	if not time_to_kill:
		time_to_kill = 3.0

	tween = create_tween()
	if not tween:
		return # prevent weird crash
	tween.tween_property(self, "modulate:a", 0.0, 2.0).set_delay(time_to_kill)
	tween.tween_callback(queue_free)

## reset ##############################################################

func reset_ttl(t=null):
	if t != null:
		ttl = t
	if tween:
		tween.kill()
	modulate.a = 1.0
	kill_in_ttl.call_deferred()

## re-emph ##############################################################

func reemphasize():
	if not is_inside_tree():
		return
	var t = create_tween()
	if not t:
		return # prevent weird crash
	t.tween_property(self, "scale", Vector2.ONE*1.2, 0.1)
	t.tween_property(self, "scale", Vector2.ONE, 0.1)
