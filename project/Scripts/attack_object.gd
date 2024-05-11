extends Node2D

var damage: int = 500
var speed : float = 600
var direction : Vector2

func _ready():
	#direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
	direction = (get_global_mouse_position() - position).normalized()
	rotation = direction.angle() + PI * 0.5

func _process(delta):
	position += direction * speed * delta

func _on_lifetime_timer_timeout():
	queue_free()
