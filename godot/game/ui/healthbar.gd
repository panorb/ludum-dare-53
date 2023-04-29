extends Control

@export var healthy_color: Color = Color.DARK_GREEN
@export var warning_color: Color = Color.ORANGE
@export var danger_color: Color = Color.RED

@export var warning_amount: float = 0.5
@export var danger_amount: float = 0.25


func _on_health_updated(amount) -> void:
	var health = self.value - amount

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


# for testing purposes
func _ready():
	_on_health_updated(15)
