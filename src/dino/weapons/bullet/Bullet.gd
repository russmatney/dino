extends RigidBody2D

@onready var pop = $Pop
@onready var anim = $AnimatedSprite2D

var ttl = 3
var dying = false


func _process(delta):
	ttl -= delta
	if ttl <= 0:
		kill()


signal bullet_dying(bullet)


func kill():
	bullet_dying.emit(self)
	# no need to run more than once (if we contact multiple objs)
	if not dying:
		dying = true
		Juice.screenshake(0.1)
		Sounds.play(Sounds.S.bullet_pop)
		anim.set_visible(false)
		pop.set_visible(true)

		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(self):
			queue_free()


func _on_Bullet_body_entered(body: Node):
	if body.is_in_group("darktile"):
		body.hit(global_position)
	if body.has_method("take_hit") and not body.is_dead:
		body.take_hit({body=self, damage=1})

	if body.has_method("gather_pickup"):
		var player = Dino.current_player_node()
		if player:
			body.gather_pickup(player)
	if body.get_parent().has_method("gather_pickup"):
		var player = Dino.current_player_node()
		if player:
			body.get_parent().gather_pickup(player)

	kill()
