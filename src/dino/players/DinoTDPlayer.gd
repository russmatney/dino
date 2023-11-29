@tool
extends TDPlayer

var shrine_gems = 0

## ready ##################################################################

@export var zoom_rect_min = 100
@export var zoom_margin_min = 100

func _ready():
	if not Engine.is_editor_hint():
		Cam.request_camera({player=self, zoom_rect_min=zoom_rect_min, zoom_margin_min=zoom_margin_min})

		died.connect(_on_player_death)

		var level = U.find_level_root(self)
		if level.has_method("_on_player_death"):
			died.connect(level._on_player_death.bind(self))

	# TODO weapon system!
	has_boomerang = true

	super._ready()

func _on_player_death():
	stamp({ttl=0}) # perma stamp

	var t = create_tween()
	t.tween_property(self, "modulate:a", 0.3, 1).set_trans(Tween.TRANS_CUBIC)
	# if light:
	# 	t.parallel().tween_property(light, "scale", Vector2.ZERO, 1).set_trans(Tween.TRANS_CUBIC)

## death #######################################################

func on_pit_entered():
	machine.transit("Fall")

	await get_tree().create_timer(1.0).timeout
	P.respawn_player()

## shrine_gems #######################################################

func has_shrine_gems(n):
	return shrine_gems >= n

func add_shrine_gem():
	shrine_gems += 1
