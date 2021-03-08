extends Control

onready var select1 = $Control/CenterContainer/VBoxContainer/Attack/Hbox/Label
onready var select2 = $Control/CenterContainer/VBoxContainer/Items/Hbox/Label
onready var select3 = $Control/CenterContainer/VBoxContainer/Other/Hbox/Label

var option_no = 0
var open : bool = false
var root

signal back_to_player


func _ready():
	root = get_parent().get_parent().get_parent()
	connect("back_to_player", root, "_on_resume")
	set_select()
	
	#### USE THIS TO MAKE AN ATTACK MENU AND AN ITEM MENU ###
	$Control/CenterContainer/VBoxContainer/Attack/Hbox/Label2.text = "Attack"
	$Control/CenterContainer/VBoxContainer/Items/Hbox/Label2.text = "Items"
	##### WHEEEEE #####


func _input(_event):
	if open == false and !Input.is_action_pressed("ui_focus_next"):
		set_select()
	
	if open == true:
		if Input.is_action_just_pressed("ui_down"):
			if option_no == 2:
				option_no = 0
			else:
				option_no += 1
			set_select()

		if Input.is_action_just_pressed("ui_up"):
			if option_no == 0:
				option_no = 2
			else:
				option_no -= 1
			set_select()
	
	if Input.is_action_just_pressed("ui_focus_next") and open == true:
		open = false
		self.hide()
		emit_signal("back_to_player")

func set_select():
	select1.text = ""
	select2.text = ""
	select3.text = ""
	
	if option_no == 0:
		select1.text = ">"
		select2.text = ""
		select3.text = ""
	
	if option_no == 1:
		select1.text = ""
		select2.text = ">"
		select3.text = ""
	
	if option_no == 2:
		select1.text = ""
		select2.text = ""
		select3.text = ">"
