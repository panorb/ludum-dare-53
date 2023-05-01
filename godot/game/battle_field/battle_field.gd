extends Node2D

signal lose
signal win
signal balloon_arrived
signal balloon_drop

#@onready var hero = get_node("Hero")
#@onready var monster = get_node("Dragon")


func _ready():
	pass
	#hero.dead.connect(_on_hero_dead)
	#monster.dead.connect(_on_monster_dead)


func execute_card(card : Card):
	for i in range(card.value):
		pass

func on_card_received(card_type, card_value):
	pass
	#hero.play_attack_animation(card_type, card_value)
	#monster.take_damage(card_value)
	#monster.play_attack_animation(card_type, card_value)
	#hero.take_damage(10)


func _on_hero_dead():
	lose.emit()


func _on_monster_dead():
	win.emit()


func _input(event):
	if event.is_action_pressed("ui_accept"):
		on_card_received("attack", 15)


func _on_arrival_area_body_entered(body):
	if body.is_in_group("balloon"):
		emit_signal("balloon_arrived")


func _on_drop_area_body_entered(body):
	if body.is_in_group("balloon"):
		emit_signal("balloon_drop")
