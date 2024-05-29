extends Quest
class_name QuestFeedTheVoid

var has_cooking_pot = false
var has_void = false
var has_orb_sources = false

func has_required_nodes(nodes: Array[Node]):
	for n in nodes:
		if n.is_in_group("cooking_pots"):
			has_cooking_pot = true
			break

		if n.is_in_group("voids"):
			has_void = true
			break

		if n.is_in_group("orb_sources"):
			has_orb_sources = true
			break

	return has_cooking_pot and has_void and has_orb_sources

func has_required_entities(ents):
	var relevant_ents = []
	for e in ents:
		var e_id = e.get_entity_id()
		if e_id == DinoEntityIds.VOID:
			relevant_ents.append(e)

	# TODO ensure cooking pot/orb-sources?
	# at least one void
	return len(relevant_ents) > 0

func setup_with_entities(ents):
	var relevant_ents = []
	for e in ents:
		var e_id = e.get_entity_id()
		if e_id == DinoEntityIds.VOID:
			relevant_ents.append(e)

	manual_total = len(relevant_ents)

func _init():
	label = "Feed The Voids"
	xs_group = "voids"
	x_update_signal = func(x): return x.void_satisfied
	is_remaining = func(x): return not x.complete
	entity_ids = [
		DinoEntityIds.VOID,
		DinoEntityIds.COOKINGPOT,
		EnemyIds.BLOB,
		]
