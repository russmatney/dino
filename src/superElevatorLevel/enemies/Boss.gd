extends BEUBody

# TODO hitstop on punches?

@onready var palettes = [null,
	preload("res://src/superElevatorLevel/enemies/BossAlt1.tres"),
	preload("res://src/superElevatorLevel/enemies/BossAlt2.tres"),
	]

## ready ###########################################################

func _ready():
	super._ready()

	var pal = Util.rand_of(palettes)

	if pal != null:
		anim.material = pal
