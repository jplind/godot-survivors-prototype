extends Node2D

var viable_enemies : Array[Enemy]
var player
var player_direction_weight = 2
var enemy_count : int = 0
var spawn_distance = 600
const SPAWN_TIME_INITIAL : float = 1
const SPAWN_TIME_SCALING : float = 0.9
@onready var spawned_enemies = %SpawnedEnemies
@onready var enemy_spawn_timer : Timer = %EnemySpawnTimer

func _ready():
	Events.enemy_despawned.connect(on_enemy_despawned)
	Events.battle_started.connect(on_battle_started)
	Events.viable_enemies_changed.connect(on_viable_enemies_changed)
	Events.clock_minutes_changed.connect(on_clock_minutes_changed)

func _on_enemy_spawn_timer_timeout():
	if player.dead:
		return
	if enemy_count > 500:
		return
	var enemy : Enemy = viable_enemies.pick_random().duplicate()
	enemy.player = player
	spawned_enemies.add_child(enemy)
	var random_direction : Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	if player.direction:
		random_direction += player.direction * player_direction_weight
		random_direction = random_direction.normalized()
	enemy.position = player.position + random_direction * spawn_distance
	enemy_count += 1

func on_viable_enemies_changed(enemies : Array[Enemy]):
	viable_enemies = enemies

func on_clock_minutes_changed(minutes : int):
	enemy_spawn_timer.wait_time *= SPAWN_TIME_SCALING

func on_enemy_despawned():
	enemy_count -= 1

func on_battle_started():
	for enemy in spawned_enemies.get_children():
		enemy.queue_free()
	enemy_count = 0
	enemy_spawn_timer.wait_time = SPAWN_TIME_INITIAL
