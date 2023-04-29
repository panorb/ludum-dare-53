extends CharacterBody2D

const DRAG = 0.05

const MAX_WIND_SPEED = 300.0
const MAX_RAW_WIND_POWER = 400.0
const WIND_POWER_DROP = 1.0


func get_wind_speed():
	if Input.is_action_pressed("blow_wind"):
		var wind_direction = get_wind_direction()
		var wind_power = get_wind_power()
		return wind_direction * MAX_WIND_SPEED * wind_power
	return Vector2(0, 0)


func get_wind_direction():
	var wind_origin = get_global_mouse_position()
	if position.is_equal_approx(wind_origin):
		return Vector2(0, 0)
	return -position.direction_to(wind_origin)


func get_wind_power():
	var wind_origin = get_global_mouse_position()
	var distance = position.distance_to(wind_origin)
	var wind_raw_power = pow(1 / (distance), WIND_POWER_DROP)
	return max(wind_raw_power / MAX_RAW_WIND_POWER, 1)


func adjust_rotation():
	rotation = asin(velocity.x / MAX_WIND_SPEED)


func adjust_velocity(wind_speed):
	velocity += (wind_speed - velocity) * DRAG


func reset_outside_position():
	position.x = max(50, position.x)
	position.x = min(1800, position.x)

	position.y = max(50, position.y)
	position.y = min(1000, position.y)


func _physics_process(_delta):
	var wind_speed = get_wind_speed()
	adjust_rotation()
	adjust_velocity(wind_speed)
	move_and_slide()
	reset_outside_position()
