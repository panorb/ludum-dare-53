extends Node2D

var globals = preload("res://autoloads/globals.gd")

var segment = load("res://game/cave_segment/cave_segment.tscn")
var bat = load("res://game/cave/obstacles/bat/bat.tscn")
var tree1 = load("res://game/cave/obstacles/tree1/tree1.tscn")
var tree2 = load("res://game/cave/obstacles/tree2/tree2.tscn")

@onready var background_audio = $BackgroundAudioStreamPlayer

var starting_position = Vector2(globals.SCREEN_WIDTH / 2 - globals.GUARANTEED_CAVE_WIDTH / 2, globals.SCREEN_WIDTH / 2 + globals.GUARANTEED_CAVE_WIDTH / 2)
var iterations = 0
var walls = []
var bats = []
var trees = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in globals.MAX_CAVE_ITERATIONS:
		new_cave_segment()
	for wall in walls:
		for bat_spawn_position in wall.bat_spawn_positions:
			if 1 >= randf_range(0, globals.BAT_RARENESS):
				create_bat(bat_spawn_position + wall.position)
		for tree_spawn_position in wall.tree_spawn_positions:
			if 1 >= randf_range(0, globals.TREE_RARENESS):
				var tree_x = (tree_spawn_position[0] + tree_spawn_position[1]) / 2 + wall.position[0]
				var tree_y = tree_spawn_position[2] + wall.position[1]
				create_tree(Vector2(tree_x, tree_y))
				if randi() % 2 == 0:
					tree_x += globals.TREE_SPAWN_MIN_DISTANCE
				else:
					tree_x -= globals.TREE_SPAWN_MIN_DISTANCE
				if 1 >= randf_range(0, globals.TREE_RARENESS):
					create_tree(Vector2(tree_x, tree_y))
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

func create_tree(tree_spawn_position) -> void:
	var instance
	if randi() % 2 == 0:
		instance = tree1.instantiate()
	else:
		instance = tree2.instantiate()
	add_child(instance)
	instance.position = tree_spawn_position
	trees.append(instance)

func reset() -> void:
	for wall in walls:
		wall.queue_free()
	for bat in bats:
		bat.queue_free()
	for tree in trees:
		tree.queue_free()
	walls = []
	bats = []
	trees = []
	_ready()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	pass
	#if walls[0].global_position.y > globals.SCREEN_HEIGHT && iterations < globals.MAX_CAVE_ITERATIONS:
	#	redraw_cave_segment()
	#	walls.append(walls.pop_front())

func start_background_music() -> void:
	background_audio.play()
