extends NPC

## vars ###########################################################

@onready var shop_ui = $%ShopUI
@onready var exit_button = $%ExitButton
@onready var exchange_button = $%ExchangeButton

## ready ###########################################################

func _ready():
	super._ready()

	shop_ui.set_visible(false)

	exit_button.pressed.connect(func():
		fade_out_shop()
		machine.transit("Idle"))
	exchange_button.pressed.connect(func():
		Log.pr("leaf god exchange not implemented!")
		Dino.notif({type="side", text="Not yet implemented!!"}))

## actions ###########################################################

var actions = [
	Action.mk({
		label="Trade", fn=start_leaf_trade,
		show_on_source=true, show_on_actor=false,
		}),
	]

## leaf trade ###########################################################

func start_leaf_trade(_actor):
	machine.transit("Shop")
	fade_in_shop()
	exchange_button.grab_focus()

func fade_in_shop():
	# TODO animate in
	shop_ui.set_visible(true)

func fade_out_shop():
	# TODO animate out
	shop_ui.set_visible(false)
