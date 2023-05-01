class_name Card
extends Node2D

enum TYPE {ATTACK}

var attack_texture = preload("res://game/cards/attack.svg")

signal value_changed(old_value, new_value)

@onready var sprite = $CardSprite
@onready var leftUpperNumber = get_node("%LeftUpperNumber")
@onready var rightButtomNumber = get_node("%RightButtomNumber")
@onready var animation_player = get_node("AnimationPlayer")

var type: TYPE
var value: int

func _ready():
	leftUpperNumber = get_node("%LeftUpperNumber")
	type = TYPE.ATTACK
	_set_numbers(value)

func take_damage(damage: int) -> int:
	if damage > 0 and value > 1:
		animation_player.play("hurt")
		var old_value = value
		value -= damage
		
		if value < 1:
			value = 1

		value_changed.emit(old_value, value)

		_set_numbers(value)
		
	return value

func _set_numbers(number: int) -> void:
	var str_number = str(number)
	leftUpperNumber.text = str_number
	rightButtomNumber.text = str_number

func update_type(type: TYPE):
	match type:
		TYPE.ATTACK:
			sprite.texture = attack_texture
