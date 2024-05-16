class_name Attack
extends Node2D

var damage: int = 500
var speed : float = 600
var direction : Vector2
@onready var hit_box = %HitBox

func _ready():
	hit_box.owner = self
	direction = position.direction_to(get_global_mouse_position())
	rotation = direction.angle() + PI * 0.5

func _process(delta):
	position += direction * speed * delta

func _on_lifetime_timer_timeout():
	queue_free()
