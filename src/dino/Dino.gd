@tool
extends Node
class_name DinoData

## static data/helpers ########################################################

enum GameType {SideScroller, TopDown, BeatEmUp}

static func to_game_type(s: String) -> GameType:
	match s.to_lower():
		"sidescroller", "ss": return GameType.SideScroller
		"topdown", "td": return GameType.TopDown
		"beatemup", "beu": return GameType.BeatEmUp
		_:
			Log.warn("no match in to_game_type, returning fallback", s)
			return GameType.SideScroller

## vars ##########################################################

var player_set = PlayerSet.new()
var game_mode: DinoModeEntity

## current game ##########################################################

func get_game_mode():
	if game_mode:
		return game_mode
	return Pandora.get_entity(ModeIds.DEBUG)

func is_debug_mode():
	return get_game_mode().get_entity_id() == ModeIds.DEBUG

## launch/start game ##########################################################

func launch(mode: DinoModeEntity, opts={}):
	game_mode = mode
	# TODO menu should support a mode with or without a menu
	if mode.get_menu() != null:
		mode.nav_to_menu()
		return

	restart_game(opts)

func restart_game(opts=null):
	var mode = get_game_mode()
	Log.pr("Starting game mode", mode.get_display_name())
	mode.start(opts)

## player(s) ########################################################

func setup_player(opts):
	# TODO do we want a unique id for these players?
	# maybe create a unique instance with one life here
	var type = opts.get("type", GameType.SideScroller)
	var p_ent = opts.get("entity")
	var p_ent_id = opts.get("entity_id")
	var player_entity
	if p_ent:
		player_entity = p_ent
	elif p_ent_id:
		player_entity = Pandora.get_entity(p_ent_id)

	# should create a 'template' to spawn players from
	player_set.setup_player({player_entity=player_entity, type=type})

func spawn_player():
	pass

func respawn_player(opts={}):
	# TODO support opts.player passed here for topdown pit use-case
	player_set.respawn_player(opts)
	# var p = players.filter(func(p): return p.is_focused)
