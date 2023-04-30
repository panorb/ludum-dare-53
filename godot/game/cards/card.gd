extends Node2D

enum TYPE {ATTACK}

signal value_changed(old_value, new_value)

var type: TYPE:
	get:
		return type
	set(value):
		self.type = value
		var texture: CompressedTexture2D = CompressedTexture2D.new()
		if(value == TYPE.ATTACK):
			texture.resource_name = "res://game/cards/attack.svg"

var value: int = 10 

@onready var sprite = get_node("Sprite2D") 

func _ready():
	pass

func _set_type(type: TYPE) -> void:
	self.type = type

func _get_type() -> TYPE:
	return type

func take_damage(damage):
	var old_value = value
	value -= damage
	
	if value < 1:
		value = 1
		
	value_changed.emit(old_value, value)
