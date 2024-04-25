@tool
extends HBoxContainer

## vars ###################################333

@onready var player_icon = $%PlayerIcon
@onready var player_name = $%PlayerName
@onready var player_description = $%PlayerDescription
@onready var players_grid = $%OtherPlayersGrid

@onready var weapon_icon = $%SelectedWeaponIcon
@onready var weapon_name = $%SelectedWeaponName
@onready var weapon_description = $%SelectedWeaponDescription
@onready var weapons_grid = $%WeaponsGrid

var selected_player
var current_player

var selected_weapon
var current_weapon

## ready ###################################333

func _ready():
	render()
	visibility_changed.connect(func():
		if visible:
			render())

## render ##################################

func render():
	var p_ent = Dino.current_player_entity()
	if not p_ent:
		# TODO support select player if none
		return

	update_player_data(p_ent)
	update_players_grid(p_ent)

	var p = Dino.current_player_node()
	if not p or not p.has_weapon():
		# TODO zero state for weapons
		return

	update_weapon_data(p.active_weapon().entity)
	update_weapons_grid(p)

## player updates ##################################

func update_player_data(player_ent):
	current_player = player_ent
	player_icon.set_texture(player_ent.get_icon_texture())
	player_name.text = "[center]%s[/center]" % player_ent.get_display_name()
	# TODO player descriptions
	player_description.text = "[center]A very good description of %s[/center]" % player_ent.get_display_name()

func update_players_grid(player_ent):
	var player_ents = DinoPlayerEntity.all_entities().filter(func(e): return not e == player_ent)
	U.free_children(players_grid)
	for p in player_ents:
		var button = EntityButton.newButton(p, select_player)
		players_grid.add_child(button)

func update_weapon_data(weapon_entity):
	current_weapon = weapon_entity
	weapon_icon.entity = weapon_entity
	weapon_icon.render()
	weapon_name.text = "[center]%s[/center]" % weapon_entity.get_display_name()
	# TODO weapon descriptions
	weapon_description.text = "[center]A very good description of the %s.[/center]" % weapon_entity.get_display_name()

func update_weapons_grid(player):
	if not player.has_weapon():
		return

	var active_weapon_ent = player.active_weapon().entity
	U.remove_children(weapons_grid, {defer=true})
	for w in player.weapon_set.list().filter(func(w): return w.entity != active_weapon_ent):
		var button = EntityButton.newButton(w.entity, select_weapon)
		weapons_grid.add_child(button)

## select interactions ##################################
# TODO restore this menu's interactions!

func select_player(player_ent):
	selected_player = player_ent

	# P.set_player_entity(player_ent)
	# P.clear_player_scene()

	Debug.notif({text="Switched to %s" % player_ent.get_display_name(), id="player-switch"})

	# respawn at current position? regen level?
	# P.respawn_player()

	# clearing b/c these buttons are invalid until the player is setup (after unpausing)
	U.remove_children(weapons_grid, {defer=true})
	render.call_deferred()

func select_weapon(weapon_ent):
	selected_weapon = weapon_ent

	# move behind some confirmation?
	# var p = P.player
	# p.activate_weapon(weapon_ent)

	Debug.notif({text="Switched to %s" % weapon_ent.get_display_name(), id="weapon-switch"})
	render.call_deferred()
