extends Node2D

@onready var states_container : Node = get_node("States")
var current_state_name := "Asleep"

func  _ready():
	for state in states_container.get_children():
		state.state_finished.connect(self._on_state_finish)
	
	switch_state(current_state_name)

func switch_state(state_name : String) -> void:
	for state in states_container.get_children():
		if state.name == state_name:
			current_state_name = state_name
			state.begin()

func _on_state_finish(next_state_name : String):
	switch_state(next_state_name)


