extends Control

signal back_to_player

var root

#### BUGS: #####

# The turns/damage phases are 'out of order.'
# Dead enemies still attack the player, somehow. 
# Message doesn't clear at the start of a new turn. 


func _ready():
	root = get_parent().get_parent()
	connect("back_to_player", root, "_on_resume")

func _on_log_entry(message, end_of_line : bool):
	self.show()
	$ColorRect/RichTextLabel.text += message 
	if end_of_line:
		$ColorRect/RichTextLabel.text += "\n"
	else:
		$ColorRect/RichTextLabel.text += " "
	_on_log_clear() #You need to clear logs whenever its the player's turn. 

func _on_log_clear():
	$Timer.start()
	yield($Timer, "timeout")
	self.hide()
	emit_signal("back_to_player")
	$ColorRect/RichTextLabel.text = "" 
