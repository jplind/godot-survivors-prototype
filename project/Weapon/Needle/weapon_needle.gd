extends Weapon

func launch_attack():
	var attack : Attack = attack_scene.instantiate()
	if player.sprite.flip_h:
		attack.direction = Vector2(1, 0)
	else:
		attack.direction = Vector2(-1, 0)
	attack.position = player.position
	launched_attacks.add_child(attack)

func launch_chain_attack():
	var attack : Attack = attack_scene.instantiate()
	attack.position = player.position
	var direction : Vector2
	if player.sprite.flip_h:
		direction = Vector2(1, 0)
	else:
		direction = Vector2(-1, 0)
	var spread = randf_range(0, chain_spread)
	if randf() < 0.5:
		spread *= -1
	attack.direction = direction.rotated(deg_to_rad(spread))
	launched_attacks.add_child(attack)
