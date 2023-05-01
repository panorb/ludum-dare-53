extends Creature

func play_sword_attack_sequence(repeats : int):
	animation_player.play("sword_receive")
	await animation_player.animation_finished
	
	for i in range(repeats):
		animation_player.play("sword_attack")
		await animation_player.animation_finished
	
	animation_player.play("sword_loose")
	await animation_player.animation_finished
	attack_finished.emit()

