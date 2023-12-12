@tool
extends SSPlayer

## ready ##################################################################

func _ready():
	if not Engine.is_editor_hint():
		Cam.request_camera({player=self})
		# powerups = SSData.all_powerups

		died.connect(_on_player_death)

	super._ready()

func _on_transit(state):
	if state in ["Fall", "Run"]:
		stamp()

## death anim, jumbotron #######################################################

func _on_player_death():
	stamp({ttl=0}) # perma stamp

	# is this fade conflicting with the SS dying/dead anims/tweens?
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.3, 1).set_trans(Tween.TRANS_CUBIC)
	t.parallel().tween_property(light, "scale", Vector2.ZERO, 1).set_trans(Tween.TRANS_CUBIC)

	# possibly we could share/re-use this, but meh, it'll probably need specific text
	Jumbotron.jumbo_notif({header="You died", body="Sorry about it!",
		action="close", action_label_text="Respawn",
		on_close=P.respawn_player.bind({
			setup=func(p):
			p.is_dead = false
			Hotel.check_in(p, {health=p.initial_health})})})
