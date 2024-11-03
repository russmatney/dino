extends RefCounted

const CellView = MetroidvaniaSystem.CellView

var begin: Vector2i ## TODO handle changing
var size: Vector2i
var layer: int
var queue_updates: bool
var threaded: bool ## TODO

var visible: bool:
	set(v):
		visible = v
		RenderingServer.canvas_item_set_visible(_canvas_item, visible)

var _canvas_item: RID
var _cache: Dictionary#[Vector3i, CellView]
var _custom_elements_cache: Dictionary#[Rect2i, CustomElementInstance]
var _update_queue: Array[RefCounted]

var _force_mapped: bool

func _init(parent_item: RID) -> void:
	_canvas_item = RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(_canvas_item, parent_item)
	recreate_cache.call_deferred()

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		RenderingServer.free_rid(_canvas_item)

func recreate_cache():
	_cache.clear()
	_custom_elements_cache.clear()
	
	for y in size.y:
		for x in size.x:
			var coords := Vector3i(begin.x + x, begin.y + y, layer)
			var cell := CellView.new(_canvas_item)
			cell.coords = coords
			cell.offset = Vector2(x, y)
			_cache[coords] = cell
	
	var rect := Rect2i(begin, size)
	var element_manager: MetroidvaniaSystem.CustomElementManager = MetSys.settings.custom_elements
	var element_list := MetSys.map_data.custom_elements
	
	for coords in MetSys.map_data.custom_elements:
		if coords.z != layer:
			continue
		
		var element: Dictionary = element_list[coords]
		var element_rect := Rect2i(coords.x, coords.y, element["size"].x, element["size"].y)
		if not element_rect.intersects(rect):
			continue
		
		_make_custom_element_instance(coords, element)
	
	update_all()

func _make_custom_element_instance(coords: Vector3i, data: Dictionary):
	var element_instance := CustomElementInstance.new(_canvas_item)
	element_instance.coords = coords
	element_instance.offset = Vector2(-begin + Vector2i(coords.x, coords.y)) * MetSys.CELL_SIZE
	element_instance.data = data
	_custom_elements_cache[coords] = element_instance

func update_custom_element_at(coords: Vector3i):
	var element_list := MetSys.map_data.custom_elements
	var element: Dictionary = element_list.get(coords, {})
	
	if element.is_empty():
		_custom_elements_cache.erase(coords)
	else:
		_make_custom_element_instance(coords, element)
	update_cell(coords)

func update_all():
	for cell: CellView in _cache.values():
		_update_cell(cell)
	for element: CustomElementInstance in _custom_elements_cache.values():
		_update_element(element)

func update_cell(coords: Vector3i):
	var exists: bool
	
	
	var cell: CellView = _cache.get(coords)
	if cell:
		_update_cell(cell)
		exists = true
	
	var custom_element = _custom_elements_cache.get(coords)
	if custom_element:
		_update_element(custom_element)
		exists = true
	
	if not exists:
		push_error("MapView has no cell nor custom element at %s" % coords)

func update_rect(rect: Rect2i):
	for y in rect.size.y:
		for x in rect.size.x:
			update_cell(Vector3i(rect.position.x + x, rect.position.y + y, layer))

func _update_cell(cell: CellView):
	if not queue_updates:
		cell.update()
		return
	
	if _update_queue.is_empty():
		_update_queued.call_deferred()
	
	if not cell in _update_queue:
		_update_queue.append(cell)

func _update_element(element: CustomElementInstance):
	if not queue_updates:
		element.update()
		return
	
	if _update_queue.is_empty():
		_update_queued.call_deferred()
	
	if not element in _update_queue:
		_update_queue.append(element)

func _update_queued():
	for cell in _update_queue:
		cell.update()
	_update_queue.clear()

func _update_all_with_mapped():
	for cell: CellView in _cache.values():
		cell._force_mapped = _force_mapped
		cell.update()

class CustomElementInstance:
	var canvas_item: RID
	var coords: Vector3i
	var offset: Vector2
	var data: Dictionary
	
	func _init(parent_item: RID) -> void:
		canvas_item = RenderingServer.canvas_item_create()
		RenderingServer.canvas_item_set_parent(canvas_item, parent_item)
		RenderingServer.canvas_item_set_z_index(canvas_item, 2)
	
	func _notification(what: int) -> void:
		if what == NOTIFICATION_PREDELETE:
			RenderingServer.free_rid(canvas_item)
	
	func update():
		RenderingServer.canvas_item_clear(canvas_item)
		
		var size: Vector2i = data["size"]
		var element_rect := Rect2i(coords.x, coords.y, size.x, size.y)
		MetSys.settings.custom_elements.draw_element(canvas_item, coords, data["name"], offset, Vector2(element_rect.size) * MetSys.CELL_SIZE, data["data"])
