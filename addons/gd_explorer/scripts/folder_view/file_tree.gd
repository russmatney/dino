@tool
extends Tree
class_name GDETree

@onready
var EC_BLUE = Color("#63A3DC")
@onready
var EC_LIGHT_GRAY = Color("#363D4A")
@onready 
var EC_DARK_GRAY = Color("#21262E")

var gde_dummy_path = "res://addons/gd_explorer/cache/gde.txt"
var gde_extra = "res://addons/gd_explorer/cache/gde_extra.txt"

@onready var cache : GDECache = %Data.cache

signal resource_file_selected(filepath: FilePath, item : TreeItem)

var current_dragged_file : String

var root : TreeItem
var _project_root : FilePath
var current_root : FilePath

func _ready() -> void:
	EditorInterface.get_file_system_dock().files_moved.connect(on_file_moved)
	cache.root_changed.connect(root_changed)
	
	set_column_expand(0, true)

func on_file_moved(old : String, new : String):
	if old == gde_dummy_path:		
		var base = current_dragged_file.get_file()
		var parent = new.get_base_dir() + "/" + base
		DirAccess.copy_absolute(current_dragged_file, parent)
		await get_tree().process_frame
		DirAccess.rename_absolute(new, old)

# Signal
func root_changed(path: FilePath) -> void:
	_project_root = path
	current_root = _project_root._duplicate()
	
	clear()
	
	root = create_item()
	root.set_text(0, "Project")
	configure_button_for_item(root)
	set_is_folder(root)
	build_tree_recursive(root, current_root, true)
	root.collapsed = false
	
var supress_action

func configure_button_for_item(item : TreeItem):
	item.add_button(0, GDEUtils.get_icon("EditorCurveHandle"))
	item.set_button_color(0, 0, EC_LIGHT_GRAY)

func set_is_file(item : TreeItem):
	item.set_meta("is_file", true)
func set_is_folder(item : TreeItem):
	item.set_meta("is_file", false)
func is_file(item : TreeItem) -> bool:
	return item.get_meta("is_file")
func get_filepath(item: TreeItem) -> FilePath:
	return item.get_metadata(0)

func set_filterable(item : TreeItem, value : bool):
	if value:
		item.set_icon_modulate(0, EC_BLUE)
	else:
		item.set_icon_modulate(0, EC_LIGHT_GRAY)
	item.set_meta("is_filterable", value)
	for child in item.get_children():
		if is_folder(child):
			set_filterable(child, value)
	
func toggle_filterable(item: TreeItem):
	var is_filterable = is_filterable(item)
	set_filterable(item, !is_filterable)
	
func is_filterable(item: TreeItem) -> bool:
	return item.has_meta("is_filterable") and item.get_meta("is_filterable")
	
func is_folder(item : TreeItem):
	return not is_file(item)

## Sets the icons icon and color, either from cache, or a default type
func set_file_icon_and_color(item : TreeItem):
	var filepath = get_filepath(item)
	if cache.has_thumbnail(filepath):
		item.set_icon(0, cache.get_thumbnail(filepath))
	else:
		item.set_icon(0, filepath.get_icon())
		if cache.has_resource(filepath):
			item.set_icon_modulate(0, EC_BLUE)
		else:
			item.set_icon_modulate(0, EC_LIGHT_GRAY)
	
func build_tree_recursive(item : TreeItem, path : FilePath, go_on: bool):
	supress_action = true
	
	for dir_path in path.get_dirs():
		# SHARED
		var child_item = item.create_child()
		child_item.set_text(0, dir_path.name)
		
		child_item.set_icon(0, GDEUtils.get_icon("Folder"))
		child_item.set_meta("is_file", false)
		child_item.set_icon_modulate(0, EC_LIGHT_GRAY)
			
		configure_button_for_item(child_item)
		
		if go_on:
			build_tree_recursive(child_item, dir_path, go_on)
		else:
			var dummy = child_item.create_child()
			dummy.set_meta("dummy", true)
			dummy.set_text(0, "...")
			child_item.collapsed = true
		
		# SHARED
		child_item.set_icon_max_width(0, 24)
		child_item.set_metadata(0, dir_path)
	
	for f_path in path.get_filess():
		# SHARED
		var child_item = item.create_child()
		child_item.set_text(0, f_path.name)
		
		# SHARED
		child_item.set_icon_max_width(0, 24)
		child_item.set_metadata(0, f_path)
		
		set_file_icon_and_color(child_item)
		child_item.set_meta("is_file", true)
	
	item.collapsed = true
	supress_action = false

