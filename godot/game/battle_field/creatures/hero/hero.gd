extends Creature

func _ready():
	max_health = Globals.MAX_HEALTH_HERO
	health = Globals.MAX_HEALTH_HERO

func play_sword_attack_sequence(repeats : int):
	animation_player.play("sword_receive")
	await animation_player.animation_finished
	
	for i in range(repeats):
		animation_player.play("sword_attack")
		await animation_player.animation_finished
	
	animation_player.play("sword_loose")
	await animation_player.animation_finished
	attack_finished.emit()

var current_strike_sound_num = 1

func play_strike_sound():
	if current_strike_sound_num > 3:
		current_strike_sound_num = 1
	
	get_node("SoundStrike" + str(current_strike_sound_num)).play()
	
	current_strike_sound_num += 1
