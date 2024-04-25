extends PanelContainer

## vars ###########################################

var opts

@onready var label: RichTextLabel = $%SideNotifLabel
@onready var texture: TextureRect = $%SideNotifTexture

var clear_tween: Tween

## signals ###########################################

signal cleared

## _ready ########################################

func _ready():
	pass

## render ########################################

func render(options: Dictionary):
	opts = options
	Log.pr("rendering notif", opts)

	# set label
	var text = opts.get("text")
	if text:
		label.set_text(text)

	# set icon
	var icon = opts.get("icon")
	if icon:
		texture.set_texture(icon)

	# set clear ttl
	if clear_tween:
		clear_tween.kill()
	var ttl = opts.get("ttl", 3.0)
	clear_tween = create_tween()
	clear_tween.tween_callback(clear).set_delay(ttl)

	# TODO emphasize if already exists
	# TODO animate entry

## clear ########################################

func clear():
	opts = null
	clear_tween = null # necessary?

	# TODO animate exit
	label.set_text("")

	cleared.emit()


## get_id ########################################

func get_id():
	if opts:
		return opts.get("id")

## is_available ########################################

func is_available() -> bool:
	return opts == null
