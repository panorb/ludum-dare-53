extends Node2D

var globals = preload("res://autoloads/globals.gd")

var segment = load("res://game/cave_segment/cave_segment.tscn")

@onready var background_audio = $BackgroundAudioStreamPlayer

var starting_position = Vector2(0,globals.SCREEN_WIDTH)
var iterations = 0
var walls = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 3:
		new_cave_segment()
	start_background_music()

func new_cave_segment() -> void:
	iterations += 1
	var instance = segment.instantiate()
	add_child(instance)
	if walls.is_empty():
		instance.position.y = 0
	else:
		instance.position.y = walls.back().position.y - globals.SCREEN_HEIGHT
	starting_position = instance.create_cave_walls(starting_position)
	walls.append(instance)

func redraw_cave_segment() -> void:
	iterations += 1
	walls[0].position.y = walls.back().position.y - globals.SCREEN_HEIGHT
	starting_position = walls[0].create_cave_walls(starting_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	if walls[0].global_position.y > globals.SCREEN_HEIGHT && iterations < globals.MAX_CAVE_ITERATIONS:
		redraw_cave_segment()
		walls.append(walls.pop_front())

func start_background_music() -> void:
	background_audio.play()
