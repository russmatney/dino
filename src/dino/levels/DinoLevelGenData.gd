@tool
extends Object
class_name DinoLevelGenData

static func label_to_entity(opts):
	# TODO these should optionally reference pandora entities,
	# and use scene as a fallback
	return {
		# player
		"Player": {scene=load("res://addons/core/PlayerSpawnPoint.tscn")},

		# bosses
		"Boss": {scene=load("res://src/hatbot/bosses/Monstroar.tscn")},
		"Monstroar": {scene=load("res://src/hatbot/bosses/Monstroar.tscn")},
		"Beefstronaut": {scene=load("res://src/hatbot/bosses/Beefstronaut.tscn")},

		# enemies
		"Blob": {scene=load("res://src/spike/enemies/Blob.tscn")},
		"Enemy": {scene=load("res://src/dino/entities/enemyRobots/EnemyRobot.tscn")},

		# pickups
		"Leaf": {scene=load("res://src/woods/entities/Leaf.tscn")},

		# entities
		"Candle": {scene=load("res://src/hatbot/entities/Candle.tscn")},
		"CookingPot": {scene=load("res://src/spike/entities/CookingPot.tscn"),
			setup=func(p): p.position += Vector2(opts.tile_size/2.0, opts.tile_size)
			},
		"Void": {scene=load("res://src/spike/entities/DeliveryZone.tscn")},
		"Target": {scene=load("res://src/dino/entities/targets/Target.tscn"),
			setup=func(t):
			t.position += Vector2.RIGHT * opts.tile_size / 2.0
			t.position += Vector2.DOWN * opts.tile_size / 2.0
			},

		# platforms/walls
		"OneWayPlatform": {scene=load("res://src/spike/zones/OneWayPlatform.tscn"),
			# resize to match tile_size
			setup=func(p):
			p.max_width = opts.tile_size
			p.position.x += opts.tile_size/2.0
			p.position.y += opts.tile_size/4.0
			},
		}

static var quests = {
	QuestFeedTheVoid: {},
	QuestBreakTheTargets: {},
	QuestCatchLeaves: {},
	QuestCollectGems: {},
	QuestKillAllEnemies: {},
	FetchSheepQuest: {},
	# TODO harvey quests
	"QuestDeliverProduceCarrot": {new=func(): return QuestDeliverProduce.new({type="carrot"})},
	"QuestDeliverProduceOnion": {new=func(): return QuestDeliverProduce.new({type="tomato"})},
	"QuestDeliverProduceTomato": {new=func(): return QuestDeliverProduce.new({type="onion"})},
	}

static func quests_for_entities(entities):
	var qs = []
	for q_class in quests:
		var opts = quests.get(q_class, {})
		var q
		if opts.get("new"):
			q = opts.get("new").call()
		else:
			q = q_class.new()

		if q.has_required_entities(entities):
			qs.append(q)
		else:
			q.queue_free()
	return qs
