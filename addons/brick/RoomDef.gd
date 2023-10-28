class_name RoomDef
extends Object

var name: String
var shape: Array
var meta: Dictionary

func to_pretty(obj, a, b, c):
	return Debug.to_pretty({name=name, meta=meta}, a, b, c)

func has_flag(f):
	if f in meta:
		return meta.get(f)

func column(idx: int):
	var col = []
	for row in shape:
		if idx >= len(row):
			Debug.error("idx outside of row width, cannot build column")
			return []
		col.append(row[idx])
	return col

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
