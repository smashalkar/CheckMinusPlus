extends Node2D

var level : int = 1

"""
func _ready():
	#randomize()
	make_rooms()
"""

func _on_Generation_level_end():
	print("Level clear!")
	#make_rooms()

