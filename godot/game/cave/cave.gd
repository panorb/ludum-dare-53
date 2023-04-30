extends Node2D

const SPEED = 10

const SCREEN_HEIGHT = 1080

var segment = load("res://game/cave_segment/cave_segment.tscn")

var starting_position = Vector2(0,0)
var walls = []

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in 3:
		new_cave_segment()

func new_cave_segment():
	var instance = segment.instantiate()
	add_child(instance)
	if walls.is_empty():
		instance.position.y = SCREEN_HEIGHT
	else:
		instance.position.y = walls.back().position.y - SCREEN_HEIGHT
	starting_position = instance.create_cave_walls(starting_position)
	walls.append(instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	walls[0].position.y += SPEED
	walls[1].position.y += SPEED
	walls[2].position.y += SPEED
	
	if walls[1].position.y > 0:
		walls[0].remove_child(walls[0].get_child(0))
		walls.pop_front()
		new_cave_segment()
