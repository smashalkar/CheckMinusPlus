extends Node2D

enum {EMPTY, OBSTACLE, ACTIVE, ITEM, OBJECT, END}

var is_player = false
var exit_spawned = false #REMINDER: EXIT IS BUGGY!
#GAME BREAKS IF AN ITEM SPAWNS ON THE EXIT!

const Room = preload("res://WIP/Room.tscn")
const Enemy = preload("res://src/scenes/active/enemy.tscn") #WORK OUT MULTIPLE ENCOUNTERS
const Player = preload("res://src/scenes/active/player.tscn")
const Exit = preload("res://src/scenes/dungeon/exit.tscn")
const Item = preload("res://src/scenes/dungeon/item.tscn")

var item_count = 0
var enemy_count = 1

var shaunak_seed = 5

var player_check : bool = false
var exit_check : bool = false

onready var Map = $Generation

var tile_size = 64
var num_rooms

var grid_range = 9
var trueGridRange = ((grid_range * 32) + 60)
var halfGridRange = (grid_range * 16)
#Add 60 for the off-screen tiles!

var min_size = 6
var max_size = 9

var path

var start_room = null
var end_room = null

var player = null

func make_rooms():
	Map.hide()

	for x in range(trueGridRange):
		for y in range(trueGridRange):
			Map.set_cell(x - 174, y  - 174, OBSTACLE)

	for x in range(grid_range):
		for y in range(2):
			Map.set_cell(x + 1, y + 1, EMPTY)

	Map.show()
	
	"""
	player_check = false
	exit_check = false
	
	var pos_pos = []
	var w_w = []
	var h_h = []
	
	num_rooms = (randi()% 9 + 3)
	
	for _i in range(num_rooms):
		var w = min_size + uranium() % (max_size - min_size)
		var h = min_size + uranium() % (max_size - min_size)
		
		#pos_pos.append(pos)
		w_w.append(w)
		h_h.append(h)
		
	for i in range(num_rooms):
		var r = Room.instance()
		r.make_room(pos_pos[i], Vector2(w_w[i], h_h[i]) * tile_size)
		$Rooms.add_child(r)

	yield(get_tree().create_timer(1.5), 'timeout')

	var room_positions = []
	for room in $Rooms.get_children():
		room.mode = RigidBody2D.MODE_STATIC
		room_positions.append(Vector3(int(room.position.x) - (int(room.position.x)%4), int(room.position.y) - (int(room.position.y)%4), 0))
		room.position = Vector2(int(room.position.x) - (int(room.position.x)%4), int(room.position.y) - (int(room.position.y)%4))

	yield(get_tree(), 'idle_frame')

	path = find_mst(room_positions)
	make_map()

func find_mst(nodes):
	
	path = AStar.new()
	path.add_point(path.get_available_point_id(), nodes.pop_front())

	while nodes:
		var min_dist = INF 
		var min_p = null
		var p = null

		for p1 in path.get_points():
			p1 = path.get_point_position(p1)

			for p2 in nodes:
				if p1.distance_to(p2) < min_dist:
					min_dist = p1.distance_to(p2)
					min_p = p2
					p = p1

		var n = path.get_available_point_id()
		path.add_point(n, min_p)
		path.connect_points(path.get_closest_point(p), n)
		nodes.erase(min_p)
	return path

func make_map():
	Map.clear()

	for child in Map.get_children():
		child.queue_free()

	var full_rect = Rect2()
	for room in $Rooms.get_children():
		var r = Rect2(room.position-room.size, room.get_node("CollisionShape2D").shape.extents*2)
		full_rect = full_rect.merge(r)
	var topleft = Map.world_to_map(full_rect.position)
	var bottomright = Map.world_to_map(full_rect.end)

	for x in range(topleft.x - 25, bottomright.x + 25):
		for y in range(topleft.y - 20, bottomright.y + 20):
			Map.set_cell(x, y, OBSTACLE)

	var corridors = []

	start_room = $Rooms.get_child(uranium()% ($Rooms.get_child_count()))
	end_room = $Rooms.get_child(uranium()% ($Rooms.get_child_count()))

	start_room.start = true
	end_room.end = true
	
	for room in $Rooms.get_children():

		var s = (room.size / tile_size).floor()
		var ul = (room.position / tile_size).floor() - s
		var pos_pos = []

		for x in range(2, s.x * 2 - 1):
			for y in range(2, s.y * 2 - 1):
				Map.set_cell(ul.x + x, ul.y + y, EMPTY)
				pos_pos.append(Vector2(ul.x + x, ul.y + y))

		spawn(room, pos_pos)

		var p = path.get_closest_point(Vector3(room.position.x, room.position.y, 0))
		for conn in path.get_point_connections(p):
			if not conn in corridors:
				var start = Map.world_to_map(Vector2(path.get_point_position(p).x, path.get_point_position(p).y))
				var end = Map.world_to_map(Vector2(path.get_point_position(conn).x, path.get_point_position(conn).y))
				carve_path(start, end)
		corridors.append(p)
		Map.show()

func carve_path(pos1, pos2):
	var x_diff = sign(pos2.x - pos1.x)
	var y_diff = sign(pos2.y - pos1.y)
	if x_diff == 0: x_diff = pow(-1.0, uranium() % 2)
	if y_diff == 0: y_diff = pow(-1.0, uranium() % 2)

	var x_y = pos1
	var y_x = pos2
	if (uranium() % 2) > 0:
		x_y = pos2
		y_x = pos1
	for x in range(pos1.x, pos2.x, x_diff):
		Map.set_cell(x, x_y.y, EMPTY)
	for y in range(pos1.y, pos2.y, y_diff):
		Map.set_cell(y_x.x, y, EMPTY)
	
	for child in Map.get_children():
		Map.set_cellv(Map.world_to_map(child.position), child.type)

func spawn(room, pos_pos):
	#FUCK WITH THIS!
	var positions = []
	
	for _n in range(item_count + enemy_count + 2):
		var pos = pos_pos[(uranium()*2)%pos_pos.size()]
		if not pos in positions:
			positions.append(pos)
	
	for pos in positions:
		if room.start == true and player_check == false: 
			player_check = true
			pos = pos_pos[uranium()%pos_pos.size()]
			player = Player.instance()
			Map.add_child(player)
			player.connect("turn_end", Map, "on_turn_end")
			player.position = Map.map_to_world(pos)

		#Idea: Make it so that stairs cannot spawn on the border. 
		elif room.end == true and exit_check == false:
			exit_check = true
			pos = pos_pos[uranium()%pos_pos.size()]
			player = Exit.instance()
			Map.add_child(player)
			player.position = Map.map_to_world(pos)
		
		else:
			var type_type = uranium()%3
			
			if type_type == 1:
				var item = Item.instance()
				Map.add_child(item)
				item.position = Map.map_to_world(pos)
				#This line is necessary to avoid the phantom bug!
				Map.set_cellv(pos, item.type)
			
			else:
				var enemy = Enemy.instance()
				Map.add_child(enemy)
				enemy.position = Map.map_to_world(pos)
				enemy._init_texture()
				#This line is necessary to avoid the phantom bug!
				Map.set_cellv(pos, enemy.type)
"""
func uranium():
	shaunak_seed = ((shaunak_seed * 179) %  1111111111111111111)
	return shaunak_seed

