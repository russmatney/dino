extends RefCounted

const PLUGIN_NAME := "custom-scene-launcher"
const SETTINGS_KEY := PLUGIN_NAME + "/scene"
const DO_RUN_KEY := PLUGIN_NAME + "/run"
const PLUGIN_CONFIG_DIR := "addons"
const PLUGIN_CONFIG := "settings.cfg"

var _plugin_config = ConfigFile.new()

var scene_path: String : set = set_scene_path, get = get_scene_path
var was_manually_set: bool : set = set_was_manually_set, get = get_was_manually_set
var root_dir: String


func _init(dir: String) -> void:
	root_dir = dir


func load_settings() -> void:
	var path = get_config_path()
	if not FileAccess.file_exists(path):
		var config = ConfigFile.new()
		DirAccess.make_dir_recursive_absolute(path.get_base_dir())
		config.save(path)
	else:
		_plugin_config.load(path)
		var text = _plugin_config.get_value("general", "scene", "")
		if text != "":
			set_was_manually_set(true)


func get_config_path() -> String:
	var home = root_dir.path_join(PLUGIN_CONFIG_DIR).path_join(PLUGIN_NAME)
	var path = home.path_join(PLUGIN_CONFIG)
	return path


func set_scene_path(new_path: String) -> void:
	_save_setting("scene_path", new_path)


func get_scene_path() -> String:
	return _load_setting("scene_path", "") as String


func set_was_manually_set(is_it: bool) -> void:
	_save_setting("was_manually_set", is_it)


func get_was_manually_set() -> bool:
	var x = _load_setting("was_manually_set", "")
	if x is bool:
		return x
	elif x != "":
		return true
	return false


# container.scene_path.text
func _save_setting(key: String, value) -> void:
	_plugin_config.set_value("general", key, value)
	_plugin_config.save(get_config_path())


func _load_setting(key: String, defaultValue):
	return _plugin_config.get_value("general", key, defaultValue)
