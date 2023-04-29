extends State

@onready var sprite : AnimatedSprite2D = get_node("Sprite")

func _ready():
	pass

func begin():
	sprite.play("asleep")

