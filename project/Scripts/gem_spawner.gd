extends Node2D

@export var collectable_scene : PackedScene
@onready var spawned_gems = %SpawnedGems

func _ready():
	Events.enemy_died.connect(on_enemy_died)
	Events.battle_started.connect(on_battle_started)

func on_enemy_died(enemy : Enemy):
	var gem = collectable_scene.instantiate()
	spawned_gems.call_deferred("add_child", gem)
	gem.position = enemy.position

func on_battle_started():
	for gem in spawned_gems.get_children():
		gem.queue_free()
