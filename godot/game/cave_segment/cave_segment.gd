extends CharacterBody2D

class_name CaveSegment

var globals = preload("res://autoloads/globals.gd")

const SAMPLES = 8

@onready var segment_left = get_node("SegmentLeft")
@onready var collision_segment_left = get_node("CollisionSegmentLeft")
@onready var segment_right = get_node("SegmentRight")
@onready var collision_segment_right = get_node("CollisionSegmentRight")

var bat_spawn_positions = []
var tree_spawn_positions = []

func _ready() -> void:
	pass

# vertical offset at the borrom and the top of a cave segment
func create_top_offset() -> float:
	var min_value = globals.MIN_CAVE_THICKNESS
	var max_value = globals.SCREEN_WIDTH - globals.GUARANTEED_CAVE_WIDTH - globals.MIN_CAVE_THICKNESS
	return randf_range(min_value, max_value)

func create_horizontal_base_sample(offsets, samplenumber) -> Vector2:
	var x_positions = Vector2(0, 0)
	var ratio = float(samplenumber + 1) / SAMPLES
	x_positions[0] = offsets[0] + (offsets[1] - offsets[0]) * ratio
	x_positions[1] = x_positions[0] + globals.GUARANTEED_CAVE_WIDTH
	return x_positions

func add_symmetric_offsets(x_positions) -> Vector2:
	var min_offset = min(x_positions[0] - globals.MIN_CAVE_THICKNESS, globals.CAVE_SYM_VAR)
	var max_offset = min(globals.SCREEN_WIDTH - globals.MIN_CAVE_THICKNESS - x_positions[1], globals.CAVE_SYM_VAR)
	var offset = randf_range(-globals.CAVE_SYM_VAR, globals.CAVE_SYM_VAR)
	x_positions[0] += offset
	x_positions[1] += offset
	return x_positions

func add_asymmetric_offsets(x_positions) -> Vector2:
	var min_offset = min(x_positions[0] - globals.MIN_CAVE_THICKNESS, globals.CAVE_ASYM_VAR)
	x_positions[0] -= randf_range(0, min_offset)
	var max_offset = min(globals.SCREEN_WIDTH - globals.MIN_CAVE_THICKNESS - x_positions[1], globals.CAVE_ASYM_VAR)
	x_positions[1] += randf_range(0, max_offset)
	return x_positions

func create_vertical_base_sample(samplenumber) -> Vector2:
	var ratio = float(samplenumber + 1) / SAMPLES
	var y_position = (1 - ratio) * globals.SCREEN_HEIGHT
	return Vector2(y_position, y_position)

func add_horizontal_offsets(y_positions, samplenumber) -> Vector2:
	if samplenumber + 1 != SAMPLES:
		y_positions[0] += randf_range(-globals.CAVE_HORIZONTAL_VAR, globals.CAVE_HORIZONTAL_VAR)
	return y_positions
	

func create_cave_walls(starting_position) -> Vector2:
	var left_column = [Vector2(-globals.SCREEN_WIDTH, 0), Vector2(-globals.SCREEN_WIDTH, globals.SCREEN_HEIGHT), Vector2(starting_position[0], globals.SCREEN_HEIGHT)]
	var right_column = [Vector2(2*globals.SCREEN_WIDTH, 0), Vector2(2*globals.SCREEN_WIDTH, globals.SCREEN_HEIGHT), Vector2(starting_position[1], globals.SCREEN_HEIGHT)]
	
	var top_offset = create_top_offset()
	var offsets = Vector2(starting_position[0], top_offset)
	
	var x_positions = Vector2(0,0)
	for samplenumber in SAMPLES:
		x_positions = create_horizontal_base_sample(offsets, samplenumber)
		x_positions = add_symmetric_offsets(x_positions)
		x_positions = add_asymmetric_offsets(x_positions)
		var y_positions = create_vertical_base_sample(samplenumber)
		y_positions = add_horizontal_offsets(y_positions, samplenumber)
		left_column.append(Vector2(x_positions[0], y_positions[0]))
		right_column.append(Vector2(x_positions[1], y_positions[1]))
		bat_spawn_positions.append(Vector2(x_positions[0] + globals.BAT_SPAWN_DISTANCE, y_positions[0]))
		bat_spawn_positions.append(Vector2(x_positions[1] - globals.BAT_SPAWN_DISTANCE, y_positions[1]))
		if samplenumber % 2 == 0:
			tree_spawn_positions.append(Vector3(x_positions[0], x_positions[1], (y_positions[1]+y_positions[0])/2))
	
	segment_left.polygon = PackedVector2Array(left_column)
	collision_segment_left.polygon = PackedVector2Array(left_column)
	segment_right.polygon = PackedVector2Array(right_column)
	collision_segment_right.polygon = PackedVector2Array(right_column)
	return x_positions
