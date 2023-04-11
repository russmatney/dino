extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

func _ready():
	velocity = dir * speed

func update_facing():
	if velocity.x >= 0:
		anim.flip_h = true
	else:
		anim.flip_h = false

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
	drop.global_position = get_global_position()
	Navi.current_scene.add_child.call_deferred(drop)

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


func _physics_process(delta):
	if not dead:
		move_and_slide()
		var coll = get_last_slide_collision()
		if coll:
			velocity = velocity.bounce(coll.get_normal())
			update_facing()
	else:
		rotation_degrees += dead_spin_speed * delta
