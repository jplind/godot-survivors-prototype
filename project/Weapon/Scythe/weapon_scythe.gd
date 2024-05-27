extends Weapon

func launch_attack():
	var attack1 : Attack = attack_scene.instantiate()
	var direction : Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	attack1.direction = direction
	attack1.position = player.position
	launched_attacks.add_child(attack1)
	var attack2 : Attack = attack_scene.instantiate()
	attack2.direction = -direction
	attack2.position = player.position
	launched_attacks.add_child(attack2)
