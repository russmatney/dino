extends SELLevel

func _ready():
	super._ready()
	Debug.notif("The Boss's Office")


var waves = [
	{goon_count=4},
	{goon_count=2, boss_count=1},
	{goon_count=2, boss_count=2},
	{goon_count=1, boss_count=3, final=true},
	]

func spawn_next_wave(wave):
	if wave.get("final"):
		Debug.notif("Final Wave!")

	var tween = create_tween()
	tween.set_loops(wave.get("animation_loops", 1))
	tween.tween_callback(Sounds.play.bind(Sounds.S.step))
	tween.tween_callback(Cam.screenshake.bind(wave.get("screenshake", 0.5)))

	await get_tree().create_timer(wave.get("animation_time", 2.0)).timeout

	super.spawn_next_wave(wave)
