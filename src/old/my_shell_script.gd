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

	print("window size: ", OS.get_window_size())
	print("window position: ", OS.get_window_position())
	print("no window: ", OS.get_window_position() == Vector2.ZERO)
	# print("minimized: ", OS.window_minimized)
	quit()