func _on_item_activated() -> void:
	var selected = get_selected()
	item_selected(selected)
	
func item_selected(item : TreeItem):
	if is_folder(item):
		item.collapsed = not item.collapsed
		return
		
	var filepath : FilePath = get_filepath(item)
	item.set_icon_modulate(0, EC_BLUE) # TODO Move somewhere else

	# If resource exists, our life is easy
	if cache.has_resource(filepath):
		resource_file_selected.emit(filepath, item)
		return 
		
	var cache_path = filepath.copy_to_cache()
	if cache_path.is_resource():
		EditorInterface.get_resource_filesystem().scan()
		if not ResourceLoader.exists(cache_path.get_local()):
			await EditorInterface.get_resource_filesystem().filesystem_changed
		
		var new_resource = load(cache_path.get_local())
		cache.save_resource(filepath, new_resource)
		delete_async(cache_path)
		resource_file_selected.emit(filepath, item)
		
	modulate = Color.WHITE 

func delete_async(path : FilePath):
	await get_tree().process_frame
	DirAccess.remove_absolute(path.get_local())
	DirAccess.remove_absolute(path.get_local() + ".import")
	EditorInterface.get_resource_filesystem().scan()
	
func is_dummy_folder(item : TreeItem):
	if item.get_child_count() > 0:
		if item.get_child(0).has_meta("dummy"):
			return true
	return false

func set_visibility_recursive(text : String, item : TreeItem):
	var vis = false
	for child in item.get_children():
		if is_folder(child):
			var should_be_visible = set_visibility_recursive(text, child)
			child.visible = should_be_visible
			if should_be_visible:
				child.collapsed = false
				vis = true
		else:
			if is_filterable(item) or text == "":
				var should_be_visible = text == "" or child.get_text(0).to_lower().contains(text)
				child.visible = should_be_visible
				if should_be_visible:
					vis = true
			else:
				child.visible = false
	return vis
		

func _on_line_edit_text_changed(new_text: String) -> void:
	set_visibility_recursive(new_text.to_lower(), root)

func get_next_vis(root_item : TreeItem):
	for item in root_item.get_children():
		if item.visible:
			return item
	return null

func _on_search_submitted(new_text: String) -> void:
	pass # Replace with function body.
	
func _on_item_collapsed(item: TreeItem) -> void:
	if supress_action:
		return
	if is_dummy_folder(item):
		item.get_child(0).free()
		build_tree_recursive(item, get_filepath(item), false)
	
func _on_button_clicked(item: TreeItem, column: int, id: int, mouse_button_index: int) -> void:
	toggle_filterable(item)

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return true
	
func _drop_data(at_position: Vector2, data: Variant) -> void:
	print(data)
	
func _get_drag_data(at_position: Vector2) -> Variant:
	if not FileAccess.file_exists(gde_dummy_path):
		DirAccess.copy_absolute(gde_extra, gde_dummy_path)
		
	var item : TreeItem = get_item_at_position(at_position)
	current_dragged_file = get_filepath(item).get_global()
	return { "type": "files", "files": [gde_dummy_path]}

func set_file_icons_recursive(item : TreeItem):
	if is_file(item):
		set_file_icon_and_color(item)
	else:
		for child in item.get_children():
			set_file_icons_recursive(child)
	
func _on_clear_cache_button_pressed() -> void:
	cache.clear()
	set_file_icons_recursive(root)
	
