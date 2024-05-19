extends Node2D

@export var attack_data : AttackData
@export var attack_scene : PackedScene
@export var player : Node2D
var chain_count : int = 0
var direction : Vector2
@onready var chain_attacks : int = attack_data.chain_attacks
@onready var chain_spread_range : Vector2 = attack_data.chain_spread_range
@onready var launched_attacks = %LaunchedAttacks
@onready var launch_timer = %LaunchTimer
@onready var chain_timer = %ChainTimer

func _ready():
	Events.player_died.connect(on_player_died)
	Events.battle_started.connect(on_battle_started)
	launch_timer.wait_time = attack_data.launch_rate
	chain_attacks = attack_data.chain_attacks
	if attack_data.chain_rate:
		chain_timer.wait_time = attack_data.chain_rate

func attack_setup():
	var attack = attack_scene.instantiate()
	attack.position = player.position
	attack.damage = attack_data.damage
	attack.speed = attack_data.speed
	attack.lifetime = attack_data.lifetime
	attack.pierce = attack_data.pierce
	return attack

func launch_main_attack():
	var attack = attack_setup()
	match attack_data.targeting_behavior:
		Enums.TargetingBehavior.RANDOM:
			direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		Enums.TargetingBehavior.MOUSE_TARGETED:
			direction = player.global_position.direction_to(get_global_mouse_position())
		Enums.TargetingBehavior.PLAYER_DIRECTION:
			if player.sprite.flip_h:
				direction = Vector2(1, 0)
			else:
				direction = Vector2(-1, 0)
	attack.direction = direction
	launched_attacks.add_child(attack)

func launch_chain_attack():
	var attack = attack_setup()
	var spread = randf_range(chain_spread_range.x, chain_spread_range.y)
	if randf() < 0.5:
		spread *= -1
	attack.direction = direction.rotated(deg_to_rad(spread))
	launched_attacks.add_child(attack)

func _on_launch_timer_timeout():
	launch_main_attack()
	if chain_attacks:
		chain_timer.start()
		chain_count = chain_attacks

func on_player_died():
	launch_timer.stop()

func on_battle_started():
	for attack in launched_attacks.get_children():
		attack.queue_free()
	launch_timer.start()

func _on_chain_timer_timeout():
	launch_chain_attack()
	chain_count -= 1
	if chain_count > 0:
		chain_timer.start()
