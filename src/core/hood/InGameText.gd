@tool
extends Node2D

@onready var label = $Label

@export var text : String :
	set(v):
		text = v
		if label:
			label.text = "[center]%s[/center]" % text

@export var default_font : FontFile

@export var font : FontFile :
	set(f):
		font = f
		if f and label:
			label.set("theme_override_fonts/normal_font", f)
		elif not f and default_font:
			label.set("theme_override_fonts/normal_font", default_font)

func _ready():
	if text:
		text = text
	if font:
		font = font
	elif default_font:
		font = default_font
