extends Control

onready var select1 = $Control/CenterContainer/VBoxContainer/Attack/Hbox/Label
onready var select2 = $Control/CenterContainer/VBoxContainer/Items/Hbox/Label
onready var select3 = $Control/CenterContainer/VBoxContainer/Other/Hbox/Label

var option_no
var open : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	option_no = 0
	set_select()
	pass # Replace with function body.

func _input(_event):
	if open == false and !Input.is_action_pressed("ui_focus_next"):
		option_no = 0
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
		option_no = 0
		get_parent().toggle_menu()

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
