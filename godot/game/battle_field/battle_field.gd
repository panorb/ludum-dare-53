extends Node2D

signal lose
signal win
signal balloon_arrived
signal balloon_drop
signal round_ended

@onready var hero = get_node("Hero")
@onready var monster = get_node("Dragon")

func execute_round(card_type : Card.TYPE, card_value : int):
	if card_type == Card.TYPE.ATTACK:
		hero.play_sword_attack_sequence(card_value)
	
	await hero.attack_finished
	
	if monster.health > 0:
		monster.play_attack_animation()
		await monster.attack_finished
	
	if monster.health > 0 and hero.health > 0:
		round_ended.emit()
	else:
		if monster.health <= 0:
			monster.play_die_animation()
			await monster.die_finished
			win.emit()
		if hero.health <= 0:
			hero.play_die_animation()
			await hero.die_finished
			lose.emit()

func on_card_received(card_type, card_value):
	pass
	#hero.play_attack_animation(card_type, card_value)
	#monster.take_damage(card_value)
	#monster.play_attack_animation(card_type, card_value)
	#hero.take_damage(10)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		on_card_received("attack", 15)


func _on_arrival_area_body_entered(body):
	if body.is_in_group("balloon"):
		emit_signal("balloon_arrived")


func _on_drop_area_body_entered(body):
	if body.is_in_group("balloon"):
		emit_signal("balloon_drop")


func _on_hero_do_damage():
	monster.take_damage(1)


func _on_dragon_do_damage():
	hero.take_damage(1)
