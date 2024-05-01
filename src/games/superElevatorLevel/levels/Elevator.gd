extends SELLevel

var waves = [
	{goon_count=1, floor_count=3},
	{goon_count=3, floor_count=8, screenshake=0.6, animation_loops=4},
	{goon_count=4, floor_count=12, screenshake=0.5, animation_loops=4, animation_time=1.0},
	]

func _ready():
	super._ready()

	Debug.notif("The Elevator")

var floor_num = 1

func spawn_next_wave(wave):
	floor_num += wave.get("floor_count", 1)
	Debug.notif(str("Floor ", floor_num))

	var tween = create_tween()
	tween.set_loops(wave.get("animation_loops", 3))
	tween.tween_callback(Sounds.play.bind(Sounds.S.fall))
	tween.tween_callback(Sounds.play.bind(Sounds.S.jet_init))
	tween.tween_callback(Juice.screenshake.bind(wave.get("screenshake", 0.4))).set_delay(0.5)

	await get_tree().create_timer(wave.get("animation_time", 2.0)).timeout

	super.spawn_next_wave(wave)
