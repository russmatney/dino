extends Area2D

## vars

@onready var anim = $AnimatedSprite2D
@onready var destroyed_label_scene = preload("res://src/gunner/targets/DestroyedLabel.tscn")

signal destroyed
var is_dead = false

## ready

func _ready():
	anim.animation_finished.connect(_animation_finished)
	Cam.add_offscreen_indicator(self)
	# TODO how to work with animations and positions after regen bug
	# U.animate(self)
	# U.animate_rotate(self)
	body_entered.connect(_on_body_entered)

## anim finished

func _animation_finished():
	if anim.animation == "pop":
		queue_free()

## kill

func kill():
	is_dead = true
	# TODO aggregate dupe/same-id notifs
	# Hood.notif("Target Destroyed")
	DJZ.play(DJZ.S.target_kill)
	anim.play("pop")
	Cam.freezeframe("target-destroyed", 0.05, 0.4)
	destroyed.emit()

	var lbl = destroyed_label_scene.instantiate()
	lbl.set_position(get_global_position())
	U.add_child_to_level(self, lbl)

## body entered

func _on_body_entered(body: Node2D):
	if body.is_in_group("bullet"):
		if body.has_method("kill"):
			body.kill()
		kill()
	if body.is_in_group("weapons"):
		kill()
