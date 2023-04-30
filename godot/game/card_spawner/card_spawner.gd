extends Node2D

signal spawn_card

func _ready():
	spawn_card.connect(_on_card_spawned)
	
func _on_card_spawned():
	var balloons = get_tree().get_nodes_in_group("balloon")
	for balloon in balloons:
		balloon.card_received(Card.TYPE.ATTACK, 10)
