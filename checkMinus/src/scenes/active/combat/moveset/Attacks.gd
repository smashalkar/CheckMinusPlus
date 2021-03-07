extends Node

var Grid
var user

export var MoveOne : Resource
export var MoveTwo : Resource
export var MoveThree : Resource
export var MoveFour : Resource


func _ready():
	#$Basic.initialize(get_parent().basicMove)
	var usr_name = get_parent().id
	#var user = get_parent()
	$Special1.initialize(usr_name, MoveOne)
	$Special2.initialize(usr_name, MoveTwo)
	$Special3.initialize(usr_name, MoveThree)
	$Special4.initialize(usr_name, MoveFour)

#Hello Development Heck! 
#I was hoping you could connect this function to a menu. 
#Button inputs are a fuck. Feel free to mess with Basic/Special if you need to do so.  
func get_priority(_attack):
	return 1 #This needs to be fixed to return per-attack priority
	#This will involve something similar to attack() - which also needs fixing!

func attack(index):
	if (index % 5) == 0:
		$Basic.effect(Grid, user)
	if (index % 5) == 1:
		$Special1.effect(Grid, user)
	if (index % 5) == 2:
		$Special2.effect(Grid, user)
	if (index % 5) == 3:
		$Special3.effect(Grid, user)
	if (index % 5) == 4:
		$Special3.effect(Grid, user)
