extends "movement/TestMove.gd"

var input_direction
var attack_type

var alliance = 0

export var statbase : Resource

var id = "Main Guy"

signal turn_end
signal health_changed

var tempheal : bool = false
var UI

func pre_turn():
	pass

func _ready(): 
	UI = get_parent().UI
	get_node("Sprite").texture = load("res://assets/playable/player.png")
	$Stats.initialize(statbase)
	connect("health_changed", UI, "_on_update_health")
	health_mod()
	#Set UI to 'show' here!

func _input(_event): #SWITCH FROM INPUT BASED, SET PRIORITY IN STATS
	if move_detected():
		UI.show()
		input_direction = get_input_direction()
		
		if !Input.is_action_pressed("ui_select"):
			attack_type = null
			set_process_input(false)
		
		else:
			current_direction = input_direction
			input_direction = null
		
		$Stats.priority = 0
		if true:
			emit_signal("turn_end")
		else:
			set_process_input(true)
		
	if attack_detected(): #CLEAR PRIORITY
		attack_type = 1 #Change the type of number depending on the input!
		input_direction = null
		print("Attacked!")
		
		$Stats.priority = $Attacks.get_priority(attack_type)
		emit_signal("turn_end")
	
	
	
	if Input.is_action_just_pressed("ui_focus_next"):
		"""tempheal = true
		input_direction = null
		attack_type = null
		emit_signal("turn_end")"""
		toggle_menu()
	
	
	
func act():
	if attack_type != null:
		$Attacks.attack(attack_type)
		#MOVEMENT
		#pass
	
	if input_direction != null: 
		move(input_direction)
		set_process_input(true)
		#pass
	
	if tempheal:
		if $Inventory.current_item_count != 0:
			$Inventory.current_item_count -= 1
			if $Stats.health < 200:
				emit_signal("text_changed", "Used a Lube Berry! Healed 10HP!")
				$Stats.health += 10
			else:
				print("Used a Lube Berry! Already at max health!")
				$Stats.health += 10
			tempheal = false
		else:
			print("You don't have any berries to use!")

func on_death():
	print("Player died!")
	pass
	
func _on_incr_order():
	$UI.shift_state(0)

func move_detected():
	return Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right")

func run_detected():
	return Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")

func attack_detected():
	return Input.is_action_just_pressed("ui_accept")

func hit(dmg):
	$UI.health_change($Stats.health - dmg)
	$Stats.hit(dmg)

func health_mod():
	print("Mod called!")
	emit_signal("health_changed", $Stats.max_health, $Stats.health)

func toggle_menu():
	"""
	if $UI/FightMenu.open == false:
		set_process_input(false)
		$UI/FightMenu.show()
		$UI/FightMenu.open = true
	else:
		$UI/FightMenu.hide()
		$UI/FightMenu.open = false
		set_process_input(true)
"""
	pass
