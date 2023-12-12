@tool
extends BEUPlayer

@onready var palettes = [null,
	preload("res://src/superElevatorLevel/players/PlayerOneAlt1.tres"),
	preload("res://src/superElevatorLevel/players/PlayerOneAlt2.tres"),
	]

## ready ###########################################################

func _ready():
	super._ready()

	if not Engine.is_editor_hint():
		# right now this swaps after you die
		var pal = U.rand_of(palettes)

		if pal != null:
			anim.material = pal
