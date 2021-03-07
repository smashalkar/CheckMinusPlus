extends "genFunc.gd"

var level : int = 1
const LEVEL_MAX = 15

var UI #VALUE PASSED TILL HERE!

func _ready():
	#randomize()
	UI = get_parent().get_node("CanvasLayer/UI")
	$Generation.UI = UI
	make_rooms()

func _on_Generation_level_end():
	print("Level clear!")
	UI.hide()
	level += 1
	get_parent().get_node("CanvasLayer/UI").set_level(level)
	if level <= LEVEL_MAX:
		make_rooms()
	else:
		print("Game clear! Thanks for watching!")
		pass #RUN A THING TO FINISH THE DUNGEON
