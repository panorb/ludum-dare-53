extends CharacterBody2D

const DRAG = 0.05

const MAX_WIND_SPEED = 500.0
const MAX_RAW_WIND_POWER = 0.02
const WIND_POWER_DROP = 0.8

const PADDING_TOP = 200
const PADDING_LEFT = 50
const PADDING_RIGHT = 3840 - 50
const PADDING_BOTTOM = 2160 - 200

const DAMAGE_BUMP_STRENGTH = 100

var card_scene = preload("res://game/cards/card.tscn")
var containing_card: Card
var last_wall_hit_sound_play_time: float = 0

var paused : bool = false

@onready var head_sprite = $Head
@onready var cage_center = $Cage/Center

@onready var balloon_hit_cave_sounds = [
	$BalloonHitCaveSound1,
	$BalloonHitCaveSound2,
	$BalloonHitCaveSound3,
]

var invincible : bool = false
@onready var invincible_timer = $InvincibleTimer


func get_wind_speed() -> Vector2:
	if Input.is_action_pressed("blow_wind"):
		play_wind_sound()
		var wind_direction = get_wind_direction()
		var wind_power = get_wind_power()
		return wind_direction * MAX_WIND_SPEED * wind_power
	return Vector2(0, 0)


func get_wind_direction() -> Vector2:
	var wind_origin = get_global_mouse_position()
	if global_position.is_equal_approx(wind_origin):
		return Vector2(0, 0)
	return -global_position.direction_to(wind_origin)


func get_wind_power() -> float:
	var wind_origin = get_global_mouse_position()
	var distance = global_position.distance_to(wind_origin)
	var wind_raw_power = pow(1.0 / (distance), WIND_POWER_DROP)
	return min(wind_raw_power / MAX_RAW_WIND_POWER, 1)


func adjust_rotation() -> void:
	rotation = asin(velocity.x / MAX_WIND_SPEED)


func adjust_velocity(wind_speed) -> void:
	velocity += (wind_speed - velocity) * DRAG


func reset_outside_position() -> void:
	global_position.x = clamp(global_position.x, PADDING_LEFT, PADDING_RIGHT)
	global_position.y = clamp(global_position.y, PADDING_TOP, PADDING_BOTTOM)


func _physics_process(delta : float) -> void:
	velocity.y -= Globals.BALLOON_SPEED
	var wind_speed = get_wind_speed()
	
	if paused:
		velocity = Vector2.ZERO
	
	var current_velocity = move_and_collide(velocity * delta)

	adjust_rotation()
	adjust_velocity(wind_speed)
	move_and_slide()


func _process(delta: float) -> void:
	last_wall_hit_sound_play_time = (
		last_wall_hit_sound_play_time - delta if last_wall_hit_sound_play_time > 0 else 0
	)
	var collision = get_last_slide_collision()
	if collision:
		var collider = collision.get_collider()
		if collider as CaveSegment:
			if last_wall_hit_sound_play_time <= 0:  # need to find a better solution
				balloon_hit_cave_sounds[randi() % balloon_hit_cave_sounds.size()].play()
				# Set new wait time bettwen 0.7 and 1.3
				last_wall_hit_sound_play_time = randf_range(0.7, 1.3)
	visible = invincible_timer.time_left <= 0 or int(invincible_timer.time_left / 0.15) % 2 == 0

func receive_card(card_type: Card.TYPE, card_value: int):
	var card: Card = card_scene.instantiate()
	card.type = card_type
	card.value = card_value
	card.set_name("Card")
	cage_center.add_child(card)
	containing_card = card

func drop_card():
	for child in cage_center.get_children():
		child.queue_free()
	
	containing_card = null
	
func take_damage(damage: int, damage_source: Node2D):
	if invincible or invincible_timer.time_left > 0:
		return
	
	invincible_timer.start()
	
	#var bump_vector = (global_position - damage_source.global_position).normalized()
	#velocity += bump_vector * DAMAGE_BUMP_STRENGTH * damage
	
	if containing_card:
		containing_card.take_damage(1)

var current_wind_sound_num = 1

func play_wind_sound():
	if current_wind_sound_num > 4:
		current_wind_sound_num = 1
	
	get_node("BalloonWindSound" + str(current_wind_sound_num)).play()
	
	current_wind_sound_num += 1
