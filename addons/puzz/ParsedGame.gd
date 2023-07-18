@tool
extends Object
class_name ParsedGame

var section_parsers = {
	"prelude": parse_prelude,
	"objects": parse_objects,
	"legend": parse_legend,
	"sounds": parse_sounds,
	"collision_layers": parse_collision_layers,
	"rules": parse_rules,
	"win_conditions": parse_win_conditions,
	"levels": parse_levels,
	}

func parse(contents):
	var parsed = {}

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
			parsed[header.to_lower()] = parser.call(chunks)
	return parsed

## prelude #########################################################

func parse_prelude(chunks):
	var lines = chunks.reduce(func(acc, x):
		acc.append_array(x)
		# fking update-in-place with no return bs
		return acc, [])
	var prelude = {}
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
		prelude[key] = val
	return prelude

## objects #########################################################

func parse_objects(chunks):
	var objs = {}
	for lines in chunks:
		var obj = {}
		var nm_parts = lines[0].split(" ")
		obj.name = nm_parts[0]
		if nm_parts.size() > 1:
			obj.symbol = nm_parts[1]
		obj.colors = Array(lines[1].split(" "))
		if lines.size() > 2:
			lines.remove_at(0)
			lines.remove_at(0)
			obj.shape = parse_shape(lines)

		objs[obj.name] = obj

	return objs

func parse_shape(lines):
	var shape = []
	for l in lines:
		var row = []
		for c in l:
			if c == ".":
				row.append(null)
			else:
				row.append(int(c))
		shape.append(row)
	return shape

## legend #########################################################

func parse_legend(chunks):
	var legend = {}
	for lines in chunks:
		for l in lines:
			var parts = l.split(" = ")
			# TODO support 'or' ?
			var val_parts = parts[1].split(" and ")
			legend[parts[0]] = Array(val_parts)

	return legend

## sounds #########################################################

func parse_sounds(chunks):
	return {}

## collision_layers #########################################################

func parse_collision_layers(chunks):
	return {}

## rules #########################################################

func parse_rules(chunks):
	return {}

## win_conditions #########################################################

func parse_win_conditions(chunks):
	return {}

## levels #########################################################

func parse_levels(chunks):
	return {}
