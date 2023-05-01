extends Node2D

signal spawn_card
@onready var animation_player = $AnimationPlayer

func _ready():
	spawn_card.connect(_on_card_spawned)
	
func _on_card_spawned():
	var balloons = get_tree().get_nodes_in_group("balloon")
	for balloon in balloons:
		balloon.receive_card(Card.TYPE.ATTACK, 10)

func play_spawn_animation():
	animation_player.play("spawn")
