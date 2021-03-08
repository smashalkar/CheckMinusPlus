extends Control

func _on_update_health(max_health : int, health : int):
	$MarginContainer/VBoxContainer/Bars/HP.max_value = max_health
	$MarginContainer/VBoxContainer/Bars/HP.value = health

func _on_update_mana(max_mana : int, mana : int):
	$MarginContainer/VBoxContainer/Bars/MP.max_value = max_mana
	$MarginContainer/VBoxContainer/Bars/MP.value = mana

func _on_active_menu():
	self.show()
	$FightMenu.show()
	$FightMenu.open = true

func set_level(number : int):
	$MarginContainer/VBoxContainer/TestInfo/MarginContainer/NinePatchRect/Label.text = "B" + String(number) + "F"
