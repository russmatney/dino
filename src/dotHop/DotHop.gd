@tool
extends DinoGame

var game_scene = "res://src/dotHop/DotHopGame.tscn"

func start(opts={}):
	var g = load(game_scene).instantiate()
	g.puzzle_set = opts.get("puzzle_set", Pandora.get_entity(DhPuzzleSet.ONE))
	Navi.nav_to(g)

# TODO remove in favor of a shared event bus
var game
func register_game(g):
	game = g

var current_theme
func change_theme(theme):
	if current_theme != theme:
		current_theme = theme
		if game != null:
			game.puzzle_theme = theme
			game.load_theme()
			# TODO maintain current puzzle state?
			game.rebuild_puzzle()
