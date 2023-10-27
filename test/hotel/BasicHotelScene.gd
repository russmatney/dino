extends Node2D

var misc_data

func _ready():
	Hotel.register(self)

func check_out(d):
	misc_data = d.get(misc_data)

func hotel_data():
	return {misc_data=misc_data}
