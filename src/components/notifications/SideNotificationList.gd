extends CanvasLayer

## vars ###########################################

@onready var slots = [
	$%SideNotification1,
	$%SideNotification2,
	$%SideNotification3,
	$%SideNotification4,
	$%SideNotification5,
	$%SideNotification6,
	]

## _ready ########################################

func _ready():
	for slot in slots:
		slot.cleared.connect(on_slot_cleared)

	Dino.notification.connect(func(notif):
		if notif.get("type") == "side":
			render_notif(notif))

## input ########################################
# useful for local testing
# func _unhandled_input(event):
# 	if Trolls.is_action(event):
# 		Dino.notif({
# 			type="side",
# 			text="New misc Notif!!",
# 			})

# 	if Trolls.is_jump(event):
# 		Dino.notif({
# 			type="side",
# 			text="New jump Notif!!",
# 			id="jump-notif"
# 			})

## queue ########################################

var queued = []

func render_notif(notif: Dictionary):
	var slot

	# pick slot for 'id'
	if notif.get("id"):
		for s in slots:
			if s.get_id() == notif.get("id"):
				slot = s

	# pick first available slot
	if not slot:
		for s in slots:
			if s.is_available():
				slot = s
				break

	if not slot:
		# no slot available, queue for later
		queued.append(notif)
		return

	# go for it
	slot.render(notif)

## on_slot_cleared ########################################

func on_slot_cleared():
	if not queued.is_empty():
		var notif = queued[0]
		queued.erase(notif)
		render_notif(notif)
