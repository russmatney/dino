class_name GridDef
extends Object

## vars ##########################################

var name: String
var shape: Array
var meta: Dictionary

## printable ##########################################

func to_pretty():
	return {name=name, meta=meta}

## properties ##########################################

func has_flag(f):
	if f in meta:
		return meta.get(f)

func has_label(label) -> bool:
	for coord in coords():
		if label in coord.cell:
			return true
	return false

## row/col getters ##########################################

func column(idx: int):
	var col = []
	for row in shape:
		if idx >= len(row):
			Log.error("idx outside of row width, cannot build column")
			return []
		col.append(row[idx])
	return col

func row(idx: int):
	if idx <= len(shape):
		return shape[idx]
	Log.error("idx outside of width, cannot return row")

## size/rect ##########################################

func size() -> Vector2i:
	return Vector2i(len(shape[0]), len(shape))

func rect() -> Rect2i:
	return Rect2i(Vector2i(), size())

## shape ##########################################

func get_shape_dict(opts={}):
	var shape_dict = {}
	for coord in coords(false):
		shape_dict[Vector2i(coord.coord)] = coord.cell

	if opts.get("drop_entity"):
		for k in shape_dict.keys():
			if shape_dict.get(k) == [opts.get("drop_entity")]:
				shape_dict[k] = null

	return shape_dict

## coords ##########################################

# Returns an array of dicts like [{"coord": Vector2, "cell": Array[String]}]
func coords(skip_nulls=true) -> Array:
	var crds = []
	for y in len(shape):
		var row = shape[y]
		for x in len(row):
			var coord = Vector2(x, y)
			var cell = shape[y][x]
			if skip_nulls:
				if cell != null:
					crds.append({coord=coord, cell=cell})
			else:
				crds.append({coord=coord, cell=cell})
	return crds

## coords for ent ##########################################

func get_coords_for_entity(ent: String):
	var entity_coords = []
	for coord in coords():
		if ent in coord.cell:
			entity_coords.append(Vector2i(coord.coord))
	return entity_coords

## rotations ##########################################

# could include mirrors of these
func get_rotations():
	return [self, self.rotate(1), self.rotate(2), self.rotate(3),]

# TODO worth a simple test or two
# return a new grid def with the shape rotated i times
func rotate(i=1):
	var n = GridDef.new()
	n.name = name
	if i == 1:
		n.shape = rotated_shape(shape)
	elif i == 2:
		var sh = rotated_shape(shape)
		n.shape = rotated_shape(sh)
	elif i == 3:
		var sh = rotated_shape(shape)
		sh = rotated_shape(sh)
		n.shape = rotated_shape(sh)
	else:
		Log.warn("Unexpected grid def rotate i", i)
	n.meta = meta
	return n

func rotated_shape(sh):
	var new_shape = []
	for row in sh:
		for i in len(row):
			if i > len(new_shape) - 1:
				new_shape.append([])
			new_shape[i].append(row[i])
	return new_shape
