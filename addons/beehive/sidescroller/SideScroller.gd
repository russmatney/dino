@tool
extends Node

## data ##########################################################

enum Powerup { Read, Sword, Flashlight, DoubleJump, Climb, Gun, Jetpack, Ascend, Descend }
var all_powerups = [
	Powerup.DoubleJump,
	Powerup.Climb,
	Powerup.Jetpack,
	Powerup.Flashlight,
	Powerup.Sword, Powerup.Gun,
	Powerup.Ascend, Powerup.Descend,
	]
