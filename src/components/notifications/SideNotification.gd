extends PanelContainer

## vars ###########################################

var opts

@onready var label: RichTextLabel = $%SideNotifLabel
@onready var texture: TextureRect = $%SideNotifTexture

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

	# TODO animate entry
	# TODO set ttl or reset + emphasize
	# TODO animate exit
	# TODO emit cleared

## get_id ########################################

func get_id():
	if opts:
		return opts.get("id")

## is_available ########################################

func is_available() -> bool:
	return opts == null
