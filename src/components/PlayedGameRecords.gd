@tool
extends HBoxContainer

## vars #########################################

var records = []

@onready var game_icons = $%PlayedGameIcons
@onready var game_label = $%GameLabel
@onready var game_record_text = $%GameRecordText
@onready var player_icons = $%PlayerIcons

## ready #########################################

func _ready():
	if not Engine.is_editor_hint():
		# TODO pull records from various sources (disk?)
		records = Records.current_records

	if Engine.is_editor_hint() and len(records) == 0:
		# Log.pr("building fake game records for ui debugging")
		records = DinoRecords.mk_records([{
				game_entity=Pandora.get_entity(DinoGameEntityIds.GUNNER),
				completed_at=Time.get_datetime_dict_from_system(),
				player_entities=[
					Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER),
					]
			}, {
				game_entity=Pandora.get_entity(DinoGameEntityIds.TOWERJET),
				completed_at=Time.get_datetime_dict_from_system(),
				player_entities=[Pandora.get_entity(DinoPlayerEntityIds.HARIOPLAYER),]
			}, {
				game_entity=Pandora.get_entity(DinoGameEntityIds.SHIRT),
				completed_at=Time.get_datetime_dict_from_system(),
				player_entities=[
					Pandora.get_entity(DinoPlayerEntityIds.HATBOTPLAYER),
					Pandora.get_entity(DinoPlayerEntityIds.HOODIEPLAYER),
					]
			}, {
				game_entity=Pandora.get_entity(DinoGameEntityIds.SUPERELEVATORLEVEL),
				completed_at=Time.get_datetime_dict_from_system(),
				player_entities=[Pandora.get_entity(DinoPlayerEntityIds.ROMEOPLAYER),]
			},])

	render()
	visibility_changed.connect(func():
		if visible:
			render())

## render #########################################

func render():
	if len(records) == 0:
		records = Records.current_records
		return

	U.free_children(game_icons)
	for rec in records:
		var button = EntityButton.newButton(rec.game_entity, func(_ent): show_record(rec))
		game_icons.add_child(button)

func show_record(record):
	game_label.text = "%s" % record.game_entity.get_display_name()
	game_record_text.text = "%s" % Log.to_printable([record])

	U.free_children(player_icons)
	for p in record.player_entities:
		var button = EntityButton.newButton(p)
		player_icons.add_child(button)
