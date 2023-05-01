extends Node2D

signal lose
signal win

@onready var hero = get_node("Hero")
@onready var monster = get_node("Dragon")


func _ready():
	hero.dead.connect(_on_hero_dead)
	monster.dead.connect(_on_monster_dead)


func on_card_received(card_type, card_value):
	hero.play_attack_animation(card_type, card_value)
	monster.take_damage(card_value)
	monster.play_attack_animation(card_type, card_value)
	hero.take_damage(10)


func _on_hero_dead():
	lose.emit()


func _on_monster_dead():
	win.emit()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		on_card_received("attack", 15)
