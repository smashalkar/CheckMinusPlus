extends TileMap

enum {VOID = -1, EMPTY, OBSTACLE, ACTIVE, ITEM, OBJECT, END}
enum {LINE_OF_SIGHT, ON_GRID}

var play_range = 128
var vision_range = 16

onready 	var Map = get_parent().get_node("Generation")


func on_draw_grid(pos, direction):
	var target_cell
	
	for x in range(play_range):
		for y in range(play_range):
			target_cell = pos - Vector2(x - 64, y - 64)
			if Map.get_cellv(target_cell) == EMPTY:
				set_cellv(target_cell, ON_GRID)
				print(target_cell)
				#print(get_cell)
	
	for x in range(vision_range):
		for y in range(vision_range):
			if Map.get_cellv(target_cell) == EMPTY:
				set_cellv(target_cell, LINE_OF_SIGHT)
