extends State

@onready var sprite : AnimatedSprite2D = get_node("%Sprite")
@onready var detect_area : Area2D = get_node("%DetectArea")

func begin():
	sprite.play("fly")
	get_tree().create_timer(3.0).timeout.connect(self._on_timeout)

func _on_timeout():
	for body in detect_area.get_overlapping_bodies():
		if body.is_in_group("balloon"):
			get_tree().create_timer(3.0).timeout.connect(self._on_timeout)
			return
	
	mark_finished("Fly")

func update(delta : float):
	var balloons = get_tree().get_nodes_in_group("balloon")
	
	var min_distance = 999999
	var min_distance_balloon = null
	
	for balloon in balloons:
		var distance = global_position.distance_to(balloon.global_position)
		if not min_distance_balloon or distance < min_distance:
			min_distance = distance
			min_distance_balloon = balloon
	
	var direction = global_position.direction_to(min_distance_balloon.global_position)
	mark_movement_update(direction)
