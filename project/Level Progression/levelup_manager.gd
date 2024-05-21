extends Node

@onready var level_up_menu = %LevelUpMenu

func _ready():
	Events.level_gained.connect(on_level_gained)

func on_level_gained():
	level_up_menu.show()
	get_tree().paused = true
	await Events.upgrade_picked
	level_up_menu.hide()
	get_tree().paused = false
