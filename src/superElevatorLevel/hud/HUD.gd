extends CanvasLayer

##########################################
# ready

func _ready():
	Hotel.entry_updated.connect(_on_entry_updated)
	_on_entry_updated(Hotel.first({is_player=true}))

##########################################
# hotel update

func _on_entry_updated(entry):
	if "player" in entry.get("groups", []):
		update_player(entry)
	if "enemies" in entry.get("groups", []):
		update_enemy_status(entry)

##########################################
# player status

@onready var player_status = $%PlayerStatus

# TODO get portrait from current player?
var player_portrait = preload("res://assets/hatbot/portraits1.png")

func update_player(entry):
	if "health" in entry:
		player_status.set_status({
			health=entry.get("health"),
			name=entry.get("name"),
			texture=player_portrait,
			})


##########################################
# enemy status

var to_portrait_texture = {
	# TODO create portraits for player + enemies
	"Goon": preload("res://assets/hatbot/portraits3.png"),
	}


@onready var enemy_status_list = $%EnemyStatusList

func update_enemy_status(enemy):
	var opts = enemy.duplicate()
	var nm = str(enemy.get("name"))
	var texture
	if nm:
		for k in to_portrait_texture:
			if nm.contains(k):
				texture = to_portrait_texture[k]
				break

	if texture:
		opts["texture"] = texture

	opts["key"] = nm
	opts["name"] = opts.get("display_name", nm)
	opts["ttl"] = 10

	enemy_status_list.update_status(opts)
