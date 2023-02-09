#!/usr/bin/env -S godot -s --no-window
extends SceneTree


func _init():
	print("args", OS.get_cmdline_args())
	print("hello")
	print("os can draw: ", OS.can_draw())
	print("os props: ", OS.get_property_list())

	# for p in OS.get_property_list():
	# 	print(p.name)
	# 	print("  " + p.name + ": ", OS.get(p.name))

	print("window size: ", get_window().get_size())
	print("window position: ", get_window().get_position())
	print("no window: ", get_window().get_position() == Vector2.ZERO)
	# print("minimized: ", (get_window().mode == Window.MODE_MINIMIZED))
	quit()
