extends RigidBody2D

# var ttl = 3
var dying = false

@onready var anim = $AnimatedSprite2D
@onready var fb_hit_box = $FireBackHitBox

## ready ####################################################

func _ready():
	body_entered.connect(_on_body_entered)
	fb_hit_box.body_entered.connect(_on_fb_hitbox_body_entered)

	fb_hit_box.monitoring = false

## process ####################################################

# func _process(delta):
# 	ttl -= delta
# 	if ttl <= 0:
# 		kill()

## fire ####################################################

var og_impulse
var og_rotation

func fire(impulse, rot):
	og_impulse = impulse
	og_rotation = rot

	rotation = rot
	apply_central_impulse(impulse)

## fire_back ####################################################

var firing_back

func fire_back():
	firing_back = true

	anim.flip_v = true
	apply_central_impulse(-3*og_impulse)

	fb_hit_box.monitoring = true

	# move to layer 3 (player projectiles) so we destroy enemy projectiles
	set_collision_layer_value(3, true)
	set_collision_layer_value(5, false)

## kill ####################################################

signal bullet_dying(bullet)

func kill():
	if not dying:
		dying = true
		Cam.screenshake(0.1)
		DJZ.play(DJZ.S.fall)
		bullet_dying.emit(self)
		anim.play("pop")

		await get_tree().create_timer(0.2).timeout
		if is_instance_valid(self):
			queue_free()

## collision ####################################################

signal hit()

func _on_body_entered(body: Node):
	if dying or firing_back:
		return

	_on_hit(body)

func _on_fb_hitbox_body_entered(body: Node):
	if dying or not firing_back:
		return

	_on_hit(body)

func _on_hit(body):
	kill()

	if body.has_method("take_hit"):
		body.take_hit({body=self})
		hit.emit(self)