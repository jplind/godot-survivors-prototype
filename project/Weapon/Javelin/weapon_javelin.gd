extends Weapon

func launch_attack():
	var attack : Attack = attack_scene.instantiate()
	attack.direction = player.global_position.direction_to(get_global_mouse_position())
	attack.position = player.position
	launched_attacks.add_child(attack)
