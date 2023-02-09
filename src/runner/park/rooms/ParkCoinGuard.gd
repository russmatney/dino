@tool
# ParkCoinGuard
extends RunnerRoom


func is_finished():
	return player and player.coins >= 4
