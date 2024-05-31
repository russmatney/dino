extends Object
class_name DinoWeaponsData

static func all_weapon_entities():
	return Pandora.get_all_entities(Pandora.get_category(PandoraCategories.DINOWEAPON))\
		.filter(func(ent): return not ent.is_disabled())

static func sidescroller_weapon_entities():
	return all_weapon_entities().filter(func(ent):
		return ent.get_sidescroller_scene())

static func topdown_weapon_entities():
	return all_weapon_entities().filter(func(ent):
		return ent.get_topdown_scene())

## weapons crud ################################################

static func weapon_with_id(weapons, id):
	for w in weapons:
		if w.entity.get_entity_id() == id:
			return w
