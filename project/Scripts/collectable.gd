extends Node2D

func _on_area_2d_area_entered(area):
	Events.gem_picked.emit()
	queue_free()
