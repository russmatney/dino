extends Area2D

## vars ###############################################

@export var drops: Array[DropData]

@onready var anim = $AnimatedSprite2D
@onready var action_area = $ActionArea

## ready ###############################################

func _ready():
	anim.play("idle")
	action_area.register_actions(actions, {source=self})

## actions ###############################################

var actions = [
	Action.mk({label="Treasure Chest", fn=open, show_on_actor=true,
		source_can_execute=func(): return len(drops) > 0}),
	]

## open ###############################################

func open(_actor=null):
	if not drops.is_empty():
		for drop in drops:
			DropData.add_drop(self, drop)
	drops = []
