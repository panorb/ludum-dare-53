extends Node2D

var globals = preload("res://autoloads/globals.gd")

@onready var cave = get_node('Cave')
@onready var card_spawner = get_node('CardSpawner')
@onready var battle_field = get_node('BattleField')
@onready var balloon = get_node('Balloon')

func _ready():
	cave.position.y = -globals.SCREEN_HEIGHT
	battle_field.position.y = -globals.SCREEN_HEIGHT * (globals.MAX_CAVE_ITERATIONS + 1)
	battle_field.win.connect(_on_lose)
	
func _on_lose():
	print_debug("Lose")
	
func _on_win():
	print_debug("Win")


func _process(delta):
	position.y += globals.CAVE_SPEED
	balloon.position.y -= globals.BALLOON_SPEED
