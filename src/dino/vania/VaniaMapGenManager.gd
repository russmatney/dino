@tool
extends Node

@export var map_def: MapDef

@export_dir var map_dir: String
@export var generation_label: String

var generator: VaniaGenerator

@export var run_generate: bool:
	set(v):
		Log.info("toggled run_generate", map_def, map_dir, generation_label)
		if v and Engine.is_editor_hint():
			if map_dir != null and map_dir != "" and map_def != null:
				Log.info("Running generator", map_def)
				# TODO run on a thread
				generator = VaniaGenerator.new(map_dir, generation_label)
				generator.generate_map(map_def)

func _ready():
	Log.pr("Howdy ho!", {map_dir=map_dir, map_def=map_def})
