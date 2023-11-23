extends GdUnitTestSuite
class_name GunnerTest

func test_gunner_game_entity():
	var ent = Game.get_game_entity(DinoGameEntityIds.GUNNER)

	assert_that(ent).is_not_null()
	assert_that(ent.get_first_level_scene()).is_not_null()


func test_gunner_dino_level_completion():
	var ent = Game.get_game_entity(DinoGameEntityIds.GUNNER)
	var sc = ent.get_first_level_scene()
	P.set_player_scene(ent)

	var level = monitor_signals(sc.instantiate())
	level.skip_splash_intro = true
	level.skip_splash_outro = true
	level.level_opts = {room_count=1,
		contents="
name Gunner Test Rooms

============
LEGEND
============

p = Player
x = Tile
o = Target

============
ROOMS
============

name Basic

......
.p..o.
xxxxxx"}
	add_child(level)
	await assert_signal(level).is_emitted("ready")
	level.regenerate()

	await assert_signal(P).is_emitted("player_ready")
	await assert_signal(level).is_emitted("level_setup")

	# aim right
	Trolley.sim_move(Vector2.RIGHT)
	# shoot target
	Trolley.attack()

	await assert_signal(level).wait_until(500).is_emitted("level_complete")
