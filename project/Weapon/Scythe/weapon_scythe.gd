extends Weapon

func _ready():
	super()

func launch_attack():
	var attack : Attack = attack_scene.instantiate()
	#var direction : Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	attack.velocity = player.global_position.direction_to(get_global_mouse_position()) * 800
	attack.position = player.position
	launched_attacks.add_child(attack)
	attack.player = player
	attack_timer.stop()
	attack.scythe_returned.connect(on_scythe_returned)

func on_scythe_returned():
	if player.dead:
		return
	attack_timer.start()
