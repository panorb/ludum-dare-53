extends State

@onready var sprite : AnimatedSprite2D = get_node("%Sprite")
@onready var detect_area : Area2D = get_node("%DetectArea")

func _ready():
	pass

func begin():
	sprite.play("alert")
	mark_movement_update(Vector2(0,0))
	get_tree().create_timer(0.8).timeout.connect(self._on_timeout)

func _on_timeout():
	for body in detect_area.get_overlapping_bodies():
		if body.is_in_group("balloon"):
			mark_finished("Hunt")
			return
	
	mark_finished("Fly")
