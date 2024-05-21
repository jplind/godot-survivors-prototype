extends Button



func _on_pressed():
	Events.level_up_picked.emit()
