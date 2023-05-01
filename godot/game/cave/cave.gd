extends Node2D

var globals = preload("res://autoloads/globals.gd")

var segment = load("res://game/cave_segment/cave_segment.tscn")
var bat = load("res://game/cave/obstacles/bat/bat.tscn")

@onready var background_audio = $BackgroundAudioStreamPlayer

var starting_position = Vector2(globals.SCREEN_WIDTH / 2 - globals.GUARANTEED_CAVE_WIDTH / 2, globals.SCREEN_WIDTH / 2 + globals.GUARANTEED_CAVE_WIDTH / 2)
var iterations = 0
var walls = []
var bats = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in globals.MAX_CAVE_ITERATIONS:
		new_cave_segment()
	for wall in walls:
		for bat_spawn_position in wall.bat_spawn_positions:
			if 1 >= randf_range(0, globals.BAT_RARENESS):
				create_bat(bat_spawn_position + wall.position)
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

func create_bat(bat_spawn_position) -> void:
	var instance = bat.instantiate()
	add_child(instance)
	instance.position = bat_spawn_position
	bats.append(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass
	#if walls[0].global_position.y > globals.SCREEN_HEIGHT && iterations < globals.MAX_CAVE_ITERATIONS:
	#	redraw_cave_segment()
	#	walls.append(walls.pop_front())

func start_background_music() -> void:
	background_audio.play()
