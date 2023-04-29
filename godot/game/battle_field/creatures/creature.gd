extends Node2D

class_name Creature

var health: int
var max_health: int

signal health_changed(befor_demage_health, health)
signal dead()

func _init(health: int):
	max_health = health
	health = health

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
	
	emit_signal('health_changed', befor_demage_health, health)
	
	if health == 0:
		emit_signal('dead')
