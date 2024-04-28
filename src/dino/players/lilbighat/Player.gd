@tool
extends SSPlayer

## ready ##################################################################

func _ready():
	if not Engine.is_editor_hint():
		died.connect(func(): stamp({ttl=0})) # perma stamp

	super._ready()

func _on_transit(state):
	if state in ["Fall", "Run"]:
		stamp()

