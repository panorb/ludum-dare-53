extends Node2D

@onready var states_container : Node = get_node("States")
@onready var hit_area : Area2D = $HitArea
@onready var cry_sound1 : AudioStreamPlayer = $CrySound1
@onready var attack_sound : AudioStreamPlayer = $AttackSound1

var current_state_name := "Asleep"
var has_attacked : bool = false

const MOVEMENT_SPEED = 410
var movement_direction = Vector2(0, 0)

func  _ready():
	for state in states_container.get_children():
		state.state_finished.connect(self._on_state_finish)
		state.update_movement_direction.connect(self._on_update_movement_direction)
	
	switch_state(current_state_name, false)

func _physics_process(delta):
	for body in hit_area.get_overlapping_bodies():
		if body.is_in_group('balloon'):
			if not has_attacked:
				attack_sound.play()
				has_attacked = true
			body.take_damage(1, self)

func _process(delta):
	position += MOVEMENT_SPEED * delta * movement_direction
	
	states_container.get_node(current_state_name).update(delta)

func switch_state(state_name : String, play_cry_sound : bool = true) -> void:
	for state in states_container.get_children():
		if state.name == state_name:
			current_state_name = state_name
			state.begin()
			if play_cry_sound and randi() % 3 == 0:
				cry_sound1.play()
			

func _on_state_finish(next_state_name : String):
	switch_state(next_state_name)

func _on_update_movement_direction(movement_direction : Vector2):
	self.movement_direction = movement_direction
