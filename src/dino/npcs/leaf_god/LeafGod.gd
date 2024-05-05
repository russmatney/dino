extends SideScrollerNPC

## vars ###########################################################

@onready var shop_ui = $%ShopUI
@onready var exit_button = $%ExitButton
@onready var exchange_button = $%ExchangeButton

var shopper

## ready ###########################################################

func _ready():
	super._ready()

	shop_ui.set_visible(false)

	exit_button.pressed.connect(stop_shopping)
	exchange_button.pressed.connect(exchange)

## actions ###########################################################

var actions = [
	Action.mk({
		label="Trade", fn=start_leaf_trade,
		source_can_exec=func(): return shopper == null,
		actor_can_exec=func(actor): return actor.is_in_group("player"),
		show_on_source=true, show_on_actor=false,
		}),
	]

## leaf trade ###########################################################

func start_leaf_trade(actor):
	shopper = actor
	start_shopping()

func start_shopping():
	# TODO pause other parts of the game (to prevent the player moving and/or being attacked)
	# TODO animate in
	machine.transit("Shop")
	shop_ui.set_visible(true)
	check_afford_exchange()
	exchange_button.grab_focus()

func stop_shopping():
	# TODO unpause
	# TODO animate out
	shop_ui.set_visible(false)
	shopper = null
	machine.transit("Idle")

## exchange ###########################################################

func check_afford_exchange():
	if shopper.leaves > 2:
		exchange_button.set_disabled(false)
	else:
		exchange_button.set_disabled(true)

func exchange():
	if not shopper:
		Log.warn("No shopper for leaf exchange!")

	shopper.spend_leaves(3)
	shopper.increase_base_health(2)
	shopper.recover_health()
	shopper.emit_heart_particle()
	Dino.notif({type="side", text="+1 Heart Container"})

	check_afford_exchange()
