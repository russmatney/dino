@tool
extends Node
class_name SSData

## data ##########################################################

enum Powerup { Read, Sword, Flashlight, DoubleJump, Climb, Gun, Jetpack, Ascend, Descend }
static var all_powerups = [
	Powerup.DoubleJump,
	Powerup.Climb,
	Powerup.Jetpack,
	Powerup.Flashlight,
	Powerup.Sword, Powerup.Gun,
	Powerup.Ascend, Powerup.Descend,
	]
