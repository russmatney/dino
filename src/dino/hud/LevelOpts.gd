extends PanelContainer

func set_seed(x):
	$%SeedLabel.text = "[right]Seed: %d[/right]" % x

func set_room_count(x):
	$%RoomCountLabel.text = "[right]Rooms: n + %d[/right]" % x
