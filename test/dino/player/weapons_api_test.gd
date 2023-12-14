extends GdUnitTestSuite
class_name DinoWeaponsTest

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


func test_add_weapon_ss():
	var p_ent = P.all_player_entities()[0]
	var p = auto_free(p_ent.get_sidescroller_scene().instantiate())
	var w_ent = DinoWeaponsData.all_weapon_entities()[0]

	# adding a weapon
	p.add_weapon_entity(w_ent.get_entity_id())

	# implies the active weapon
	var w = p.active_weapon()
	assert_that(w.entity).is_equal(w_ent)
