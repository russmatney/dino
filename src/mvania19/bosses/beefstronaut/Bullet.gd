extends RigidBody2D

var ttl = 3
var dying = false

@onready var anim = $AnimatedSprite2D

#####################################################
# ready

func _ready():
	body_entered.connect(_on_body_entered)

#####################################################
# process

func _process(delta):
	ttl -= delta
	if ttl <= 0:
		kill()

#####################################################
# kill

signal bullet_dying(bullet)

func kill():
	if not dying:
		dying = true
		Cam.screenshake(0.1)
		MvaniaSounds.play_sound("bullet_hit")
		anim.set_visible(false)
		bullet_dying.emit(self)

		await get_tree().create_timer(0.2).timeout
		if is_instance_valid(self):
			queue_free()

#####################################################
# collision

signal hit_player()

func _on_body_entered(body: Node):
	kill()

	if body.is_in_group("player"):
		var dir
		if global_position.x > body.global_position.x:
			dir = Vector2.RIGHT
		else:
			dir = Vector2.LEFT
		body.take_hit({"damage": 1, "direction": dir})
		hit_player.emit()
