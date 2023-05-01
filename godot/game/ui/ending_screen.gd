extends Control

@onready var label = get_node("%Label")

func initialize(text : String):
	label.text = text + "\n(You can close the game now.)"
