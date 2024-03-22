@tool
class_name RoomDef
extends Object

var name: String
var shape: Array
var meta: Dictionary

func to_printable():
	return {name=name, meta=meta}

func has_flag(f):
	if f in meta:
		return meta.get(f)

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

# Returns an array of dicts like [{"coord": Vector2, "cell": Array[String]}]
func coords() -> Array:
	var crds = []
	for y in len(shape):
		var row = shape[y]
		for x in len(row):
			var coord = Vector2(x, y)
			var cell = shape[y][x]
			if cell != null:
				crds.append({coord=coord, cell=cell})
	return crds
