@tool
extends HUD

@onready var player_status = $%PlayerStatus
@onready var enemy_status_list = $%EnemyStatusList
@onready var shrine_gem_count = $%ShrineGemCount

var to_portrait_texture = {
	"Player": preload("res://assets/sprites/status_portraits6.png"),
	"Goon": preload("res://assets/sprites/status_portraits7.png"),
	"Boss": preload("res://assets/sprites/status_portraits8.png"),
	}

func _on_player_update(data):
	if "health" in data:
		player_status.set_status({
			health=data.get("health"),
			name=data.get("display_name", data.get("name")),
			texture=to_portrait_texture["Player"],
			})
	if "shrine_gems" in data and shrine_gem_count:
		shrine_gem_count.text = "[right]Shrine Gems: %s/2[/right]" % data.get("shrine_gems", 0)

func _on_enemy_update(data):
	var opts = data.duplicate()
	var nm = str(data.get("name"))
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
