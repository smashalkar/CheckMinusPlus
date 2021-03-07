extends Node2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	shift_state(0)
	pass # Replace with function body.

func shift_state(state):
	if state == 0:
		get_node("entry3").visible = true
		get_node("entry2").visible = false
		get_node("entry1").visible = false
		
	elif state == 1:
		get_node("entry3").visible = false
		get_node("entry2").visible = true
		get_node("entry1").visible = false
		
	elif state == 2:
		get_node("entry3").visible = false
		get_node("entry2").visible = false
		get_node("entry1").visible = true
		
	elif state == 3:
		get_node("entry3").visible = false
		get_node("entry2").visible = true
		get_node("entry1").visible = true
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
