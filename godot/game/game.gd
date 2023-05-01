extends Node2D

@onready var cave = get_node('Cave')
@onready var card_spawner = get_node('CardSpawner')
@onready var battle_field = get_node('BattleField')
@onready var balloon : Node2D = get_node('Balloon')
@onready var camera : Camera2D = get_node("GameCamera")
@onready var hero_health_bar : TextureProgressBar = $"UI/HBoxContainer/HBoxContainer/VBoxContainer/Healthbar Main"
@onready var monster_health_bar : TextureProgressBar = $"UI/HBoxContainer/HBoxContainer2/VBoxContainer/Healthbar Enemy" 

var camera_follow : bool = true

func _ready():
	# await get_tree().idle_frame

	battle_field.hero.health_changed.connect(hero_health_bar._on_hero_health_changed)
	battle_field.monster.health_changed.connect(monster_health_bar._on_dragon_health_changed)

	camera.position.x = balloon.position.x
	
	cave.position.y = -Globals.SCREEN_HEIGHT
	battle_field.position.y = -Globals.SCREEN_HEIGHT * (Globals.MAX_CAVE_ITERATIONS + 0.5)
	battle_field.win.connect(_on_win)
	battle_field.lose.connect(_on_lose)
	
	card_spawner.play_spawn_animation()
	
	var spawn_point = Marker2D.new()
	spawn_point.name = "SpawnPoint"
	spawn_point.global_position = balloon.global_position
	add_child(spawn_point)
	
	
func _on_lose():
	print_debug("Lose")
	
func _on_win():
	print_debug("Win")

func _physics_process(delta):
	if camera_follow:
		camera.position.y = balloon.position.y


func _on_battle_field_balloon_arrived():
	camera_follow = false
	balloon.invincible = true
	var tween = get_tree().create_tween()
	tween.tween_property(camera, "position", battle_field.position, 0.8).set_trans(Tween.TRANS_CUBIC)
	tween.play()


func _on_card_spawner_spawn_card():
	balloon.receive_card(Card.TYPE.ATTACK, 10)


func _on_battle_field_balloon_drop():
	var card : Card = balloon.containing_card
	if card:
		battle_field.execute_round(card.type, card.value)
		balloon.drop_card()


func _on_battle_field_round_ended():
	var tween = get_tree().create_tween()
	balloon.paused = true
	balloon.position = $SpawnPoint.position
	tween.tween_property(camera, "position", $SpawnPoint.position, 1.2).set_trans(Tween.TRANS_CUBIC)
	await tween.finished
	cave.reset()
	camera_follow = true
	balloon.paused = false
	balloon.invincible = false
	card_spawner.play_spawn_animation()
	
