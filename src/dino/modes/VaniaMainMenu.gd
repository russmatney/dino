@tool
extends CanvasLayer

@onready var players_grid_container = $%PlayersGridContainer
@onready var enemies_grid_container = $%EnemiesGridContainer

@onready var room_count_label = $%RoomCount
@onready var dec_room_count_button = $%DecRoomCountButton
@onready var inc_room_count_button = $%IncRoomCountButton

@onready var button_list = $%ButtonList

var entity_button = preload("res://src/dino/ui/EntityButton.tscn")

var game_entities = []
var selected_game_entities = []
var enemy_entities = []
var selected_enemy_entities = []
var player_entities = []
var selected_player_entity

const max_room_count = 10
var room_count = 4
func inc_room_count():
	room_count += 1
	room_count = mini(room_count, max_room_count)
	reset_ui()

func dec_room_count():
	room_count -= 1
	room_count = maxi(room_count, 1)
	reset_ui()

## ready ##################################################

func _ready():
	if Engine.is_editor_hint():
		request_ready()

	dec_room_count_button.pressed.connect(func(): dec_room_count())
	inc_room_count_button.pressed.connect(func(): inc_room_count())

	build_players_grid()
	build_enemies_grid()
	reset_ui()

	DJ.resume_menu_song()
	set_focus()

## focus ##################################################

func set_focus():
	var chs = players_grid_container.get_children()
	if len(chs) > 0:
		chs[0].set_focus()

## reset ui ##################################################

func reset_ui():
	reset_menu_buttons()

	room_count_label.text = "[center]rooms: %s" % room_count

	for butt in players_grid_container.get_children():
		butt.is_selected = butt.entity == selected_player_entity

	for butt in enemies_grid_container.get_children():
		butt.is_selected = butt.entity in selected_enemy_entities

## players grid ##################################################

func select_player(player_entity):
	selected_player_entity = player_entity
	reset_ui()

func build_players_grid():
	player_entities = DinoPlayerEntity.all_entities()
	selected_player_entity = player_entities[0]
	U.free_children(players_grid_container)

	for pl in player_entities:
		var button = EntityButton.newButton(pl, select_player)
		players_grid_container.add_child(button)

## enemies grid ##################################################

func toggle_enemy(enemy_entity):
	if enemy_entity in selected_enemy_entities:
		selected_enemy_entities.erase(enemy_entity)
	else:
		selected_enemy_entities.append(enemy_entity)

	reset_ui()

func build_enemies_grid():
	enemy_entities = DinoEnemy.all_enemies()
	selected_enemy_entities = enemy_entities
	U.free_children(enemies_grid_container)

	for en in enemy_entities:
		var button = EntityButton.newButton(en, toggle_enemy)
		enemies_grid_container.add_child(button)

## start game ##################################################

var vania_scene = preload("res://src/dino/modes/Vania.tscn")
func start():
	Navi.nav_to(vania_scene, {setup=func(scene):
		scene.set_player_entity(selected_player_entity)
		scene.set_enemy_entities(selected_enemy_entities)
		scene.set_room_count(room_count)
		})

## menu buttons ##################################################

func get_menu_buttons():
	return [
		{
			label="Start DinoVania!",
			# is_disabled=func(): return len(selected_game_entities) < 1,
			fn=start,
		},
		{
			label="Deselect all",
			fn=func():
			selected_game_entities = []
			reset_ui.call_deferred(),
			is_disabled=func(): return len(selected_game_entities) == 0,
		},
		{
			label="Back to Dino Menu",
			fn=Navi.nav_to_main_menu,
			hide_fn=func(): return not (OS.has_feature("dino") or OS.has_feature("editor")),
		},
	]

func reset_menu_buttons():
	var items = get_menu_buttons()
	button_list.set_menu_items(items)
