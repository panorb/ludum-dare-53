extends Node2D

class_name Creature

@export var health: int = 10
@export var max_health: int = health

signal health_changed(old_health, health)
signal do_damage
signal attack_finished
signal die_finished

@onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")


func take_damage(damage):
	var old_health = health
	health -= damage

	if health < 0:
		health = 0
	else:
		animation_player.play("hurt")

	health_changed.emit(old_health, health)

func play_attack_animation():
	animation_player.play("attack")
	await animation_player.animation_finished
	attack_finished.emit()

func play_die_animation():
	animation_player.queue("die")
	await animation_player.animation_finished
	die_finished.emit()
