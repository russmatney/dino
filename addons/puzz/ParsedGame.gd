@tool
extends Object
class_name ParsedGame

var section_parsers = {
	"prelude": parse_prelude,
	"objects": parse_objects,
	"legend": parse_legend,
	"sounds": parse_sounds,
	"collisionlayers": parse_collision_layers,
	"rules": parse_rules,
	"winconditions": parse_win_conditions,
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

func parse_shape(lines, parse_int=true):
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

## legend #########################################################

func parse_legend(chunks):
	var legend = {}
	for lines in chunks:
		for l in lines:
			var parts = l.split(" = ")
			# support 'or' ?
			var val_parts = parts[1].split(" and ")
			legend[parts[0]] = Array(val_parts)

	return legend

## sounds #########################################################

func parse_sounds(chunks):
	var sounds = []
	for lines in chunks:
		for l in lines:
			var parts = l.split(" ")
			sounds.append(Array(parts))
	return sounds

## collision_layers #########################################################

func parse_collision_layers(chunks):
	var layers = []
	for lines in chunks:
		for l in lines:
			var parts = l.split(", ")
			layers.append(Array(parts))
	return layers

## rules #########################################################

func parse_rules(chunks):
	var rules = []
	for lines in chunks:
		for l in lines:
			var parts = l.split(" -> ")
			var new_rule = {pattern=parse_pattern(parts[0])}
			if len(parts) > 1:
				new_rule["update"] = parse_pattern(parts[1])
			rules.append(new_rule)
	return rules

func parse_pattern(rule_pattern_str):
	var initial_terms = []
	# initial terms
	if not rule_pattern_str.begins_with("["):
		var parts = rule_pattern_str.split(" ")
		for p in parts:
			if p.begins_with("["):
				break
			else:
				initial_terms.append(p)

	# parse between the brackets
	var regex = RegEx.new()
	regex.compile("\\[\\s*(.*)\\s*\\]")
	var res = regex.search(rule_pattern_str)

	if res == null:
		return initial_terms

	var inner = res.get_string(1)

	var inner_cells = inner.split(" | ")
	var cells = []
	for c in inner_cells:
		var parts = c.split(" ")
		var cell = []
		for p in parts:
			if len(p) > 0:
				cell.append(p)
		cells.append(cell)

	var pattern = []
	pattern.append_array(initial_terms)
	pattern.append_array(cells)
	return pattern

## win_conditions #########################################################

func parse_win_conditions(chunks):
	var conds = []
	for lines in chunks:
		for l in lines:
			var parts = l.split(" ")
			conds.append(Array(parts))
	return conds

## levels #########################################################

func parse_level(lines, msg=null):
	var lvl = {}
	if msg != null:
		lvl["message"] = msg
	lvl["shape"] = parse_shape(lines, false)
	return lvl

func parse_levels(chunks):
	var levels = []
	var msg
	for lines in chunks:
		lines = (lines as Array).filter(func(l): return not l == "")
		if lines.size() == 1:
			var parts = lines[0].split(" ", true, 1)
			msg = parts[1]
		else:
			levels.append(parse_level(lines, msg))
			msg = null
	if msg != null:
		# add final message as new level?
		levels.append({message=msg, shape=null})
	return levels
