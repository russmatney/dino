@tool
extends SSPlayer

## ready ##################################################################

var hud = preload("res://src/hatbot/hud/HUD.tscn")

func _ready():
	if not Engine.is_editor_hint():
		Cam.ensure_camera({player=self,
			# zoom_rect_min=200,
			# zoom_margin_min=120,
			})
		Hood.ensure_hud(hud)

		if not Game.is_managed:
			powerups = SS.all_powerups

	super._ready()

	if not Engine.is_editor_hint():
		died.connect(_on_player_death)

func _on_transit(state):
	if state in ["Fall", "Run"]:
		stamp()


## movement ##########################################################################

# TODO re-incorporate guided movement, as a new state or variable
var move_target
var move_target_threshold = 10

func get_move_vector():
	if move_target != null:
		var towards_target = move_target - position
		var dist = towards_target.length()
		if dist >= move_target_threshold:
			return towards_target.normalized()
		else:
			return Vector2.ZERO
		# note, no movement can occur until move_target is unset
	else:
		return Trolley.move_vector()

# TODO perhaps a state for this
func move_to_target(target_position):
	move_target = target_position

func clear_move_target():
	move_target = null


## death anim, jumbotron #######################################################

func _on_player_death():
	stamp({ttl=0}) # perma stamp

	# is this fade conflicting with the SS dying/dead anims/tweens?
	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.3, 1).set_trans(Tween.TRANS_CUBIC)
	t.parallel().tween_property(light, "scale", Vector2.ZERO, 1).set_trans(Tween.TRANS_CUBIC)

	# possibly we could share/re-use this, but meh, it'll probably need specific text
	Quest.jumbo_notif({header="You died", body="Sorry about it!",
		action="close", action_label_text="Respawn",
		on_close=Game.respawn_player.bind({
			setup_fn=func(p): Hotel.check_in(p, {health=p.initial_health})})})
