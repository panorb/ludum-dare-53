extends Node2D

class_name Creature

@export var health: int = 10
@export var max_health: int = health

signal health_changed(old_health, health)
signal dead
signal do_damage
signal attack_finished

@onready var animation_player : AnimationPlayer = get_node("AnimationPlayer")


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func take_damage(damage):
	var old_health = health
	health -= damage

	if health < 0:
		health = 0
		animation_player.play("die")
	else:
		animation_player.play("hurt")

	health_changed.emit(old_health, health)

	if health == 0:
		dead.emit()


func play_attack_animation():
	animation_player.play("attack")
	await animation_player.animation_finished
	attack_finished.emit()
