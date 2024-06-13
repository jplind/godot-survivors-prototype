class_name Weapon
extends Node2D

@export var weapon_data : WeaponData 
@export var attack_scene : PackedScene
@export var player : Node2D
var attack_rate : float
var chain_spread : float
var chain_count : int = 0
@onready var launched_attacks = %LaunchedAttacks
@onready var attack_timer = %AttackTimer
@onready var chain_timer = %ChainTimer

func _ready():
	Events.player_died.connect(on_player_died)
	Events.battle_started.connect(on_battle_started)
	attack_rate = weapon_data.attack_rate_levels[weapon_data.attack_rate_level]
	attack_timer.wait_time = attack_rate
	#if weapon_data.weapon_chain:
		#chain_spread = weapon_data.weapon_chain.chain_spread
		#chain_timer.wait_time = weapon_data.weapon_chain.chain_rate

func _on_attack_timer_timeout():
	launch_attack()
	#if weapon_data.weapon_chain:
		#chain_timer.start()
		#chain_count = 0

func launch_attack():
	pass

func on_player_died():
	attack_timer.stop()

func on_battle_started():
	for attack in launched_attacks.get_children():
		attack.queue_free()
	attack_timer.start()

func _on_chain_timer_timeout():
	launch_chain_attack()
	chain_count += 1
	if chain_count < weapon_data.weapon_chain.value:
		chain_timer.start()

func launch_chain_attack():
	pass
