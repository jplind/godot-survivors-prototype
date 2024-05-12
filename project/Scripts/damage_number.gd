extends Node2D

@onready var animation_player = %AnimationPlayer
@onready var label = %Label

func _ready():
	label.pivot_offset = label.size * 0.5
	animation_player.play("damage_number_animation")
	await animation_player.animation_finished
	queue_free()

func set_damage_number(number : int):
	label.text = str(number)
