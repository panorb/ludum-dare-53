extends Node2D

@onready var states_container : Node = get_node("States")
var current_state_name := "Asleep"

const MOVEMENT_SPEED = 140
var movement_direction = Vector2(0, 0)

func  _ready():
	for state in states_container.get_children():
		state.state_finished.connect(self._on_state_finish)
		state.update_movement_direction.connect(self._on_update_movement_direction)
	
	switch_state(current_state_name)

func _process(delta):
	position += MOVEMENT_SPEED * delta * movement_direction
	
	states_container.get_node(current_state_name).update(delta)

func switch_state(state_name : String) -> void:
	for state in states_container.get_children():
		if state.name == state_name:
			current_state_name = state_name
			state.begin()

func _on_state_finish(next_state_name : String):
	switch_state(next_state_name)

func _on_update_movement_direction(movement_direction : Vector2):
	self.movement_direction = movement_direction

