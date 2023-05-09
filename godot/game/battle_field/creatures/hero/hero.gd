extends Creature

@onready var sword_strike_sounds = [
	$SoundStrike1,
	$SoundStrike2,
	$SoundStrike3
]

var current_strike_sound_index = 0

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


func play_strike_sound():
	sword_strike_sounds[current_strike_sound_index].play()
	current_strike_sound_index = (current_strike_sound_index + 1) % sword_strike_sounds.size()
