extends BEUBody

@onready var palettes = [null,
	preload("res://src/games/superElevatorLevel/enemies/BossAlt1.tres"),
	preload("res://src/games/superElevatorLevel/enemies/BossAlt2.tres"),
	]

var names = ["Bossifer", "Bosstodon", "His Royal Bossyness"]

## ready ###########################################################

func _ready():
	super._ready()

	var pal = U.rand_of(palettes)

	if pal != null:
		anim.material = pal

	if display_name in ["", null]:
		display_name = U.rand_of(names)
		Hotel.check_in(self)
