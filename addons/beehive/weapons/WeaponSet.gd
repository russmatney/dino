extends Object
class_name WeaponSet

## vars/state ##################################

enum T {SideScroller, TopDown, BeatEmUp}
var type: T

var stack = []

signal changed_weapon(weapon)

## init ##################################

func _init(t):
	match t:
		"ss": type = T.SideScroller
		"td": type = T.TopDown
		"beu": type = T.BeatEmUp

## helpers ##################################

func weapon_for_id(id):
	for w in stack:
		if w.entity.get_entity_id() == id:
			return w

## public ##################################

func list():
	return stack

func add_weapon(ent_id):
	var existing = weapon_for_id(ent_id)
	if existing:
		add_weapon_to_stack(existing)
	else:
		var ent = Pandora.get_entity(ent_id)
		var scene
		match type:
			T.SideScroller: scene = ent.get_sidescroller_scene()
			T.TopDown: scene = ent.get_topdown_scene()
			T.BeatEmUp: scene = ent.get_beatemup_scene()
		var w = scene.instantiate()
		w.entity = ent
		add_weapon_to_stack(w)

		return w

func remove_weapon_by_id(ent_id):
	var weapon = weapon_for_id(ent_id)
	if weapon:
		drop_weapon(weapon)

func add_weapon_to_stack(weapon: Variant):
	if weapon in stack:
		stack.erase(weapon)

	stack.map(deactivate_weapon)
	stack.push_front(weapon)
	activate_weapon()

func has_weapon():
	return active_weapon() != null

func has_weapon_id(ent_id):
	return weapon_for_id(ent_id)

func active_weapon():
	if len(stack) > 0:
		return stack.front()

func aim_weapon(aim_vector):
	var w = active_weapon()
	if w:
		w.aim(aim_vector)

# Drops the first weapon if none is passed
func drop_weapon(weapon=null):
	if not weapon:
		weapon = active_weapon()
	if weapon in stack:
		stack.erase(weapon)
		return weapon

func cycle_weapon():
	if len(stack) > 1:
		stack.map(deactivate_weapon)
		var f = stack.pop_front()
		stack.push_back(f)
		activate_weapon()
		changed_weapon.emit(active_weapon())

func activate_weapon_with_entity(entity):
	var w = weapon_for_id(entity.get_entity_id())
	if w:
		activate_weapon(w)

# move the passed weapon to index 0, and call w.activate()
func activate_weapon(weapon=null):
	if not weapon:
		weapon = active_weapon()
	else:
		stack.erase(weapon)
		stack.push_front(weapon)
		(func(): changed_weapon.emit(active_weapon())).call_deferred()

	weapon.visible = true
	weapon.activate()

# turn off the flashlight, sheath the sword, holser the gun?
func deactivate_weapon(weapon=null):
	if not weapon:
		weapon = active_weapon()
	weapon.visible = false
	weapon.deactivate()

# Uses the first weapon if none is passed
func use_weapon(weapon=null):
	if not weapon:
		weapon = active_weapon()
	if weapon.visible == false:
		activate_weapon(weapon)
	weapon.use()

# i.e. button released, stop firing or whatever continuous action
func stop_using_weapon(weapon=null):
	if not weapon:
		weapon = active_weapon()
	weapon.stop_using()
