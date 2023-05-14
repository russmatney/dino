extends BEUBody

# TODO hitstop on punches?

@onready var palettes = [null,
	preload("res://src/superElevatorLevel/enemies/BossAlt1.tres"),
	preload("res://src/superElevatorLevel/enemies/BossAlt2.tres"),
	]

var names = ["Bossifer", "Bosstodon", "His Royal Bossyness"]

## ready ###########################################################

func _ready():
	super._ready()

	var pal = Util.rand_of(palettes)

	if pal != null:
		anim.material = pal

	if display_name in ["", null]:
		display_name = Util.rand_of(names)
		Hotel.check_in(self)
