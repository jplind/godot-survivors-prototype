class_name Collectable
extends Node2D

@export var collectable_data : CollectableData
var pulled : bool = false
var acceleration : float = 250
var speed : float = 0
const MAX_SPEED : float = 700
var player
var value : int
var type
@onready var sprite = %Sprite2D
@onready var pickup = %Pickup

func _ready():
	pickup.owner = self
	type = collectable_data.type
	var rarity = collectable_data.weights.pick_random()
	value = collectable_data.values[rarity]
	sprite.texture = collectable_data.textures[rarity]

func _on_pickup_area_entered(area):
	match type:
		"book":
			Events.book_picked.emit(value)
		"fruit":
			Events.fruit_picked.emit(value)
	queue_free()

func _process(delta):
	if not pulled:
		return
	speed = minf(speed + acceleration * delta, MAX_SPEED)
	position += position.direction_to(player.global_position) * speed * delta
