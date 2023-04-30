extends CharacterBody2D

const SCREEN_HEIGHT = 1080
const SCREEN_WIDTH = 1920

const SAMPLES = 10

var EFFECTIVE_WIDTH = 1020
var MIN_BORDER = 100
var SYMMETRIC_VARIANCE = 200
var ASYMMETRIC_VARIANCE = 300

@onready var segment_left = get_node("SegmentLeft")
@onready var collision_segment_left = get_node("CollisionSegmentLeft")
@onready var segment_right = get_node("SegmentRight")
@onready var collision_segment_right = get_node("CollisionSegmentRight")

func _ready() -> void:
	var left_column = [Vector2(0,0), Vector2(0,SCREEN_HEIGHT)]
	var right_column = [Vector2(SCREEN_WIDTH,0), Vector2(SCREEN_WIDTH,SCREEN_HEIGHT)]
	var left_offset_bottom = randi_range(MIN_BORDER, SCREEN_WIDTH - EFFECTIVE_WIDTH - MIN_BORDER)
	var left_offset_top = randi_range(MIN_BORDER, SCREEN_WIDTH - EFFECTIVE_WIDTH - MIN_BORDER)
	for n in SAMPLES+1:
		var left_position = left_offset_bottom + (left_offset_top - left_offset_bottom) * n / SAMPLES + randi_range(-SYMMETRIC_VARIANCE/2, SYMMETRIC_VARIANCE/2)
		var right_position = left_position + EFFECTIVE_WIDTH
		left_position += randi_range(-ASYMMETRIC_VARIANCE/2, ASYMMETRIC_VARIANCE/2)
		right_position += randi_range(-ASYMMETRIC_VARIANCE/2, ASYMMETRIC_VARIANCE/2) 
		var vertical_position = SCREEN_HEIGHT - n * SCREEN_HEIGHT / SAMPLES
		left_column.append(Vector2(left_position, vertical_position))
		right_column.append(Vector2(right_position, vertical_position))
	segment_left.polygon = PackedVector2Array(left_column)
	collision_segment_left.polygon = PackedVector2Array(left_column)
	segment_right.polygon = PackedVector2Array(right_column)
	collision_segment_right.polygon = PackedVector2Array(right_column)
