extends GutTest

var hud_scene = load("res://src/dotHop/hud/HUD.tscn")
var hud

func before_all():
	var hud_dbl = double(hud_scene)
	DotHop.hud_scene = hud_dbl

func test_hud_receives_updates():
	watch_signals(Hotel)

	var game = load("res://src/dotHop/DotHopGame.tscn").instantiate()
	add_child(game)
	await Hood.hud_ready

	assert_signal_emitted(Hotel, "entry_updated")

	Debug.pr("hud ready?", Hood.hud.is_node_ready())

	assert_called(Hood.hud, "_on_entry_updated")
	# assert_called(Hood.hud, "_on_entry_updated", [{}])
