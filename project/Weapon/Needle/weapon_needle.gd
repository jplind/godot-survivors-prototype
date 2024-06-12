extends Weapon

var attack_spread : float = 15

func launch_attack():
	var attack : Attack = attack_scene.instantiate()
	#if player.direction != Vector2.ZERO:
		#attack.direction = player.direction
	#else:
		#attack.direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	#if player.sprite.flip_h:
		#attack.direction = Vector2(1, 0)
	#else:
		#attack.direction = Vector2(-1, 0)
	attack.direction = player.global_position.direction_to(get_global_mouse_position())
	attack.position = player.position
	launched_attacks.add_child(attack)
	if weapon_data.quantity.value > 1:
		chain_timer.start()
		chain_count = 0

func launch_chain_attack():
	var attack : Attack = attack_scene.instantiate()
	attack.position = player.position
	var direction : Vector2 = player.global_position.direction_to(get_global_mouse_position())
	var spread = randf_range(-attack_spread, attack_spread)
	attack.direction = direction.rotated(deg_to_rad(spread))
	launched_attacks.add_child(attack)
