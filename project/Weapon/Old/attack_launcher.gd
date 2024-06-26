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

func _on_chain_timer_timeout():
	launch_chain_attack()
	chain_count -= 1
	if chain_count > 0:
		chain_timer.start()
