extends Node2D

enum TYPE {ATTACK}

var attack_texture = preload("res://game/cards/attack.svg")

signal value_changed(old_value, new_value)

@onready var sprite = get_node("CardSprite") 
@onready var leftUpperNumber = get_node("%LeftUpperNumber")
@onready var rightButtomNumber = get_node("%RightButtomNumber")

var type: TYPE:
	get:
		return type
	set(value):
		type = value
		if(value == TYPE.ATTACK):
			sprite.texture = attack_texture

var value: int = 10:
	get:
		return value
	set(new_value):
		value = new_value
		_set_numbers(new_value)

func _ready():
	type = TYPE.ATTACK
	_set_numbers(value)
	

func take_damage(damage):
	var old_value = value
	value -= damage
	
	if value < 1:
		value = 1
		
	value_changed.emit(old_value, value)

func _set_numbers(number: int) -> void:
	var str_number = str(number)
	leftUpperNumber.text = str_number
	rightButtomNumber.text = str_number
