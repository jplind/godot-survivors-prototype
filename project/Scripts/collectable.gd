extends Node2D

var pulled : bool = false
var acceleration : float = 200
var speed : float = 0
const MAX_SPEED : float = 600
var player

func _on_pickup_area_entered(area):
	Events.gem_picked.emit()
	queue_free()

func _on_pull_area_entered(area):
	pulled = true
	player = area

func _process(delta):
	if not pulled:
		return
	speed = minf(speed + acceleration * delta, MAX_SPEED)
	position += position.direction_to(player.global_position) * speed * delta
