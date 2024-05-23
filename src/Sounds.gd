extends DJSoundMap

enum S {
	boss_shoot,
	boss_swoop,
	bosslaugh,
	bosswarp,
	bullet_pop,
	bump,
	candlelit,
	candleout,
	climbstart,
	coin,
	collectpowerup,
	complete,
	cure,
	destroyed_block,
	enemy_dead,
	enemy_hit,
	enemy_sees_you,
	enemy_spawn,
	enemyhurt,
	enemylaugh,
	fall,
	fire,
	heavy_fall,
	heavy_landing,
	jet_boost,
	jet_echo,
	jet_init,
	jump,
	kick,
	land,
	laser,
	maximize,
	minimize,
	nodamageclang,
	pickup,
	playerheal,
	playerhurt,
	player_dead,
	player_hit,
	player_spawn,
	punch,
	showjumbotron,
	slime,
	soldierdead,
	soldierhit,
	speedup,
	step,
	swordswing,
	target_kill,
	walk,
	}

###########################################################################
# sounds

@onready var sounds = {
	S.bosswarp:
	[
			preload("res://addons/core/dj/assets/sounds/bosswarp1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/bosswarp2.sfxr"),
		],
	S.bosslaugh:
	[
			preload("res://addons/core/dj/assets/sounds/bosslaugh1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/bosslaugh2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/bosslaugh3.sfxr"),
		],
	S.boss_shoot:
	[
			preload("res://addons/core/dj/assets/sounds/boss_shoot1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/boss_shoot2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/boss_shoot3.sfxr"),
		],
	S.boss_swoop:
	[
			preload("res://addons/core/dj/assets/sounds/boss_swoop1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/boss_swoop2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/boss_swoop3.sfxr"),
		],
	S.bullet_pop:
	[
		preload("res://addons/core/dj/assets/sounds/small_explosion.sfxr"),
	],
	S.bump:
	[
		preload("res://addons/core/dj/assets/sounds/bump1.sfxr"),
		preload("res://addons/core/dj/assets/sounds/bump2.sfxr"),
		preload("res://addons/core/dj/assets/sounds/bump3.sfxr"),
	],
	S.candlelit:
	[
			preload("res://addons/core/dj/assets/sounds/candlelit1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/candlelit2.sfxr"),
		],
	S.candleout:
	[
			preload("res://addons/core/dj/assets/sounds/candleout1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/candleout2.sfxr"),
		],
	S.climbstart:
	[
			preload("res://addons/core/dj/assets/sounds/climbstart1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/climbstart2.sfxr"),
		],
	S.coin:
	[
			preload("res://addons/core/dj/assets/sounds/coin1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/coin2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/coin3.sfxr"),
		],
	S.collectpowerup:
	[
			preload("res://addons/core/dj/assets/sounds/collectpowerup1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/collectpowerup2.sfxr"),
		],
	S.complete: [
		preload("res://addons/core/dj/assets/sounds/Retro Game Weapons Sound Effects - complete.ogg")
		],
	S.cure: [
		preload("res://addons/core/dj/assets/sounds/Retro Game Weapons Sound Effects - cure.ogg")
		],
	S.destroyed_block:
	[
			preload("res://addons/core/dj/assets/sounds/destroyedblock1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/destroyedblock2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/destroyedblock3.sfxr"),
		],
	S.enemyhurt:
	[
			preload("res://addons/core/dj/assets/sounds/enemy_hurt1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/enemy_hurt2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/enemy_hurt3.sfxr"),
		],
	S.enemylaugh:
	[
			preload("res://addons/core/dj/assets/sounds/enemylaugh1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/enemylaugh2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/enemylaugh3.sfxr"),
		],
	S.enemy_dead:
	[
		preload("res://addons/core/dj/assets/sounds/enemy_dead1.sfxr"),
	],
	S.enemy_hit:
	[
		preload("res://addons/core/dj/assets/sounds/enemy_hurt1.sfxr"),
	],
	S.enemy_sees_you:
	[
		preload("res://addons/core/dj/assets/sounds/enemy_sees_you1.sfxr"),
	],
	S.enemy_spawn:
	[
		preload("res://addons/core/dj/assets/sounds/enemy_spawn2.sfxr"),
	],
	S.fall:
	[
			preload("res://addons/core/dj/assets/sounds/fall1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/fall2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/fall3.sfxr"),
		],
	S.fire:
	[
		preload("res://addons/core/dj/assets/sounds/fire1.sfxr"),
		preload("res://addons/core/dj/assets/sounds/fire2.sfxr"),
	],
	S.heavy_fall:
	[
			preload("res://addons/core/dj/assets/sounds/heavyfall1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/heavyfall2.sfxr"),
		],
	S.heavy_landing:
	[
		preload("res://addons/core/dj/assets/sounds/small_explosion.sfxr"),
		preload("res://addons/core/dj/assets/sounds/heavy_landing1.sfxr"),
	],
	S.jet_boost:
	[
		preload("res://addons/core/dj/assets/sounds/jet2.sfxr"),
		preload("res://addons/core/dj/assets/sounds/jet3.sfxr"),
	],
	S.jet_echo:
	[
		preload("res://addons/core/dj/assets/sounds/jet_echo1.sfxr"),
		preload("res://addons/core/dj/assets/sounds/jet_echo2.sfxr"),
	],
	S.jet_init:
	[
		preload("res://addons/core/dj/assets/sounds/jet1.sfxr"),
	],
	S.jump:
	[
			preload("res://addons/core/dj/assets/sounds/jump1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/jump2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/jump3.sfxr"),
			preload("res://addons/core/dj/assets/sounds/jump4.sfxr"),
		],
	S.kick:
	[
		preload("res://addons/core/dj/assets/sounds/punch1.sfxr"),
		preload("res://addons/core/dj/assets/sounds/punch2.sfxr"),
		preload("res://addons/core/dj/assets/sounds/punch3.sfxr"),
		preload("res://addons/core/dj/assets/sounds/punch4.sfxr"),
		],
	S.land:
	[
		preload("res://addons/core/dj/assets/sounds/step1.sfxr"),
		preload("res://addons/core/dj/assets/sounds/step2.sfxr"),
		preload("res://addons/core/dj/assets/sounds/step3.sfxr"),
	],
	S.laser:
	[
		preload("res://addons/core/dj/assets/sounds/laser1.sfxr"),
		preload("res://addons/core/dj/assets/sounds/laser2.sfxr"),
		preload("res://addons/core/dj/assets/sounds/laser3.sfxr"),
		preload("res://addons/core/dj/assets/sounds/laser4.sfxr"),
		preload("res://addons/core/dj/assets/sounds/laser5.sfxr"),
	],
	S.maximize: [preload("res://addons/core/dj/assets/sounds/maximize_006.ogg")],
	S.minimize: [preload("res://addons/core/dj/assets/sounds/minimize_006.ogg")],
	S.nodamageclang:
	[
			preload("res://addons/core/dj/assets/sounds/nodamageclang.sfxr"),
			preload("res://addons/core/dj/assets/sounds/nodamageclang2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/nodamageclang3.sfxr"),
		],
	S.pickup:
	[
		preload("res://addons/core/dj/assets/sounds/pickup1.sfxr"),
		preload("res://addons/core/dj/assets/sounds/pickup2.sfxr"),
		preload("res://addons/core/dj/assets/sounds/pickup3.sfxr"),
		preload("res://addons/core/dj/assets/sounds/pickup4.sfxr"),
		preload("res://addons/core/dj/assets/sounds/pickup5.sfxr"),
		preload("res://addons/core/dj/assets/sounds/pickup6.sfxr"),
	],
	S.playerheal:
	[
			preload("res://addons/core/dj/assets/sounds/playerheal1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/playerheal2.sfxr"),
		],
	S.playerhurt:
	[
			preload("res://addons/core/dj/assets/sounds/player_hurt1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/player_hurt2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/player_hurt3.sfxr"),
		],
	S.player_hit:
	[
		preload("res://addons/core/dj/assets/sounds/player_hurt1.sfxr"),
	],
	S.player_dead:
	[
		preload("res://addons/core/dj/assets/sounds/player_dead1.sfxr"),
	],
	S.player_spawn:
	[
		preload("res://addons/core/dj/assets/sounds/player_spawn1.sfxr"),
	],
	S.punch:
	[
		preload("res://addons/core/dj/assets/sounds/punch1.sfxr"),
		preload("res://addons/core/dj/assets/sounds/punch2.sfxr"),
		preload("res://addons/core/dj/assets/sounds/punch3.sfxr"),
		preload("res://addons/core/dj/assets/sounds/punch4.sfxr"),
	],
	S.showjumbotron:
	[
			preload("res://addons/core/dj/assets/sounds/showjumbotron1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/showjumbotron2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/showjumbotron3.sfxr"),
		],
	S.slime: [preload("res://addons/core/dj/assets/sounds/slime_001.ogg")],
	S.soldierdead:
	[
			preload("res://addons/core/dj/assets/sounds/soldierdead1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/soldierdead2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/soldierdead3.sfxr"),
		],
	S.soldierhit:
	[
			preload("res://addons/core/dj/assets/sounds/soldierhit.sfxr"),
			preload("res://addons/core/dj/assets/sounds/soldierhit1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/soldierhit2.sfxr"),
		],
	S.speedup:
	[
		preload("res://addons/core/dj/assets/sounds/speedup1.sfxr"),
		preload("res://addons/core/dj/assets/sounds/speedup2.sfxr"),
		preload("res://addons/core/dj/assets/sounds/speedup3.sfxr"),
	],
	S.step:
	[
		preload("res://addons/core/dj/assets/sounds/step1.sfxr"),
		preload("res://addons/core/dj/assets/sounds/step2.sfxr"),
		preload("res://addons/core/dj/assets/sounds/step3.sfxr"),
	],
	S.swordswing:
	[
			preload("res://addons/core/dj/assets/sounds/swordswing1.sfxr"),
			preload("res://addons/core/dj/assets/sounds/swordswing2.sfxr"),
			preload("res://addons/core/dj/assets/sounds/swordswing3.sfxr"),
		],
	S.target_kill:
	[
		preload("res://addons/core/dj/assets/sounds/target_kill1.sfxr"),
		preload("res://addons/core/dj/assets/sounds/target_kill2.sfxr"),
		preload("res://addons/core/dj/assets/sounds/target_kill3.sfxr"),
	],
	S.walk:
	[
		preload("res://addons/core/dj/assets/sounds/walk1.sfxr"),
		preload("res://addons/core/dj/assets/sounds/walk2.sfxr"),
	],
}

func _ready():
	if not Engine.is_editor_hint():
		SoundManager.set_default_sound_bus("Sound")
		SoundManager.set_default_ui_sound_bus("UI Sound")
		SoundManager.set_default_ambient_sound_bus("Ambient Sound")
		# deferring to give Music._ready a chance to set its buses
		# dodging a SoundManager warning about using the Master bus
		SoundManager.set_sound_volume.call_deferred(0.5)
		SoundManager.set_ui_sound_volume.call_deferred(0.5)
		SoundManager.set_ambient_sound_volume.call_deferred(0.5)

	super._ready()

####################################################################

func _enter_tree() -> void:
	if not Engine.is_editor_hint():
		get_tree().node_added.connect(on_node_added)

func on_node_added(node: Node):
	if node is Button:
		node.focus_entered.connect(on_button_focused.bind(node))
		node.pressed.connect(on_button_pressed.bind(node))

func on_button_focused(button: Button) -> void:
	if button.is_visible_in_tree():
		play(S.step)

func on_button_pressed(_button: Button) -> void:
	play(S.speedup)
