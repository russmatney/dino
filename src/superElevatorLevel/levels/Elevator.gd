extends SELLevel

var waves = [
	{goon_count=1, floor_count=3},
	{goon_count=3, floor_count=8, screenshake=0.6, animation_loops=4},
	{goon_count=2, floor_count=2, animation_loops=2},
	{goon_count=4, floor_count=7, screenshake=0.5, animation_loops=4, animation_time=1.0},
	{goon_count=1, floor_count=12},
	]

func _ready():
	super._ready()

var floor_num = 1

func spawn_next_wave(wave):
	floor_num += wave.get("floor_count", 1)
	Hood.notif(str("Floor ", floor_num))

	var tween = create_tween()
	tween.set_loops(wave.get("animation_loops", 3))
	tween.tween_callback(DJZ.play.bind(DJZ.S.fall))
	tween.tween_callback(DJZ.play.bind(DJZ.S.jet_init))
	tween.tween_callback(Cam.screenshake.bind(wave.get("screenshake", 0.4))).set_delay(0.5)

	await get_tree().create_timer(wave.get("animation_time", 2.0)).timeout

	super.spawn_next_wave(wave)
