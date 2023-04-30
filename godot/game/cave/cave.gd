extends Node2D

const SPEED = 5

const SCREEN_HEIGHT = 2160

var segment = load("res://game/cave_segment/cave_segment.tscn")

var starting_position = Vector2(0,0)
var walls = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in 3:
		new_cave_segment()

func new_cave_segment() -> void:
	var instance = segment.instantiate()
	add_child(instance)
	if walls.is_empty():
		instance.position.y = SCREEN_HEIGHT
	else:
		instance.position.y = walls.back().position.y - SCREEN_HEIGHT
	starting_position = instance.create_cave_walls(starting_position)
	walls.append(instance)

func redraw_cave_segment() -> void:
	walls[0].position.y = walls.back().position.y - SCREEN_HEIGHT
	starting_position = walls[0].create_cave_walls(starting_position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta) -> void:
	walls[0].position.y += SPEED
	walls[1].position.y += SPEED
	walls[2].position.y += SPEED
	
	if walls[1].position.y > 0:
		redraw_cave_segment()
		walls.append(walls.pop_front())
