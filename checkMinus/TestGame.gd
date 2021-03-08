extends Node

var player

func _ready():
	$Dungeon.UI = $CanvasLayer/UI
	$Dungeon.Log = $CanvasLayer/Control

func _on_resume():
	player.set_process_input(true)
