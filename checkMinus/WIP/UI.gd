extends Control

"""
func health_change(health):
	$Stats.health_change(health)

func mana_change(mana):
	$Stats.mana_change(mana)

func max_health_change(max_health):
	$Stats.max_health_change(max_health)

func max_mana_change(max_mana):
	$Stats.max_mana_change(max_mana)

func toggle_menu():
	get_parent().toggle_menu()
"""

func set_level(number : int):
	$MarginContainer/VBoxContainer/TestInfo/MarginContainer/NinePatchRect/Label.text = "B" + String(number) + "F"
