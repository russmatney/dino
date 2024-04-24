@tool
extends Node2D
class_name DinoLevel

## static

static func ensure_empty_containers(l: DinoLevel):
	if l.entities_node:
		l.entities_node.name = "EntitiesOLD"
		l.entities_node.queue_free()
	l.entities_node = Node2D.new()
	l.entities_node.ready.connect(func(): l.entities_node.set_owner(l))
	l.entities_node.name = "Entities"
	l.add_child(l.entities_node)

	if l.tilemaps_node:
		l.tilemaps_node.name = "TilemapsOLD"
		l.tilemaps_node.queue_free()
	l.tilemaps_node = Node2D.new()
	l.tilemaps_node.ready.connect(func(): l.tilemaps_node.set_owner(l))
	l.tilemaps_node.name = "Tilemaps"
	l.add_child(l.tilemaps_node)

	if l.rooms_node:
		l.rooms_node.name = "RoomsOLD"
		l.rooms_node.queue_free()
	l.rooms_node = Node2D.new()
	l.rooms_node.ready.connect(func(): l.rooms_node.set_owner(l))
	l.rooms_node.name = "Rooms"
	l.add_child(l.rooms_node)

static func create_level(def: LevelDef, opts={}):
	var l = DinoLevel.new()
	l.name = "DinoLevel"
	l.level_def = def
	l.level_opts = opts
	l.skip_splash_intro = opts.get("skip_splash_intro")

	l.level_gen = BrickLevelGen.new()
	l.level_gen.ready.connect(func(): l.level_gen.set_owner(l))
	l.level_gen.name = "LevelGen"
	l.add_child(l.level_gen)

	if def.get_level_gen_script():
		l.level_gen.set_script(def.get_level_gen_script())

	l.regenerate()

	return l

## exports/triggers ######################################################

@export var genre_type: DinoData.GenreType
@export var level_def: LevelDef

@export var regen_with_level_def: bool = false :
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
@onready var entities_node = $Entities
@onready var tilemaps_node = $Tilemaps
@onready var rooms_node = $Rooms
var level_opts: Dictionary = {}
signal level_complete

var skip_splash_intro = false
var skip_splash_outro = false

var hud_scene = preload("res://src/dino/hud/DinoHUD.tscn")
var hud
var time: float = 0
var time_int = 0

## enter_tree ###############################################

func to_printable():
	if level_def != null:
		return {genre_type=genre_type, level_def=level_def.get_display_name()}
	return {genre_type=genre_type}

## enter_tree ###############################################

func _enter_tree():
	if level_gen == null:
		var gen = get_node_or_null("LevelGen")
		if gen == null:
			gen = BrickLevelGen.new()
			gen.ready.connect(func(): gen.set_owner(self))
			gen.name = "LevelGen"

			add_child(gen)
		level_gen = gen

	if level_def and level_def.get_level_gen_script():
		if level_gen.get_script() != level_def.get_level_gen_script():
			level_gen.set_script(level_def.get_level_gen_script())

## ready ######################################################

func _ready():
	if Engine.is_editor_hint():
		return

	if level_gen == null:
		Log.error("DinoLevel missing expected 'LevelGen' node")

	Log.pr("DinoLevel ready: ", self)
	hud = hud_scene.instantiate()
	add_child.call_deferred(hud)

	# call setup_quests every time we get new nodes
	# could use a better name for :gen/finished-hook
	level_gen.nodes_transferred.connect(setup_quests)

	if Dino.is_debug_mode():
		Log.pr("debug mode: regenerating")
		if genre_type == null:
			genre_type = DinoData.GenreType.SideScroller
		Dino.ensure_player_setup({genre_type=genre_type,
			entity_id=DinoPlayerEntityIds.HATBOTPLAYER,
		})
		regenerate()

		if not Dino.current_player_node():
			Dino.spawn_player()

	if not skip_splash_intro:
		await Jumbotron.jumbo_notif(get_splash_jumbo_opts())

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
			defs_path = level_def.get_def_path(),
			# .... maybe.
			label_to_tilemap = {"Tile": {scene=level_def.get_tiles_scene()}},
			})

	DinoLevel.ensure_empty_containers(self)
	level_gen.generate(opts)

	if hud and not Engine.is_editor_hint():
		hud.set_level_opts(opts)

## setup_quests ###################################################3

func add_quests():
	var ents = entities_node.get_children()
	var qs = DinoLevelGenData.quests_for_entities(ents)
	for q in qs:
		add_child(q)

# signals and initial data
func setup_quests():
	add_quests()

	U._connect(Q.all_quests_complete, on_quests_complete, ConnectFlags.CONNECT_ONE_SHOT)
	U._connect(Q.quest_failed, on_quest_failed, ConnectFlags.CONNECT_ONE_SHOT)
	Q.setup_quests()

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
	Debug.notif("DinoLevel Level Complete", self.name)

	if not skip_splash_outro:
		await Jumbotron.jumbo_notif(get_exit_jumbo_opts())

	Q.drop_quests()
	level_complete.emit()

func on_quest_failed():
	Debug.notif("DinoLevel Restarting", self.name)
	Q.drop_quests()
	regenerate()

## add_child_to_level ###################################################3

func add_child_to_level(_node, child):
	entities_node.add_child(child)

## player reactions ##################################################3

func _on_player_death(_p):
	# TODO show player lifespan/stats/progress? (hopefully not per player-type! should be in game-mode/dino-level)
	# inspiration: Spelunky, Ape Out
	# ideas: framing the dead player, splashy letters in sync with drums

	# possibly we could share/re-use this, but meh, it'll probably need specific text
	Jumbotron.jumbo_notif({header="You died", body="Sorry about it!",
		action="close", action_label_text="Respawn",
		on_close=Navi.nav_to_main_menu()})
