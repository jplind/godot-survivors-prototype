extends Node2D

@export var collectable_scenes : Array[PackedScene]
@onready var spawned_collectables = %SpawnedCollectables

func _ready():
	Events.enemy_died.connect(on_enemy_died)
	Events.battle_started.connect(on_battle_started)

func on_enemy_died(enemy : Enemy):
	var collectable = collectable_scenes.pick_random().instantiate()
	spawned_collectables.call_deferred("add_child", collectable)
	collectable.position = enemy.position

func on_battle_started():
	for collectable in spawned_collectables.get_children():
		collectable.queue_free()