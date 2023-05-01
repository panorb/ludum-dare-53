extends Node2D

var ending_screen_scene : PackedScene = preload("res://game/ui/ending_screen.tscn")

var scenes = {
	"main_menu": preload("res://game/ui/main_menu.tscn"),
	"game": preload("res://game/game.tscn")
}

var current_scene : String = "main_menu"

func transition_to(next_scene : String):
	var scene_instance : CanvasItem = scenes[next_scene].instance()
	scene_instance.self_modulate = Color.TRANSPARENT
	add_child(scene_instance)
	
	var tween : Tween = get_tree().create_tween()
	tween.tween_property(scene_instance, "self_modulate", Color.WHITE, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.play()
