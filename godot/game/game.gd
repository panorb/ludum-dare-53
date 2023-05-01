extends Node2D

@onready var cave = get_node('Cave')
@onready var card_spawner = get_node('CardSpawner')
@onready var battle_field = get_node('BattleField')
@onready var balloon : Node2D = get_node('Balloon')
@onready var camera : Camera2D = get_node("GameCamera")

var camera_follow : bool = true

func _ready():
	camera.position.x = balloon.position.x
	
	cave.position.y = -Globals.SCREEN_HEIGHT
	battle_field.position.y = -Globals.SCREEN_HEIGHT * (Globals.MAX_CAVE_ITERATIONS + 0.5)
	battle_field.win.connect(_on_lose)
	
	card_spawner.play_spawn_animation()
	
func _on_lose():
	print_debug("Lose")
	
func _on_win():
	print_debug("Win")

func _physics_process(delta):
	if camera_follow:
		camera.position.y = balloon.position.y


func _on_battle_field_balloon_arrived():
	camera_follow = false
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position", battle_field.position, 0.8).set_trans(Tween.TRANS_CUBIC)
	tween.play()


func _on_card_spawner_spawn_card():
	balloon.receive_card(Card.TYPE.ATTACK, 10)


func _on_battle_field_balloon_drop():
	var card : Card = balloon.containing_card
	if card:
		battle_field.execute_card(card.type, card.value)
		balloon.drop_card()
