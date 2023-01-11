tool
extends HBoxContainer

signal param_changed(name, value)
signal param_reset(name)

export var options: Array setget set_options
export var parameter: String # Could be PoolStringArray, but pybabel won't catch that

onready var option_button := $OptionButton as OptionButton


func _ready():
	set_options(options)


func set_options(v: Array) -> void:
	options = v
	
	if is_inside_tree():
		option_button.clear()
		for item in options:
			option_button.add_item(item)


func set_value(v: int) -> void:
	option_button.select(v)


func get_value() -> int:
	return option_button.selected


func set_resetable(v: bool) -> void:
	$Reset.disabled = not v


func _on_OptionButton_item_selected(index: int):
	emit_signal("param_changed", parameter, index)


func _on_Reset_pressed():
	emit_signal("param_reset", parameter)
