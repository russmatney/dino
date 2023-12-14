extends Object
class_name DinoWeaponsData

static func all_weapon_entities():
	var ent = Pandora.get_entity(DinoWeaponEntityIds.BOOMERANG)
	return Pandora.get_all_entities(Pandora.get_category(ent.get_category_id()))

static func sidescroller_weapon_entities():
	return all_weapon_entities().filter(func(ent):
		return ent.get_sidescroller_scene())

static func topdown_weapon_entities():
	return all_weapon_entities().filter(func(ent):
		return ent.get_topdown_scene())
