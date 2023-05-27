@tool
extends BEUPlayer

@onready var palettes = [null,
	preload("res://src/superElevatorLevel/players/PlayerOneAlt1.tres"),
	preload("res://src/superElevatorLevel/players/PlayerOneAlt2.tres"),
	]

var hud = preload("res://src/superElevatorLevel/hud/HUD.tscn")

## ready ###########################################################

func _ready():
	if not Engine.is_editor_hint():
		Hood.ensure_hud(hud)
	super._ready()

	if not Engine.is_editor_hint():
		# TODO choose a pallette
		# right now this swaps after you die
		var pal = Util.rand_of(palettes)

		if pal != null:
			anim.material = pal
