extends Node2D
class_name Pickup

@onready var anim = $AnimatedSprite2D
@onready var action_area = $ActionArea

var picked_up = false

var actions = [
	Action.mk({label="Pickup", fn=func(_actor): fade_out(), source_can_execute=func(): return picked_up == false})
	]

func _ready():
	action_area.register_actions(actions, {source=self})


func fade_out():
	picked_up = true
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.0, 1)
	t.tween_callback(self.queue_free)
