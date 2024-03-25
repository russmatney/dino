@tool
extends Node2D
class_name DinoLevel

## static

static func create_level(def: LevelDef):
	var l = DinoLevel.new()
	l.level_def = def
	return l

## exports/triggers ######################################################

@export var game_type: DinoData.GameType
@export var level_def: LevelDef

@export var _regen_with_level_def: bool = false :
	set(v):
		if not Engine.is_editor_hint():
			return
		if level_def:
			regen_with_def(level_def)

func regen_with_def(def):
	if not def:
		return

	# ensure level gen node
	level_gen.set_script(def.get_level_gen_script())

	# set level_opts
	level_opts.tile_size = def.get_base_square_size()
	# could instead read and pass as 'contents'
	level_opts.room_defs_path = def.get_def_path()
	# .... maybe.
	level_opts.label_to_tilemap = {"Tile": {scene=def.get_tiles_scene()}}

	regenerate()

## vars ######################################################

@onready var level_gen: BrickLevelGen = $LevelGen
var level_opts: Dictionary = {}
signal level_complete
signal level_setup

var skip_splash_intro = false
var skip_splash_outro = false

var hud_scene = preload("res://src/dino/hud/DinoHUD.tscn")
var hud
var time: float = 0
var time_int = 0

## enter_tree ###############################################

func to_printable():
	if level_def != null:
		return {game_type=game_type, level_def=level_def.get_display_name(), level_opts=level_opts}
	return {game_type=game_type, level_opts=level_opts}

## enter_tree ###############################################

func _enter_tree():
	var gen = get_node_or_null("LevelGen")
	if gen == null:
		gen = BrickLevelGen.new()
		gen.ready.connect(func(): gen.set_owner(self))
		gen.name = "LevelGen"

		add_child(gen)

	if level_def and level_def.get_level_gen_script():
		gen.set_script(level_def.get_level_gen_script())

## ready ######################################################

func _ready():
	if Engine.is_editor_hint():
		return

	if level_gen == null:
		Log.error("DinoLevel missing expected 'LevelGen' node")

	Log.pr("DinoLevel ready: ", self)
	hud = hud_scene.instantiate()
	add_child.call_deferred(hud)

	# call setup_level every time we get new nodes
	# could use a better name for :gen/finished-hook
	level_gen.nodes_transferred.connect(setup_level)

	if Dino.is_debug_mode():
		Log.pr("debug mode: regenerating")
		if game_type == null:
			game_type = DinoData.GameType.SideScroller
		Dino.ensure_player_setup({game_type=game_type,
			entity_id=DinoPlayerEntityIds.HATBOTPLAYER,
		})
		regenerate()

## process ######################################################

func _process(delta):
	if Engine.is_editor_hint():
		return

	time += delta
	if time > time_int:
		time_int = int(time) + 1
		hud.update_time(time_int)

## regenerate ###################################################3

# regenerate the level with whatever passed opts
# presumably invokes the nodes_transferred signal when it's done
func regenerate(opts=null):
	if opts == null and level_opts != null:
		opts = level_opts

	if level_def:
		opts.merge({
			tile_size=level_def.get_base_square_size(),
			# could instead read in LevelDef/as resource, and pass as 'contents'
			room_defs_path = level_def.get_def_path(),
			# .... maybe.
			label_to_tilemap = {"Tile": {scene=level_def.get_tiles_scene()}},
			})

	level_gen.generate(opts)
	# i _think_ this helps support regen from the pause menu
	level_opts = opts

	if not Engine.is_editor_hint():
		hud.set_level_opts(opts)

## add_quests ###################################################3

func add_quests():
	var ents = $Entities.get_children()
	var qs = DinoLevelGenData.quests_for_entities(ents)
	for q in qs:
		add_child(q)

## setup_level ###################################################3

# setup any signals and initial data
func setup_level():
	add_quests()

	U._connect(Q.all_quests_complete, on_quests_complete, ConnectFlags.CONNECT_ONE_SHOT)
	U._connect(Q.quest_failed, on_quest_failed, ConnectFlags.CONNECT_ONE_SHOT)
	Q.setup_quests()
	Dino.spawn_player()
	level_setup.emit()

	if not skip_splash_intro:
		await Jumbotron.jumbo_notif(get_splash_jumbo_opts())

## ui opts ###################################################3

func get_splash_jumbo_opts():
	return {
		header="Welcome to %s" % self.name,
		body=U.rand_of(["Good luck, padawan", "I give you 1 in 10 odds"])
		}

func get_exit_jumbo_opts():
	return {
		header="%s complete!" % self.name,
		body=U.rand_of(["Seriously, wow.", "OMG YOU DID IT", "Yo! Way to go!"])
		}

## quest reactions ###################################################3

func on_quests_complete():
	Hood.notif("DinoLevel Level Complete", self.name)

	if not skip_splash_outro:
		await Jumbotron.jumbo_notif(get_exit_jumbo_opts())

	Q.drop_quests()
	level_complete.emit()

func on_quest_failed():
	Hood.notif("DinoLevel Restarting", self.name)
	Q.drop_quests()
	regenerate()

## add_child_to_level ###################################################3

func add_child_to_level(_node, child):
	$Entities.add_child(child)

## player reactions ##################################################3

func _on_player_death(_p):
	# TODO show player lifespan/stats/progress? (hopefully not per player-type! should be in game-mode/dino-level)
	# inspiration: Spelunky, Ape Out
	# ideas: framing the dead player, splashy letters in sync with drums

	# possibly we could share/re-use this, but meh, it'll probably need specific text
	Jumbotron.jumbo_notif({header="You died", body="Sorry about it!",
		action="close", action_label_text="Respawn",
		on_close=Navi.nav_to_main_menu()})
