extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

#######################################################################33
# hit, kill

var dead = false


func hit():
	kill()


func kill():
	dead = true
	anim.animation = "death"
	await get_tree().create_timer(0.4).timeout
	emit_drops()
	queue_free()


#######################################################################33
# drops

@export var drop_scene: PackedScene
var fallback_drop_scenes = [preload("res://src/dungeonCrawler/items/Coin.tscn")]


func emit_drop(scene):
	var drop = scene.instantiate()
	drop.position = transform.origin
	Navi.current_scene.call_deferred("add_child", drop)

	# eh? particle physics?
	# drop.apply_impulse(impulse_dir * arrow_impulse, Vector2.ZERO)


func emit_drops():
	if drop_scene:
		emit_drop(drop_scene)
	else:
		# todo choose one, more than one, randomly
		if fallback_drop_scenes.size():
			var drop = fallback_drop_scenes[0]
			emit_drop(drop)


#######################################################################33
# physics process

var dir = Vector2.LEFT
var speed = 50
var dead_spin_speed = 800
var velocity = dir * speed


func _physics_process(delta):
	if not dead:
		var collision_info = move_and_collide(velocity * delta)
		if collision_info:
			velocity = velocity.bounce(collision_info.normal)
	else:
		rotation_degrees += dead_spin_speed * delta
