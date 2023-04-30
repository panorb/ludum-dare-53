extends CharacterBody2D

const SCREEN_HEIGHT = 1080
const SCREEN_WIDTH = 1920

const SAMPLES = 8

var EFFECTIVE_WIDTH = 1300
var MIN_BORDER = 1
var SYMMETRIC_VARIANCE = 100
var ASYMMETRIC_VARIANCE = 300
var HORIZONTAL_VARIANCE = 40

@onready var segment_left = get_node("SegmentLeft")
@onready var collision_segment_left = get_node("CollisionSegmentLeft")
@onready var segment_right = get_node("SegmentRight")
@onready var collision_segment_right = get_node("CollisionSegmentRight")

func _ready() -> void:
	pass

func create_cave_walls(starting_position) -> Vector2:
	var left_column = [Vector2(0, 0), Vector2(0, SCREEN_HEIGHT), Vector2(starting_position[0], SCREEN_HEIGHT)]
	var right_column = [Vector2(SCREEN_WIDTH, 0), Vector2(SCREEN_WIDTH, SCREEN_HEIGHT), Vector2(starting_position[1], SCREEN_HEIGHT)]
	var left_offset_bottom = randi_range(MIN_BORDER, SCREEN_WIDTH - EFFECTIVE_WIDTH - MIN_BORDER)
	var left_offset_top = randi_range(MIN_BORDER, SCREEN_WIDTH - EFFECTIVE_WIDTH - MIN_BORDER)
	
	var left_position = 0
	var right_position = 0
	for n in SAMPLES:
		left_position = left_offset_bottom + (left_offset_top - left_offset_bottom) * (n + 1) / SAMPLES + randi_range(-SYMMETRIC_VARIANCE/2, SYMMETRIC_VARIANCE/2)
		right_position = left_position + EFFECTIVE_WIDTH
		left_position += randi_range(-ASYMMETRIC_VARIANCE/2, ASYMMETRIC_VARIANCE/2)
		right_position += randi_range(-ASYMMETRIC_VARIANCE/2, ASYMMETRIC_VARIANCE/2) 
		left_position = max( 1, left_position)
		right_position = min( SCREEN_WIDTH - 1, right_position)
		var vertical_position = SCREEN_HEIGHT - (n + 1) * SCREEN_HEIGHT / SAMPLES
		if n == SAMPLES - 1:
			left_column.append(Vector2(left_position, vertical_position))
			right_column.append(Vector2(right_position, vertical_position))
		else:
			var left_vertical_position = vertical_position + randi_range(-HORIZONTAL_VARIANCE/2, HORIZONTAL_VARIANCE/2)
			var right_vertical_position = vertical_position + randi_range(-HORIZONTAL_VARIANCE/2, HORIZONTAL_VARIANCE/2)
			left_column.append(Vector2(left_position, left_vertical_position))
			right_column.append(Vector2(right_position, right_vertical_position))
	segment_left.polygon = PackedVector2Array(left_column)
	collision_segment_left.polygon = PackedVector2Array(left_column)
	segment_right.polygon = PackedVector2Array(right_column)
	collision_segment_right.polygon = PackedVector2Array(right_column)
	return Vector2(left_position, right_position)
