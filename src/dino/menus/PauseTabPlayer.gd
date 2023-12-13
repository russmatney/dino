@tool
extends HBoxContainer

## vars ###################################333

var entity_button = preload("res://src/dino/ui/EntityButton.tscn")

var player_entities = []
var selected_player_entity

var weapon_icon_scene = preload("res://src/dino/ui/WeaponIcon.tscn")

@onready var player_icon = $%PlayerIcon
@onready var player_name = $%PlayerName
@onready var player_description = $%PlayerDescription
@onready var players_grid = $%OtherPlayersGrid

@onready var weapon_icon = $%SelectedWeaponIcon
@onready var weapon_name = $%SelectedWeaponName
@onready var weapon_description = $%SelectedWeaponDescription
@onready var weapons_grid = $%WeaponsGrid


## ready ###################################333

func _ready():
	render()
	visibility_changed.connect(func():
		if visible:
			render())

## render ##################################

func render():
	var p_ent = P.player_entity
	if not p_ent:
		# TODO support select player if none
		return

	update_player_data(p_ent)
	update_players_grid(p_ent)

	var p = P.player
	if not p:
		# TODO zero state for weapons
		return

	update_weapon_data(p)
	update_weapons_grid(p)

## player updates ##################################

func update_player_data(player_ent):
	player_icon.set_texture(player_ent.get_icon_texture())
	player_name.text = "[center]%s[/center]" % player_ent.get_display_name()
	# TODO player descriptions
	player_description.text = "[center]A very good description of %s[/center]" % player_ent.get_display_name()

func update_players_grid(player_ent):
	var player_ents = P.all_player_entities().filter(func(e): return not e == player_ent)
	U.free_children(players_grid)
	for p in player_ents:
		var button = entity_button.instantiate()
		button.set_player_entity(p)
		button.icon_pressed.connect(func(): select_player(p))
		players_grid.add_child(button)

func update_weapon_data(player):
	if not player.has_weapon():
		return

	var ent = player.active_weapon().entity

	weapon_icon.entity = ent
	weapon_icon.render()

	weapon_name.text = "[center]%s[/center]" % ent.get_display_name()
	# TODO weapon descriptions
	weapon_description.text = "[center]A very good description of the %s.[/center]" % ent.get_display_name()

func update_weapons_grid(player):
	if not player.has_weapon():
		return

	var active_weapon_ent = player.active_weapon().entity
	U.remove_children(weapons_grid, {defer=true})
	for w in player.weapons.filter(func(w): return w.entity != active_weapon_ent):
		var button = entity_button.instantiate()
		button.set_weapon_entity(w.entity)
		button.icon_pressed.connect(func(): select_weapon(w.entity))
		weapons_grid.add_child(button)

## select player ##################################

func select_player(player_ent):
	Log.pr("player ent selected", player_ent)

func select_weapon(weapon_ent):
	Log.pr("weapon ent selected", weapon_ent)
