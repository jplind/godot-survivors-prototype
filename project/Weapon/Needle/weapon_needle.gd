extends Weapon

var attack_spread : float = 15
var closest_enemies : Array[Node]

func launch_attack():
	var attack : Attack = attack_scene.instantiate()
	attack.position = player.position
	#var closest_enemy : Enemy = get_tree().get_nodes_in_group("enemies").pick_random()
	#for enemy in get_tree().get_nodes_in_group("enemies"):
		#if player.position.distance_squared_to(enemy.position) < player.position.distance_squared_to(closest_enemy.position):
			#closest_enemy = enemy
	#attack.direction = player.position.direction_to(closest_enemy.position)
	#attack.direction = player.global_position.direction_to(get_global_mouse_position())
	closest_enemies = get_tree().get_nodes_in_group("enemies")
	closest_enemies.sort_custom(sort_closest)
	attack.direction = player.position.direction_to(closest_enemies.pop_front().position)
	launched_attacks.add_child(attack)
	if weapon_data.quantity.value > 1:
		chain_timer.start()
		chain_count = 0

func sort_closest(a, b) -> bool:
	if player.position.distance_squared_to(a.position) < player.position.distance_squared_to(b.position):
		return true
	else:
		return false

func launch_chain_attack():
	var attack : Attack = attack_scene.instantiate()
	attack.position = player.position
	if closest_enemies.size() == 0:
		return
	if not is_instance_valid(closest_enemies[0]):
		return
	var direction = player.position.direction_to(closest_enemies.pop_front().position)
	#var closest_enemy : Enemy = get_tree().get_nodes_in_group("enemies").pick_random()
	#for enemy in get_tree().get_nodes_in_group("enemies"):
		#if player.position.distance_squared_to(enemy.position) < player.position.distance_squared_to(closest_enemy.position):
			#closest_enemy = enemy
	#var direction = player.position.direction_to(closest_enemy.position)
	var spread = randf_range(-attack_spread, attack_spread)
	attack.direction = direction.rotated(deg_to_rad(spread))
	launched_attacks.add_child(attack)
