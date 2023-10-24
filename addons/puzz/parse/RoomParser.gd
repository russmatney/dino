@tool
extends Object
class_name RoomParser

## public api #####################################################

static func parse_room_defs(opts={}):
	# kind of odd... some caching convenience use-case?
	if "parsed_room_defs" in opts:
		return opts.parsed_room_defs

	var contents = Util.get_(opts, "contents")
	if contents == null:
		var path = Util.get_(opts, "room_defs_path")
		if path == null:
			Debug.err("Cannot parse_room_defs, no room_defs_path")
			return
		var file = FileAccess.open(path, FileAccess.READ)
		contents = file.get_as_text()

	return RoomParser.parse(contents)

## parser #####################################################

static func parse(contents):
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
			parsed[header.to_lower()] = parser.call(parsed, chunks)
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
		# TODO cast val to non-string (int, float, bool, etc)
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

static func parse_prelude(_parsed, chunks):
	var lines = chunks.reduce(func(acc, x):
		acc.append_array(x)
		# fking update-in-place with no return bs
		return acc, [])
	return parse_metadata(lines)


## legend #########################################################

static func parse_legend(_parsed, chunks):
	var legend = {}
	for lines in chunks:
		for l in lines:
			if l == "":
				continue
			var parts = l.split(" = ")
			# TODO support 'or'
			var val_parts = parts[1].split(" and ")
			legend[parts[0]] = Array(val_parts)

	return legend

## rooms #########################################################

static func parse_room(parsed, shape_lines, raw_meta):
	var room = parse_metadata(raw_meta)
	var raw_shape = parse_shape(shape_lines, false)

	var shape = []
	for row in raw_shape:
		var new_row = []
		for col in row:
			new_row.append(parsed.legend.get(col, col))
		shape.append(new_row)

	room["shape"] = shape
	return room

static func parse_rooms(parsed, chunks):
	var rooms = []
	for i in len(chunks):
		if i % 2 == 1:
			# only run evens
			continue
		var raw_meta = chunks[i]
		var shape_lines = chunks[i+1]
		rooms.append(parse_room(parsed, shape_lines, raw_meta))
	return rooms
