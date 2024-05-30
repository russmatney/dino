extends Area2D

## vars

@onready var anim = $AnimatedSprite2D
@onready var destroyed_label_scene = preload("res://src/components/DestroyedLabel.tscn")

signal destroyed(target)
var is_dead = false

## ready

func _ready():
	anim.animation_finished.connect(_animation_finished)
	OffscreenIndicator.add(self, {label="Target"})
	area_entered.connect(_on_body_entered)
	body_entered.connect(_on_body_entered)

## anim finished

func _animation_finished():
	if anim.animation == "pop":
		queue_free()

## kill

func kill():
	is_dead = true
	# TODO aggregate dupe/same-id notifs
	# Debug.notif("Target Destroyed")
	Sounds.play(Sounds.S.target_kill)
	anim.play("pop")
	Juice.freezeframe({name="target-destroyed", time_scale=0.05, duration=0.4})
	destroyed.emit(self)

	var lbl = destroyed_label_scene.instantiate()
	lbl.set_position(get_global_position())
	U.add_child_to_level(self, lbl)

## body entered

# anything allowed via the collision mask can destroy this
func _on_body_entered(body: Node2D):
	if body.is_in_group("bullet"):
		if body.has_method("kill"):
			body.kill()
	kill()
