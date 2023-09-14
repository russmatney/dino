@tool
extends Button

signal aseprite_file_dropped(path)

func _can_drop_data(pos, data):
	# TODO validate data["files"][0] extension
	if data.type == "files":
		return true
	return false

func _drop_data(_pos, data):
	if data.type == "files":
		var path = data.files[0]
		aseprite_file_dropped.emit(path)
