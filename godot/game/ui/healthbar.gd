extends TextureProgressBar

class_name HealthBar

@export var healthy_color: Color = Color.GREEN
@export var warning_color: Color = Color.ORANGE
@export var danger_color: Color = Color.RED

@export var warning_amount: float = 0.5
@export var danger_amount: float = 0.25


func _on_health_updated(old_health, health) -> void:
	_tween(health)
	_assign_color(health)


func _assign_color(amount) -> void:
	if amount < self.max_value * danger_amount:
		self.tint_progress = danger_color
	elif amount < self.max_value * warning_amount:
		self.tint_progress = warning_color
	else:
		self.tint_progress = healthy_color


func _tween(value) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", value, 1.0).set_trans(Tween.TRANS_LINEAR)


func _on_dragon_health_changed(old_health, health) -> void:
	_on_health_updated(old_health, health)


func _on_hero_health_changed(old_health, health) -> void:
	_on_health_updated(old_health, health)
