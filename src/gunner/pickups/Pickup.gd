extends Node2D

export(String, "jetpack", "hat", "body") var type = "jetpack"

func _ready():
	$AnimatedSprite.animation = type
	Respawner.register_respawn(self)

func kill():
	GunnerSounds.play_sound("pickup")
	# TODO animate
	queue_free()

func _on_Area2D_body_entered(body:Node):
	if body.is_in_group("player"):
		if body.has_method("collect_pickup"):
			if type:
				body.collect_pickup(type)
			kill()


onready var offscreen_indicator = $OffscreenIndicator

func _process(_delta):
	# if target offscreen and player close enough/line-of-sight
	if not on_screen:
		offscreen_indicator.activate(self)
	else:
		offscreen_indicator.deactivate()

var on_screen = false
func _on_VisibilityNotifier2D_screen_entered():
	on_screen = true

func _on_VisibilityNotifier2D_screen_exited():
	on_screen = false
