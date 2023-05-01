extends State

@onready var sprite : AnimatedSprite2D = get_node("%Sprite")
@onready var detect_area : Area2D = get_node("%DetectArea")

func _ready():
	detect_area.body_entered.connect(self._on_DetectArea_body_entered)
	

func begin():
	sprite.play("asleep")
	mark_movement_update(Vector2(0,0))

func update(delta):
	pass

func _on_DetectArea_body_entered(body : Node2D):
	mark_finished("Alert")
