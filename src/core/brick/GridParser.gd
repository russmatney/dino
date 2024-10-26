@tool
extends Object
class_name GridParser

## public types #####################################################

class GridParserOpts:
	extends Object

	# all optional
	var parsed_room_defs: GridDefs
	var defs_path: String
	var contents: String

	func _init(opts):
		parsed_room_defs = opts.get("parsed_room_defs")

		if opts.get("defs_path"):
			defs_path = opts.get("defs_path")
		if opts.get("contents"):
			contents = opts.get("contents")

	func to_printable():
		return {
			# parsed_room_defs=parsed_room_defs,
			defs_path=defs_path,
			# contents=contents,
			}

## public api #####################################################

# Returns a GridDefs with GridDef(s) and other metadata
static func parse(opts: Dictionary={}) -> GridDefs:
	var rp_opts = GridParserOpts.new(opts)

	# kind of odd... some caching convenience use-case?
	if rp_opts.parsed_room_defs:
		return rp_opts.parsed_room_defs

	var grid_defs = GridDefs.new()

	var contents = rp_opts.contents
	if not contents:
		var path = rp_opts.defs_path
		if not path:
			Log.err("Cannot parse, no defs_path", rp_opts)
			return null
		if not FileAccess.file_exists(path):
			Log.err("Cannot parse defs_path, file does not exist", rp_opts)
			return null
		grid_defs.path = path
		var file = FileAccess.open(path, FileAccess.READ)
		contents = file.get_as_text()

	var parsed = GridParser.parse_raw(contents)

	grid_defs.prelude = parsed.prelude
	if "name" in grid_defs.prelude:
		grid_defs.name = grid_defs.prelude.name
	grid_defs.legend = parsed.legend

	var grids: Array[GridDef] = []
	var to_parse = []
	if "rooms" in parsed:
		to_parse = parsed.rooms
	elif "entities" in parsed:
		to_parse = parsed.entities
	elif "chunks" in parsed:
		to_parse = parsed.chunks
	for r in to_parse:
		var def = GridDef.new()
		def.meta = r.duplicate(true)
		def.meta.erase("shape")

		var n = def.meta.get("name", def.meta.get("room_name"))
		if n != null:
			def.name = n

		var shape = []
		for row in r.get("shape"):
			var new_row = []
			for cell in row:
				var val = parsed.legend.get(cell)
				if val == null:
					if cell != ".":
						Log.warn("Grid parser found val without matching legend entry", cell)
						val = [cell]
				new_row.append(val)
			shape.append(new_row)
		def.shape = shape

		grids.append(def)

	if len(grids) > 0:
		grid_defs.grids = grids
	else:
		Log.warn("No grids parsed in GridParser!", opts)

	return grid_defs

## parser #####################################################

# returns a Dictionary with nothing fancy, just plain types
static func parse_raw(contents) -> Dictionary:
	var parsed = {}
	var section_parsers = {
		"prelude": GridParser.parse_prelude,
		"legend": GridParser.parse_legend,
		"rooms": GridParser.parse_grids,
		"chunks": GridParser.parse_grids,
		"entities": GridParser.parse_grids,
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
				return Array(chunk).filter(func(c):
					return c != "" and c != "\t" and c != "\t\t" and c != "\t\t\t")
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

static func parse_shape(lines):
	var shape = []
	for l in lines:
		var row = []
		for c in l:
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

## grids #########################################################

static func parse_grid(shape_lines, raw_meta):
	var grid = parse_metadata(raw_meta)
	var raw_shape = parse_shape(shape_lines)

	grid["shape"] = raw_shape
	# maybe want to optimize away from this?
	return grid.duplicate(true)

static func parse_grids(chunks):
	var grids = []
	for i in len(chunks):
		if i % 2 == 1:
			# only run evens
			continue
		var raw_meta = chunks[i]
		var shape_lines = chunks[i+1]
		grids.append(parse_grid(shape_lines, raw_meta))
	return grids
