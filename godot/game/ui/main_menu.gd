extends Control

@onready var start_button = get_node("%StartButton")
@onready var exit_button = get_node("%ExitButton")

signal transition_to(scene_name : String)

func _ready():
	start_button.pressed.connect(_on_start_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

func _on_start_button_pressed():
	transition_to.emit("game")

func _on_exit_button_pressed():
	get_tree().quit()
