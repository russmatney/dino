extends Node
class_name DinoRecords

## Game record crud ###############################################3

class GameRecord:
	extends Object

	var game_entity: DinoGameEntity
	# var player_entities: Array[DinoPlayerEntity] = [] # typed arrays are PITA to work with
	var player_entities = []
	var completed_at

	var level_opts: Dictionary

	func _init(game_ent: DinoGameEntity, _level_opts={}):
		game_entity = game_ent
		level_opts = _level_opts

	func to_pretty(a, b, c):
		return Log.to_pretty([game_entity, completed_at, player_entities], a, b, c)

static func mk_record(opts):
	var rec = GameRecord.new(opts.get("game_entity"))
	rec.completed_at = opts.get("completed_at")
	rec.player_entities = opts.get("player_entities")
	return rec

static func mk_records(optses):
	var recs = []
	for opts in optses:
		recs.append(mk_record(opts))
	return recs

var current_records = []
var current_record

func start_game(opts):
	current_record = GameRecord.new(opts.get("game_entity"))

	# add player
	var p_ent = opts.get("player_entity")
	if p_ent:
		current_record.player_entities.append(p_ent)

	current_records.append(current_record)

func complete_game(opts):
	current_record["completed_at"] = Time.get_datetime_dict_from_system()

	var p_ent = opts.get("player_entity")
	if p_ent and p_ent not in current_record.player_entities:
		current_record.player_entities.append(p_ent)
