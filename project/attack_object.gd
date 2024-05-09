extends Node2D

var speed : float = 600
var direction : Vector2 = Vector2.UP

func _ready():
	direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	rotation = get_angle_to(direction) + PI * 0.5

func _process(delta):
	position += direction * speed * delta

func _on_lifetime_timer_timeout():
	queue_free()
