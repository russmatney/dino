extends GdUnitTestSuite
class_name DinoWeaponsTest

func before():
	# TODO move to global before
	DJ.mute_all()

func test_weapons_data():
	var ws = DinoWeaponsData.all_weapon_entities()

	assert_int(len(ws)).is_greater(1)
	var w_ids = ws.map(func(e): return e.get_entity_id())
	assert_array(w_ids).contains([
		DinoWeaponEntityIds.BOOMERANG,
		DinoWeaponEntityIds.BOW,
		DinoWeaponEntityIds.GUN,
		DinoWeaponEntityIds.SWORD
		])

	ws = DinoWeaponsData.topdown_weapon_entities()
	assert_int(len(ws)).is_greater(0)
	w_ids = ws.map(func(e): return e.get_entity_id())
	assert_array(w_ids).contains([
		DinoWeaponEntityIds.BOOMERANG,
		])

	ws = DinoWeaponsData.sidescroller_weapon_entities()
	assert_int(len(ws)).is_greater(3)
	w_ids = ws.map(func(e): return e.get_entity_id())
	assert_array(w_ids).contains([
		DinoWeaponEntityIds.BOOMERANG,
		DinoWeaponEntityIds.BOW,
		DinoWeaponEntityIds.GUN,
		DinoWeaponEntityIds.SWORD
		])


func test_add_weapon_ss():
	var p_ent = DinoPlayerEntity.all_entities()[0]
	var p = auto_free(p_ent.get_sidescroller_scene().instantiate())
	var w_ent = DinoWeaponsData.sidescroller_weapon_entities()[0]

	# adding a weapon
	p.add_weapon(w_ent.get_entity_id())

	# implies the active weapon
	var w = p.active_weapon()
	assert_that(w.entity).is_equal(w_ent)
	assert_that(w.entity.get_sidescroller_scene().resource_path)\
		.is_equal(w.scene_file_path)


func test_add_weapon_td():
	var p_ent = DinoPlayerEntity.all_entities()[0]
	var p = auto_free(p_ent.get_topdown_scene().instantiate())
	var w_ent = DinoWeaponsData.topdown_weapon_entities()[0]

	# adding a weapon
	p.add_weapon(w_ent.get_entity_id())

	# implies the active weapon
	var w = p.active_weapon()
	assert_that(w.entity).is_equal(w_ent)
	assert_that(w.entity.get_topdown_scene().resource_path)\
		.is_equal(w.scene_file_path)


func test_change_weapon():
	var p_ent = DinoPlayerEntity.all_entities()[0]
	var p = auto_free(p_ent.get_sidescroller_scene().instantiate())
	var w_ents = DinoWeaponsData.sidescroller_weapon_entities()
	var w

	# add the weapons
	p.add_weapon(w_ents[0].get_entity_id())
	p.add_weapon(w_ents[1].get_entity_id())
	p.add_weapon(w_ents[2].get_entity_id())

	for i in range(3):
		p.activate_weapon(w_ents[i])
		w = p.active_weapon()
		assert_that(w.entity).is_equal(w_ents[i])

func test_cycle_weapon():
	var p_ent = DinoPlayerEntity.all_entities()[0]
	var p = auto_free(p_ent.get_sidescroller_scene().instantiate())
	var w_ents = DinoWeaponsData.sidescroller_weapon_entities()

	# add the weapons
	p.add_weapon(w_ents[0].get_entity_id())
	p.add_weapon(w_ents[1].get_entity_id())
	p.add_weapon(w_ents[2].get_entity_id())

	var w_a = p.active_weapon()
	assert_that(w_a).is_equal(p.active_weapon())

	# cycle once, assert change
	p.cycle_weapon()
	var w_b = p.active_weapon()
	assert_that(w_a).is_not_equal(w_b)

	# cycle twice, assert not a or b
	p.cycle_weapon()
	var w_c = p.active_weapon()
	assert_that(w_b).is_not_equal(w_a)
	assert_that(w_b).is_not_equal(w_c)

	# cycle a third time, should be back at a
	p.cycle_weapon()
	assert_that(w_a).is_equal(p.active_weapon())
