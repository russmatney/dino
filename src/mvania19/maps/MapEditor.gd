@tool
extends Node2D

func prn(msg, msg2=null, msg3=null):
	if msg3:
		print("[Mvania MapEditor]: ", msg, msg2, msg3)
	elif msg2:
		print("[Mvania MapEditor]: ", msg, msg2)
	else:
		print("[Mvania MapEditor]: ", msg)


# func persist_room(room):
# 	var area = {
# 		"name": name
# 		}
