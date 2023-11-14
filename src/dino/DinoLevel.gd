extends Node2D
class_name DinoLevel

## vars ######################################################

@onready var level_gen: BrickLevelGen = $LevelGen

signal level_complete

## ready ######################################################

func _ready():
	Log.pr("DinoLevel ready: ", name)

	# call setup_level every time we get new nodes
	# could use a better name for :gen/finished-hook
	level_gen.nodes_transferred.connect(setup_level)

## regenerate ###################################################3

# regenerate the level with whatever passed opts
# presumably invokes the nodes_transferred signal when it's done
var last_level_opts
func regenerate(opts=null):
	if opts == null and last_level_opts:
		opts = last_level_opts
	level_gen.generate(opts)
	last_level_opts = opts

## setup_level ###################################################3

func get_splash_jumbo_opts():
	return {
		header="Welcome to %s" % self.name,
		body=U.rand_of(["Good luck, padawan", "I give you 1 in 10 odds"])
		}

# recursively setup any signals and initial data
func setup_level():
	U._connect(Q.all_quests_complete, on_quests_complete, ConnectFlags.CONNECT_ONE_SHOT)
	U._connect(Q.quest_failed, on_quest_failed, ConnectFlags.CONNECT_ONE_SHOT)
	Q.setup_quests()
	P.remove_player()

	# mk this is kind of cool
	await Jumbotron.jumbo_notif(get_splash_jumbo_opts())

	P.respawn_player()

func get_exit_jumbo_opts():
	return {
		header="%s complete!" % self.name,
		body=U.rand_of(["Seriously, wow.", "OMG YOU DID IT", "Yo! Way to go!"])
		}

func on_quests_complete():
	Hood.notif("DinoLevel Level Complete", self.name)

	await Jumbotron.jumbo_notif(get_exit_jumbo_opts())

	Q.drop_quests()
	level_complete.emit()

func on_quest_failed():
	Hood.notif("DinoLevel Restarting", self.name)
	Q.drop_quests()
	regenerate()
