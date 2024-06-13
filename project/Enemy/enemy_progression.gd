extends Node

@export var enemy_scenes : Array[PackedScene]
var all_enemies : Array[Enemy]
var viable_enemies : Array[Enemy]
var current_minute : int = 0

func _ready():
	Events.clock_minutes_changed.connect(on_clock_minute_changed)
	Events.battle_started.connect(on_battle_started)
	for enemy_scene in enemy_scenes:
		var enemy = enemy_scene.instantiate()
		all_enemies.append(enemy)

func on_clock_minute_changed(minutes : int):
	current_minute = minutes
	update_viable_enemies()

func on_battle_started():
	viable_enemies.clear()
	update_viable_enemies()

func update_viable_enemies():
	for enemy : Enemy in viable_enemies:
		if enemy.enemy_data.minute_removed == current_minute:
			viable_enemies.erase(enemy)
	for enemy in all_enemies:
		if enemy.enemy_data.minute_added == current_minute:
			viable_enemies.append(enemy)
	Events.viable_enemies_changed.emit(viable_enemies)
