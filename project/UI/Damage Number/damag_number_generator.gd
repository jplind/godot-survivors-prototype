extends Node2D

@export var damage_number_scene : PackedScene
var offset_randomness : float = 20

func _ready():
	Events.enemy_damaged.connect(on_enemy_damaged)

func on_enemy_damaged(damage_number : int, enemy_position : Vector2):
	generate_damage_number(damage_number, enemy_position)

func generate_damage_number(damage : int, enemy_position : Vector2):
	var damage_number = damage_number_scene.instantiate()
	add_child(damage_number)
	damage_number.set_damage_number(damage)
	damage_number.position = enemy_position + random_offset()

func random_offset():
	var offset = Vector2(randf_range(-offset_randomness, offset_randomness),
			randf_range(-offset_randomness, offset_randomness))
	return offset

