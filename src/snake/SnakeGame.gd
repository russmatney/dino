extends DinoGame

func start(_opts={}):
	var lvl = SnakeData.levels[0]
	Q.current_level_label = lvl.label
	Navi.nav_to(lvl.scene)
