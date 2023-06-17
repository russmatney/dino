extends Node2D
class_name Pickup

@onready var anim = $AnimatedSprite2D
@onready var action_area = $ActionArea

var actions = [
	Action.mk({label="Pickup", fn=func(_actor): fade_out()})
	]

func _ready():
	action_area.register_actions(actions, {source=self})


func fade_out():
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.0, 1)
	t.tween_callback(self.queue_free)
