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
	Debug.pr("coin collected", coin.hotel_data())
	Hood.dev_notif("coin collected", coin.hotel_data())


#########################################################
# _process

func _process(_delta):
	if not complete:
		if len(remaining_coins()) <= 0 and seen_coins:
			complete = true
			Hood.notif("All coins found!")
			Debug.pr("All coins found!")
			var on_close = Hood.jumbo_notif({header="All coins found!"})
			if on_close:
				on_close.connect(door.open)


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

