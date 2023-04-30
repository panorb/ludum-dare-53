extends CharacterBody2D

const DRAG = 0.05

const MAX_WIND_SPEED = 300.0
const MAX_RAW_WIND_POWER = 400.0
const WIND_POWER_DROP = 1.0

const PADDING_TOP = 200
const PADDING_LEFT = 50
const PADDING_RIGHT = 3840 - 50
const PADDING_BOTTOM = 2160 - 200


func get_wind_speed() -> Vector2:
	if Input.is_action_pressed("blow_wind"):
		var wind_direction = get_wind_direction()
		var wind_power = get_wind_power()
		return wind_direction * MAX_WIND_SPEED * wind_power
	return Vector2(0, 0)


func get_wind_direction() -> Vector2:
	var wind_origin = get_global_mouse_position()
	if position.is_equal_approx(wind_origin):
		return Vector2(0, 0)
	return -position.direction_to(wind_origin)


func get_wind_power() -> float:
	var wind_origin = get_global_mouse_position()
	var distance = position.distance_to(wind_origin)
	var wind_raw_power = pow(1 / (distance), WIND_POWER_DROP)
	return max(wind_raw_power / MAX_RAW_WIND_POWER, 1)


func adjust_rotation() -> void:
	rotation = asin(velocity.x / MAX_WIND_SPEED)


func adjust_velocity(wind_speed) -> void:
	velocity += (wind_speed - velocity) * DRAG


func reset_outside_position() -> void:
	position.x = clamp(position.x, PADDING_LEFT, PADDING_RIGHT)
	position.y = clamp(position.y, PADDING_TOP, PADDING_BOTTOM)


func _physics_process(_delta) -> void:
	var wind_speed = get_wind_speed()
	var current_velocity = move_and_collide(velocity * _delta)
	if current_velocity:
		velocity = velocity.bounce(current_velocity.get_normal())

	adjust_rotation()
	adjust_velocity(wind_speed)
	move_and_slide()
	reset_outside_position()
