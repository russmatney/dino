extends RigidBody2D

export(float) var ttl = 3.0

onready var anim = $AnimatedSprite
onready var remove_timer = $RemoveTimer

### ready #####################################################################


func _ready():
	remove_timer.start(ttl)


### physics_process #####################################################################

# func _physics_process(_delta):
#   pass

### kill #####################################################################


func kill():
	# TODO body destroyed animation/shrink/something?
	# TODO still valid?
	queue_free()


func _on_RemoveTimer_timeout():
	kill()


### collisions #####################################################################


func _on_Area2D_body_entered(body: Node):
	if body != self:
		if body.is_in_group("enemies") or body.get("owner") and body.owner.is_in_group("enemies"):
			if body.has_method("hit"):
				body.hit()
			elif body.get("owner") and body.owner.has_method("hit"):
				body.owner.hit()
			kill()
		elif body is TileMap:
			kill()
