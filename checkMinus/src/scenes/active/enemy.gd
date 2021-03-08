extends "movement/TestMove.gd"

var basicMove = null

var vision_grid

var input_direction
var attack_type

export var statbase : Resource

var enemyType = 0

#signal incr_order
var Map
var alliance = 1

var asleep : bool
var move_style : int

var noise_range = 3
var attk_range = 1
var id
var Log

var target = null

signal log_active

func _ready():
	Map = get_parent()
	Log = get_parent().Log
	$Stats.initialize(statbase)
	asleep = true

	connect("log_active", Log, "_on_log_entry")
	
func _init_texture():
		
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	enemyType = rng.randi() % 2
	
	if enemyType == 1:
		get_node("Sprite").texture = load("res://assets/enemy/rat.png")
		id = "Rat"
		$Stats.id = "Rat"

	else:
		get_node("Sprite").texture = load("res://assets/enemy/squito.png")
		id = "Mosquito"
		$Stats.id = "Mosquito"

func pre_turn():
	if asleep == true: 
		if find_player(noise_range):
			emit_signal("log_active", "%s woke up!" % [$Stats.id], true)
			asleep = false
	return null

func act():
	pass
	if !asleep:
		if find_player(attk_range):
			new_direction()
			emit_signal("log_active", "%s attacked!" % [id], false)
			$Attacks.attack(1)
			

		elif find_player(noise_range):
			new_direction()
			#if (self.current_direction + play_dir == Vector2(0, 0)):
			move(self.current_direction)
		
		else:
			if randi()%100 > 85:
				print("%s went back to sleep!" % [id])
				asleep = true
			else:
				print("%s is idling!" % [id])


func on_death():
	emit_signal("log_active", $Stats.id + " fainted!", true)
	self.queue_free()
	Grid.set_cellv(self.position, CELL_TYPES.EMPTY)
	Grid.re_order()

func find_player(hit_range):
	for i in range(hit_range + hit_range + 1):
					for j in range(hit_range + hit_range + 1):
						if (i != hit_range) or (j != hit_range):
							var in_front = Grid.get_cell_content(Map.world_to_map(self.position) + Vector2(i - hit_range, j - hit_range))
							if in_front != null:
								if in_front.type == CELL_TYPES.ACTIVE:
									if in_front.alliance != self.alliance:
										target = in_front
										return true

func move_to_mc():
	pass

func new_direction():
	if target == null:
		return

	else:
		if target.position.x > self.position.x:
			self.current_direction.x = 1
		elif target.position.x < self.position.x:
			self.current_direction.x = -1
		else:
			self.current_direction.x = 0
			
		if target.position.y > self.position.y:
			self.current_direction.y = 1
		elif target.position.y < self.position.y:
			self.current_direction.y = -1
		else:
			self.current_direction.y = 0
		#print(self.current_direction)
		
		"""
		for x in range(2):
			for y in range(2):
				if x != 1 or y != 1:
					#print(Vector2(x, y))
"""

func hit(dmg):
	emit_signal("log_active", id + " took " + String(dmg) + " damage!", true)
	$Stats.hit(dmg)
