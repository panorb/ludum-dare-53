extends Control

@onready var health_bar = $Healthbar


func _on_health_updated(health, amount) -> void:
	health_bar.value = health


func _tween(value) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", value, 1.0).set_trans(Tween.TRANS_LINEAR)


# for testing purposes
func _ready():
	_tween(100)
