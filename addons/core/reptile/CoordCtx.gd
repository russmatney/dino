@tool
class_name CoordCtx
extends Object

var group
var coord: Vector2
var normed: float
var img: Image


func _init(g = null,c = null,n = null,i = null):
	group = g
	coord = c
	normed = n
	img = i
