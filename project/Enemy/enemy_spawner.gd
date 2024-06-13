extends Node2D

@export var enemy_scenes : Array[PackedScene]
var player
var player_direction_weight = 2
var enemy_count : int = 0
var spawn_distance = 600
@onready var enemies = %Enemies
@onready var enemy_spawn_timer = %EnemySpawnTimer

func _ready():
	Events.enemy_despawned.connect(on_enemy_despawned)
	Events.battle_started.connect(on_battle_started)

func _on_enemy_spawn_timer_timeout():
	if player.dead:
		return
	if enemy_count > 400:
		return
	var enemy = enemy_scenes.pick_random().instantiate()
	enemy.player = player
	enemies.add_child(enemy)
	var random_direction : Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if player.direction:
		random_direction += player.direction * player_direction_weight
		random_direction = random_direction.normalized()
	enemy.position = player.position + random_direction * spawn_distance
	enemy_count += 1

func on_enemy_despawned():
	enemy_count -= 1

func on_battle_started():
	for enemy in enemies.get_children():
		enemy.queue_free()
	enemy_count = 0
