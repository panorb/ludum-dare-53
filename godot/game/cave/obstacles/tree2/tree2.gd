extends Node2D

@onready var hit_area : Area2D = $HitArea 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	for body in hit_area.get_overlapping_bodies():
		if body.is_in_group('balloon'):
			body.take_damage(1, self)
