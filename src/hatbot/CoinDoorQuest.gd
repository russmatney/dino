extends Node

# TODO what's the quest api again?
# feels like this kind of sibling-search and signal/wiring could be dried up

var coins = []
var door

#########################################################
# ready

func _ready():
	var p = get_parent()
	coins = []
	for ch in p.get_children():
		if ch.is_in_group("coins"):
			coins.append(ch)
			ch.on_collected.connect(_on_collected)

		if ch.is_in_group("doors"):
			door = ch

	if not door:
		Debug.warn("expected 'doors' node")

	if not len(coins):
		Debug.warn("no coins found")

#########################################################
# signal reactions

func _on_collected(coin):
	# TODO ascending sound here
	Debug.pr("coin collected", coin.hotel_data())
	# Hood.dev_notif("coin collected", coin.hotel_data())


#########################################################
# _process

func _process(_delta):
	# open if there are no coins
	if door.is_closed() and len(remaining_coins()) <= 0:
		door.open()

	# open if complete
	if complete and door.is_closed():
		door.open()

	if not complete:
		if len(remaining_coins()) <= 0 and seen_coins:
			complete = true
			Hood.notif("All coins found!")
			Debug.pr("All coins found!")
			door.open()
			var on_close = Hood.jumbo_notif({header="Door opening!", body="All coins found."})
			if on_close:
				if not Hood.is_connected("jumbo_closed", _on_close_respawn):
					on_close.connect(_on_close_respawn.bind(on_close))

func _on_close_respawn(on_close):
	on_close.disconnect(_on_close_respawn)


#########################################################
# remaining coins

var complete = false
var seen_coins = false

func remaining_coins():
	var remaining = coins.filter(func(c): return not c.collected)
	if not seen_coins and len(remaining) > 0:
		Debug.pr("We've seen some coins!")
		seen_coins = true
	return remaining

