extends GdUnitTestSuite
class_name GunnerTest

func test_gunner_game_entity():
	var ent = Pandora.get_entity(DinoGameEntityIds.GUNNER)

	assert_that(ent).is_not_null()
	assert_that(ent.get_first_level_scene()).is_not_null()


signal key_release

func test_gunner_dino_level_completion():
	var game_ent = Pandora.get_entity(DinoGameEntityIds.GUNNER)
	var sc = game_ent.get_first_level_scene()
	P.setup_player(game_ent)
	var player_ent = Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER)
	P.set_player_entity(player_ent)

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
	Trolley.sim_move(Vector2.RIGHT, 0.8, key_release)
	await key_release
	# shoot target
	Trolley.attack()

	# TODO restore this assertion!!
	# await assert_signal(level).wait_until(500).is_emitted("level_complete")
