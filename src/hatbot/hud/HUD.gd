@tool
extends CanvasLayer


##########################################
# ready

func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)

	update_player_data.call_deferred()

func update_player_data():
	var player_data = Hotel.first({is_player=true})
	if player_data != null:
		_on_entry_updated(player_data)
	else:
		Debug.warn("no player data yet, can't update hud")
		# call with timeout until initial success?

func _on_entry_updated(entry):
	if "player" in entry["groups"]:
		if entry.get("health") != null:
			set_health(entry["health"])
		if entry.get("powerups") != null:
			set_powerups(entry["powerups"])
		if entry.get("death_count") != null:
			set_deaths(entry["death_count"])
		if entry.get("coins") != null:
			set_coins(entry["coins"])
	if "enemies" in entry["groups"]:
		update_enemy_status(entry)

##########################################
# health

@onready var hearts = $%HeartsContainer

func set_health(health):
	hearts.h = health

##########################################
# powerups

@onready var sword = $%SwordPowerup
@onready var double_jump = $%DoubleJumpPowerup
@onready var climbing_gloves = $%ClimbingGlovesPowerup

func set_powerups(powerups):
	for p in SS.all_powerups:
		var vis = p in powerups
		match(p):
			SS.Powerup.Sword: sword.set_visible(vis)
			SS.Powerup.DoubleJump: double_jump.set_visible(vis)
			SS.Powerup.Climb: climbing_gloves.set_visible(vis)
			_: pass

##########################################
# labels

@onready var deaths_label = $%DeathsLabel
@onready var coins_label = $%CoinsLabel

func set_deaths(count):
	if count > 0:
		deaths_label.text = "[right]Deaths [jump]%s[/jump][/right]" % count
	else:
		deaths_label.text = ""

func set_coins(count):
	if count > 0:
		coins_label.text = "[right]Coins [jump]%s[/jump][/right]" % count
	else:
		coins_label.text = ""

##########################################
# enemy status list

var to_portrait_texture = {
	"Beefstronaut": preload("res://src/hatbot/assets/portraits1.png"),
	"Monstroar": preload("res://src/hatbot/assets/portraits2.png"),
	"Goomba": preload("res://src/hatbot/assets/portraits3.png"),
	"Soldier": preload("res://src/hatbot/assets/portraits4.png"),
	"ShootyCrawly": preload("res://src/hatbot/assets/portraits5.png"),
	}


@onready var enemy_status_list = $%EnemyStatusList

func update_enemy_status(enemy):
	var inst = enemy.get("instance_name")
	var texture
	if inst and inst in to_portrait_texture:
		texture = to_portrait_texture[inst]
	if texture:
		enemy["texture"] = texture

	enemy["ttl"] = 0 if "bosses" in enemy.get("groups", []) else 5

	enemy_status_list.update_status(enemy)

