extends "movement/TestMove.gd"

var input_direction
var attack_type

var alliance = 0

export var statbase : Resource

var id = "Main Guy"

signal turn_end
signal health_changed
signal mana_changed
signal menu_active
signal log_active

var tempheal : bool = false
var UI
var Log
var menuOpen = false

func pre_turn():
	pass

func _ready(): 
	UI = get_parent().UI
	Log = get_parent().Log

	get_node("Sprite").texture = load("res://assets/playable/player.png")
	$Stats.initialize(statbase)
	
	connect("health_changed", UI, "_on_update_health")
	connect("mana_changed", UI, "_on_update_mana")
	connect("menu_active", UI, "_on_active_menu")
	connect("log_active", Log, "_on_log_entry")
	
	UI.get_parent().get_parent().player = self
	ui_update()

func _input(_event): #SWITCH FROM INPUT BASED, SET PRIORITY IN STATS
	if move_detected():
		UI.show()
		input_direction = get_input_direction()
		$Stats.health_change(true, 1)
		ui_update()

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
		set_process_input(false)
		#ONLY PRINT THIS LINE IF IT HITS!
		emit_signal("log_active", id + " attacked!", false)
		
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
	emit_signal("log_active", id + " took " + String(dmg) + " damage!", true)
	$Stats.hit(dmg)
	ui_update()

func ui_update():
	emit_signal("health_changed", $Stats.max_health, $Stats.health)
	emit_signal("mana_changed", $Stats.max_mana, $Stats.mana)

func _on_return():
	set_process_input(true)

func toggle_menu():
	if menuOpen == false:
		set_process_input(false)
		emit_signal("menu_active")
	else:
		emit_signal("menu_active")
		set_process_input(true)
