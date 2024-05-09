extends Node2D

@export var enemy_scene : PackedScene
@onready var enemies = %Enemies
@onready var enemy_spawn_timer = %EnemySpawnTimer
var player
var spawn_distance = 600
var player_direction_weight = 0.8
var enemy_count : int = 0

func _ready():
	Events.enemy_despawned.connect(on_enemy_despawned)
	Events.battle_started.connect(on_battle_started)

func _on_enemy_spawn_timer_timeout():
	if enemy_count > 500:
		return
	var enemy = enemy_scene.instantiate()
	enemies.add_child(enemy)
	var random_direction : Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if player.direction:
		random_direction += player.direction * player_direction_weight
		random_direction = random_direction.normalized()
	enemy.position = player.position + random_direction * spawn_distance
	enemy.player = player
	enemy_count += 1

func on_enemy_despawned():
	enemy_count -= 1

func on_battle_started():
	for enemy in enemies.get_children():
		enemy.queue_free()
	enemy_count = 0
