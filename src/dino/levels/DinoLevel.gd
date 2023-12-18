extends Node2D
class_name DinoLevel

## vars ######################################################

@export var type: DinoData.GameType

@onready var level_gen: BrickLevelGen = $LevelGen
var level_opts: Dictionary
signal level_complete
signal level_setup

var skip_splash_intro = false
var skip_splash_outro = false

var hud_scene = preload("res://src/dino/hud/DinoHUD.tscn")
var hud
var time: float = 0
var time_int = 0

## ready ######################################################

func _ready():
	if level_gen == null:
		Log.error("DinoLevel missing expected 'LevelGen' node")

	Log.pr("DinoLevel ready: ", name)
	hud = hud_scene.instantiate()
	add_child.call_deferred(hud)

	# call setup_level every time we get new nodes
	# could use a better name for :gen/finished-hook
	level_gen.nodes_transferred.connect(setup_level)

	if Dino.is_debug_mode():
		Log.pr("debug mode: regenerating")
		if type == null:
			type = DinoData.GameType.SideScroller
		Dino.ensure_player_setup({type=type,
			entity_id=DinoPlayerEntityIds.HATBOTPLAYER,
		})
		regenerate()

## process ######################################################

func _process(delta):
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
	level_gen.generate(opts)
	# i _think_ this helps support regen from the pause menu
	level_opts = opts

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
