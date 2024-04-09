extends Quest
class_name QuestFeedTheVoid

func has_required_entities(entities: Array[Node]):
	var has_cooking_pot
	for e in entities:
		if e.is_in_group("cooking_pots"):
			has_cooking_pot = true
			break

	var has_void
	for e in entities:
		if e.is_in_group("voids"):
			has_void = true
			break

	var has_orb_sources
	for e in entities:
		if e.is_in_group("orb_sources"):
			has_orb_sources = true
			break

	return has_cooking_pot and has_void and has_orb_sources

func _init():
	label = "Feed The Voids"
	xs_group = "voids"
	x_update_signal = func(x): return x.void_satisfied
	is_remaining = func(x): return not x.complete
