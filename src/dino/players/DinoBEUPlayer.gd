@tool
extends BEUPlayer

func _ready():
	if not Engine.is_editor_hint():
		var level = U.find_level_root(self)
		if level.has_method("_on_player_death"):
			died.connect(level._on_player_death.bind(self))

	super._ready()

func _on_player_death():
	# stamp({ttl=0}) # perma stamp

	# TODO idea: show multiple stamps between dying and dead

	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.3, 1).set_trans(Tween.TRANS_CUBIC)
