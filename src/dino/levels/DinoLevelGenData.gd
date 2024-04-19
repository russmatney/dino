@tool
extends Object
class_name DinoLevelGenData

static func label_to_entity(opts):
	# TODO these should optionally reference pandora entities,
	# and use scene as a fallback
	return {
		# player
		"Player": {scene=DinoEntity.get_entity_scene(DinoEntityIds.PLAYERSPAWNPOINT)},

		# bosses
		"Boss": {scene=DinoEnemy.get_enemy_scene(EnemyIds.BEEFSTRONAUT)},
		"Monstroar": {scene=DinoEnemy.get_enemy_scene(EnemyIds.MONSTROAR)},
		"Beefstronaut": {scene=DinoEnemy.get_enemy_scene(EnemyIds.BEEFSTRONAUT)},

		# enemies
		"Blob": {scene=DinoEnemy.get_enemy_scene(EnemyIds.BLOB)},
		"Enemy": {scene=DinoEnemy.get_enemy_scene(EnemyIds.ROBOT)},

		# pickups
		"Leaf": {scene=DinoEntity.get_entity_scene(DinoEntityIds.LEAF)},

		# entities
		"Candle": {scene=DinoEntity.get_entity_scene(DinoEntityIds.CANDLE)},
		"CookingPot": {scene=DinoEntity.get_entity_scene(DinoEntityIds.COOKINGPOT),
			setup=func(p): p.position += Vector2(opts.tile_size/2.0, opts.tile_size)
			},
		"Void": {scene=DinoEntity.get_entity_scene(DinoEntityIds.VOID),},
		"Target": {scene=DinoEntity.get_entity_scene(DinoEntityIds.TARGET),
			setup=func(t):
			t.position += Vector2.RIGHT * opts.tile_size / 2.0
			t.position += Vector2.DOWN * opts.tile_size / 2.0
			},

		# platforms/walls
		"OneWayPlatform": {scene=load("res://src/dino/platforms/OneWayPlatform.tscn"),
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
