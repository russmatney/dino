@tool
extends Object
class_name RoomParser

## public types #####################################################

## public api #####################################################

# Returns a RoomDefs with RoomDef(s) and other metadata
static func parse(opts={}) -> RoomDefs:
	# kind of odd... some caching convenience use-case?
	if "parsed_room_defs" in opts:
		return opts.parsed_room_defs

	var room_defs = RoomDefs.new()

	var contents = Util.get_(opts, "contents")
	if contents == null:
		var path = Util.get_(opts, "room_defs_path")
		if path == null:
			Debug.err("Cannot parse, no room_defs_path")
			# This is where we'd want a union type, or nil punning
			return null
		room_defs.path = path
		var file = FileAccess.open(path, FileAccess.READ)
		contents = file.get_as_text()

	var parsed = RoomParser.parse_raw(contents)

	room_defs.prelude = parsed.prelude
	if "name" in room_defs.prelude:
		room_defs.name = room_defs.prelude.name
	room_defs.legend = parsed.legend

	var rooms: Array[RoomDef] = []
	for r in parsed.rooms:
		var def = RoomDef.new()
		def.meta = r.duplicate(true)

		var n = def.meta.get("name", def.meta.get("room_name"))
		if n != null:
			def.name = n

		var shape = []
		for row in r.get("shape"):
			var new_row = []
			for col in row:
				new_row.append(parsed.legend.get(col, col))
			shape.append(new_row)
		def.shape = shape

		rooms.append(def)

	if len(rooms) > 0:
		room_defs.rooms = rooms

	return room_defs

## parser #####################################################

# returns a Dictionary with nothing fancy, just plain types
static func parse_raw(contents) -> Dictionary:
	var parsed = {}
	var section_parsers = {
		"prelude": RoomParser.parse_prelude,
		"legend": RoomParser.parse_legend,
		"rooms": RoomParser.parse_rooms,
	}

	# force a similar prelude header
	contents = "=======\nPRELUDE\n=======\n\n" + contents
	var raw_sections = contents.split("\n\n=")
	for raw_s in raw_sections:
		var chunks = raw_s.split("\n\n")
		var header = chunks[0].split("\n")
		chunks.remove_at(0)
		header = header[1] # middle line
		var parser = section_parsers.get(header.to_lower())
		if parser:
			chunks = Array(chunks).map(func(c): return c.split("\n"))
			chunks = chunks.map(func(chunk):
				return Array(chunk).filter(func(c): return c != "")
				).filter(func(chunk): return len(chunk) > 0)
			parsed[header.to_lower()] = parser.call(chunks)
	return parsed

static func parse_metadata(lines):
	var data = {}
	for l in lines:
		if l == "":
			continue
		var parts = l.split(" ", false, 1)
		var key = parts[0]
		parts.remove_at(0)
		var val = true
		if parts.size() > 0:
			val = " ".join(parts)
		data[key] = val
	return data

static func parse_shape(lines, parse_int=true):
	var shape = []
	for l in lines:
		var row = []
		for c in l:
			if c == ".":
				row.append(null)
			elif parse_int:
				row.append(int(c))
			else:
				row.append(c)
		if row.size() > 0:
			shape.append(row)
	return shape

## prelude #########################################################

static func parse_prelude(chunks):
	var lines = chunks.reduce(func(acc, x):
		acc.append_array(x)
		# fking update-in-place with no return bs
		return acc, [])
	return parse_metadata(lines)


## legend #########################################################

static func parse_legend(chunks):
	var legend = {}
	for lines in chunks:
		for l in lines:
			if l == "":
				continue
			var parts = l.split(" = ")
			# support 'or'
			var val_parts = parts[1].split(" and ")
			legend[parts[0]] = Array(val_parts)

	return legend

## rooms #########################################################

static func parse_room(shape_lines, raw_meta):
	var room = parse_metadata(raw_meta)
	var raw_shape = parse_shape(shape_lines, false)

	room["shape"] = raw_shape
	# maybe want to optimize away from this?
	return room.duplicate(true)

static func parse_rooms(chunks):
	var rooms = []
	for i in len(chunks):
		if i % 2 == 1:
			# only run evens
			continue
		var raw_meta = chunks[i]
		var shape_lines = chunks[i+1]
		rooms.append(parse_room(shape_lines, raw_meta))
	return rooms
