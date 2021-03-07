extends Control

onready var health_bar = $HPBar
onready var mana_bar = $MPBar

func health_change(health):
	health_bar.value = health

func mana_change(mana):
	mana_bar.value = mana

func max_health_change(max_health):
	health_bar.max_value = max_health

func max_mana_change(max_mana):
	mana_bar.max_value = max_mana
