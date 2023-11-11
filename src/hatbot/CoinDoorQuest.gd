extends Node

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
		Log.warn("expected 'doors' node")

	if not len(coins):
		Log.warn("no coins found")

#########################################################
# signal reactions

func _on_collected(coin):
	Log.pr("coin collected", coin.hotel_data())
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
			Log.pr("All coins found!")
			door.open()
			var on_close = Jumbotron.jumbo_notif({header="Door opening!", body="All coins found."})
			if on_close:
				if not Q.jumbo_closed.is_connected(_on_close_respawn):
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
		Log.pr("We've seen some coins!")
		seen_coins = true
	return remaining

