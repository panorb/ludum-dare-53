class_name State
extends Node

signal state_finished(state_name : String)

func begin():
	pass

func mark_finished(next_state_name : String):
	state_finished.emit(next_state_name)
