extends AnimatedSprite2D

@onready var hitbox = $HitBox

######################################################
# ready

func _ready():
	animation_finished.connect(_on_animation_finished)
	hitbox.body_entered.connect(_on_body_entered)
	hitbox.body_exited.connect(_on_body_exited)
	bodies_updated.connect(_on_bodies_updated)

func _on_animation_finished():
	if animation == "swing":
		swinging = false
		play("idle")


######################################################
# bodies

signal bodies_updated(bodies)
var bodies = []

func _on_body_entered(body: Node2D):
	bodies.append(body)
	bodies_updated.emit(bodies)

func _on_body_exited(body: Node2D):
	bodies.erase(body)
	bodies_updated.emit(bodies)

func _on_bodies_updated(bodies):
	Hood.debug_label("Sword bodies: ", bodies)


######################################################
# swing

var swinging
func swing():
	if swinging:
		# consider combos
		return

	swinging = true
	play("swing")
	MvaniaSounds.play_sound("swordswing")
	Cam.inc_trauma(0.18)

	for b in bodies:
		Hood.prn("Hit body: ", b)
