extends State

@onready var sprite : AnimatedSprite2D = get_node("%Sprite")
@onready var detect_area : Area2D = get_node("%DetectArea")

func begin():
	sprite.play("fly")
	get_tree().create_timer(3.2).timeout.connect(self._on_timeout)

func _on_timeout():
	for body in detect_area.get_overlapping_bodies():
		if body.is_in_group("balloon"):
			mark_finished("Hunt")
			return
	
	get_tree().create_timer(3.0).timeout.connect(self._on_timeout)
