extends CharacterBody2D

const DRAG = 0.02

const WIND_SPEED = 1000000

const MINIMUM_SQUARED_WIND_DISTANCE = 400

func get_wind_speed():
	var wind_speed = Vector2(0, 0)
	if Input.is_action_pressed("blow_wind"):
		var wind_direction = get_wind_direction()
		var wind_power = get_wind_power()
		wind_speed = wind_direction * WIND_SPEED * wind_power
	return wind_speed

func get_wind_direction():
	var wind_origin = get_global_mouse_position()
	if (position.is_equal_approx(wind_origin)):
		return Vector2(0, 0)
	var wind_direction = -position.direction_to(wind_origin)
	return wind_direction

func get_wind_power():
	var wind_origin = get_global_mouse_position()
	var squared_distance = position.distance_squared_to(wind_origin)
	if (squared_distance < MINIMUM_SQUARED_WIND_DISTANCE):
		squared_distance = MINIMUM_SQUARED_WIND_DISTANCE
	return 1/squared_distance

func _physics_process(delta):
	var wind_speed = get_wind_speed()
	velocity = wind_speed * DRAG + velocity * (1-DRAG)
	# look_at(target)
	move_and_slide()
	if (position.x < 50):
		position.x = 50
	move_and_slide()
	if (position.y < 50):
		position.y = 50
	if (position.x > 1000):
		position.x = 1000
	move_and_slide()
	if (position.y > 550):
		position.y = 550
