extends Control

var ending_screen_scene : PackedScene = preload("res://game/ui/ending_screen.tscn")

var scenes = {
	"main_menu": preload("res://game/ui/main_menu.tscn"),
	"game": preload("res://game/game.tscn"),
	"ending_screen": preload("res://game/ui/ending_screen.tscn")
}

var current_scene : String = "main_menu"

func _ready():
	if has_node("ActiveScene"):
		connect_signals(get_node("ActiveScene"))

func connect_signals(instance : Node):
	if instance.has_signal("transition_to"):
		instance.transition_to.connect(transition_to)
	if instance.has_signal("game_won"):
		instance.game_won.connect(game_won)
	if instance.has_signal("game_lost"):
		instance.game_lost.connect(game_lost)

func transition_to(next_scene : String):
	var scene_instance : CanvasItem = scenes[next_scene].instantiate()
	scene_instance.name = "NextScene"
	add_child(scene_instance)
	connect_signals(scene_instance)
	get_node("ActiveScene").queue_free()
	await get_tree().create_timer(0.1).timeout
	scene_instance.name = "ActiveScene"

func game_lost():
	var scene_instance : CanvasItem = scenes["ending_screen"].instantiate()
	scene_instance.name = "NextScene"
	connect_signals(scene_instance)
	add_child(scene_instance)
	scene_instance.initialize("The hero has fallen. We are all doomed.")
	get_node("ActiveScene").queue_free()
	await get_tree().create_timer(0.1).timeout
	scene_instance.name = "ActiveScene"

func game_won():
	var scene_instance : CanvasItem = scenes["ending_screen"].instantiate()
	scene_instance.name = "NextScene"
	connect_signals(scene_instance)
	add_child(scene_instance)
	scene_instance.initialize("The dragon was slain. We're save! Hurray!")
	get_node("ActiveScene").queue_free()
	await get_tree().create_timer(0.1).timeout
	scene_instance.name = "ActiveScene"
