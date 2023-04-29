extends Node2D

class_name Creature

@export var health: int = 10
@export var max_health: int = health

signal health_changed(befor_demage_health, health)
signal dead()

@onready var animation_player = get_node("AnimationPlayer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func take_damage(demage):
	var befor_demage_health = health
	health = health - demage
	
	if health < 0:
		health = 0
		animation_player.play("die")
	else:
		animation_player.play("hurt")
	
	emit_signal('health_changed', befor_demage_health, health)
	
	if health == 0:
		emit_signal('dead')

func play_attack_animation(card_type : String, card_value : int):
	animation_player.play("attack")

