@tool
extends CanvasLayer


##########################################
# ready

func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)

	update_player_data.call_deferred()

func update_player_data():
	var player_data = Hotel.query({is_player=true})
	if len(player_data) > 0:
		_on_entry_updated(player_data[0])
	else:
		Debug.warn("no player data yet, can't update hud")
		# call with timeout until initial success?

func _on_entry_updated(entry):
	# maybe strange to do this way... or maybe it's nice and decoupled?
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
	if Metro.rooms_group in entry["groups"]:
		update_minimap(entry)

##########################################
# health

@onready var hearts = $%HeartsContainer

func set_health(health):
	# TODO tween/jiggle hearts on change!
	hearts.h = health

##########################################
# powerups

@onready var sword = $%SwordPowerup
@onready var double_jump = $%DoubleJumpPowerup
@onready var climbing_gloves = $%ClimbingGlovesPowerup

func set_powerups(powerups):
	for p in HatBot.all_powerups:
		var vis = p in powerups
		match(p):
			HatBot.Powerup.Sword: sword.set_visible(vis)
			HatBot.Powerup.DoubleJump: double_jump.set_visible(vis)
			HatBot.Powerup.Climb: climbing_gloves.set_visible(vis)
			_: pass

##########################################
# labels

@onready var deaths_label = $%DeathsLabel
@onready var coins_label = $%CoinsLabel

func set_deaths(count):
	# TODO tween/jiggle on change!
	if count > 0:
		deaths_label.text = "[right]Deaths [jump]%s[/jump][/right]" % count
	else:
		deaths_label.text = ""

func set_coins(count):
	# TODO tween/jiggle on change!
	if count > 0:
		coins_label.text = "[right]Coins [jump]%s[/jump][/right]" % count
	else:
		coins_label.text = ""

##########################################
# enemy status list

var to_portrait_texture = {
	"Beefstronaut": preload("res://assets/hatbot/portraits1.png"),
	"Monstroar": preload("res://assets/hatbot/portraits2.png"),
	"Goomba": preload("res://assets/hatbot/portraits3.png"),
	"Soldier": preload("res://assets/hatbot/portraits4.png"),
	"ShootyCrawly": preload("res://assets/hatbot/portraits5.png"),
	}


@onready var enemy_status_list = $%EnemyStatusList
var status_scene = preload("res://src/hatbot/hud/EnemyStatus.tscn")

func find_existing_status(enemy):
	for ch in enemy_status_list.get_children():
		if ch.key == enemy.get("name"):
			return ch

func update_enemy_status(enemy):
	var nm = enemy.get("name")

	var existing = find_existing_status(enemy)
	if existing and is_instance_valid(existing):
		# assume it's just a health update
		existing.set_status({health=enemy.get("health")})
	else:
		if len(enemy_status_list.get_children()) >= 3:
			Debug.pr("Too many enemy_statuses, not adding one", enemy)
			# TODO evict least-relevant status
			return
		var status = status_scene.instantiate()
		enemy_status_list.add_child(status)

		var opts = {
			name=nm,
			health=enemy.get("health"),
			ttl=0 if "bosses" in enemy.get("groups", []) else 5,
			}

		var inst = enemy.get("instance_name")
		var texture
		if inst and inst in to_portrait_texture:
			texture = to_portrait_texture[inst]
		if texture:
			opts["texture"] = texture

		# call after adding so _ready has added elems
		status.set_status(opts)


##########################################
# minimap

# @onready var minimap = $%Minimap

@onready var zone_name = $%ZoneName
@onready var room_name = $%RoomName

func update_minimap(room):
	if room.get("has_player"):
		zone_name.text = room.get("zone_name").capitalize()
		room_name.text = room.get("name").capitalize()
