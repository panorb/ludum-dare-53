extends Control


func _on_health_updated(amount) -> void:
	var health = self.value - amount
	_tween(health)


func _tween(value) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", value, 1.0).set_trans(Tween.TRANS_LINEAR)


# for testing purposes
func _ready():
	_on_health_updated(20)
