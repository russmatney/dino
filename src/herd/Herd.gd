@tool
extends DinoGame

## level mgmt #####################################################

func start(_opts={}):
	Navi.nav_to(HerdData.levels[0])
