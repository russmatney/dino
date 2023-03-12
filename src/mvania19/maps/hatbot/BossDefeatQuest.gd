extends Control

var room

#####################################################
# bosses

var bosses = []

func reset_bosses():
	bosses = []
	for sib in Util.each_sibling(self):
		if sib.is_in_group("bosses"):
			bosses.append(sib)

	for boss in bosses:
		boss.died.connect(_on_boss_death)

	if len(bosses) > 0:
		Debug.pr("found bosses!", bosses)

func remaining_bosses():
	if len(bosses) == 0:
		return null
	return bosses.filter(func(b): return not b in defeated_bosses)

#####################################################
# ready

func _ready():
	Debug.pr("Boss Defeat Quest ready!")
	reset_bosses()

	var r = get_parent()
	if r is MvaniaRoom:
		room = r

var defeated_bosses = []

func _on_boss_death(boss):
	Debug.pr("Boss defeated", boss)
	Hood.dev_notif("Boss defeated", boss)
	defeated_bosses.append(boss)

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
	Debug.pr("Boss quest complete!")
	complete = true

	if room:
		room.pause()
	var on_close = Hood.jumbo_notif({
		header="Boss Defeated",
		body="You defeated [jump]%s[/jump]" % " and ".join(defeated_bosses.map(func(b): return b.name.capitalize()))
		})
	on_close.connect(func(): if room:
		room.unpause())
