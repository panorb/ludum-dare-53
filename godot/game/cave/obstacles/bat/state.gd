class_name State
extends Node2D

signal state_finished(state_name : String)
signal update_movement_direction(direction : Vector2)

func begin():
	pass

func update(delta : float):
	pass

func mark_finished(next_state_name : String):
	state_finished.emit(next_state_name)

func mark_movement_update(direction : Vector2):
	update_movement_direction.emit(direction)
