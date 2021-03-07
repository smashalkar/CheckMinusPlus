extends Node


var MAX_ITEM_COUNT : int = 5
const MAX_ITEM_TYPE = 3


var item_stack : Array = [0, 0, 0]
var current_item_count : int = 0

var obtain_order = []

const ITEM_ID = {
0 : "LubeBerry", 1 : "StrangeOrb", 3 : "JudgeOfTheDead"
}

const ITEM_NAME = {
0 : "Lube Berry", 1 : "Strange Orb", 3 : "Judge Of The Dead"
}

func _ready():
	if item_stack == null:
		for i in MAX_ITEM_TYPE: #FIX THIS! INITIALIZE THE ARRAY PROPERLY!
			item_stack[i] = 0
	for i in item_stack:
		current_item_count += item_stack[i]

func add_item(item_id):	#FIX FULL STSCK CONDITION 
	if current_item_count < MAX_ITEM_COUNT:
		item_stack[item_id] += 1
		if not (item_id in obtain_order):
			obtain_order.append(item_id)
		current_item_count += 1
		return true
	else: 
		print("Stack full! Now what? I wish you coded this part.")
		return false

func use_item(item : int):
	print("%s used %s!" % [get_parent().get_node("Stats").id, ITEM_ID[item]])
	funcref(self, ITEM_ID[item]).call_func()

func LubeBerry():
	print("Lube Berry would've restored 10HP... IF YOU FUCKING CODED IT IN!")

func StrangeOrb():
	print("Strange Orb would've done something weird... IF YOU FUCKING CODED IT IN!")

func JudgeOfTheDead():
	print("Judge of the Dead would've nuked the screen... IF YOU FUCKING CODED IT IN!")
