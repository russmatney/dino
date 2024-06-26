extends Control

var room

#####################################################
# bosses

var bosses = []

func reset_bosses():
	bosses = []
	for sib in U.each_sibling(self):
		if sib.is_in_group("bosses"):
			bosses.append(sib)

func remaining_bosses():
	if len(bosses) == 0:
		return null
	return bosses.filter(func(b): return not b.is_dead)

#####################################################
# ready

func _ready():
	reset_bosses()

	var r = get_parent()
	if r is MetroRoom:
		room = r

#####################################################
# process

var complete

func _process(_delta):
	var remaining = remaining_bosses()
	if not complete and remaining != null and len(remaining) == 0:
		quest_complete()

#####################################################
# quest_complete

func quest_complete():
	complete = true

	var header = "Boss Defeated"
	var body = "You defeated [jump]%s[/jump]" % " and ".join(bosses.map(func(b): return b.name.capitalize()))
	var action
	var action_label_text

	if len(bosses) == 1 and bosses[0].name == "Beefstronaut":
		header = "That was a beefy one."
		body = "Maybe this will make things more interesting?"
		action = "slowmo"
		action_label_text = "Slow-down Time"
	elif len(bosses) == 1 and bosses[0].name == "Monstroar":
		header = "Monstroar has been silenced!"
		body = "More crunch? Spam 'e' for shake!"
		action = "action"
		action_label_text = "Add Screen Shake"
	elif len(bosses) == 2:
		header = "YOU DID IT! CONGRATS!"
		body = "Debug tool secret unlocked!"
		action = "debug_toggle"
		action_label_text = "Show the debug menu"

	if room:
		room.pause()

	Jumbotron.jumbo_notif({
		header=header, body=body, action=action,
		action_label_text=action_label_text,
		on_close=func():
		if room:
			room.unpause()
		})
