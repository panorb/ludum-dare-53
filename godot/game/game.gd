extends Node2D

@onready var battle_field = get_node('BattleField')

func _ready():
	battle_field.win.connect(_on_lose)
	
func _on_lose():
	print_debug("Lose")
	
func _on_win():
	print_debug("Win")
