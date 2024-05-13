extends Node

var experience : int = 0
var level : int = 1
var experience_to_next_level : int = 200

@onready var experience_bar = %ExperienceBar
@onready var level_label = %LevelLabel

func _ready():
	Events.gem_picked.connect(on_gem_picked)
	Events.battle_started.connect(on_battle_started)

func on_gem_picked():
	add_experience(10)

func add_experience(value : int):
	experience += value
	if experience >= experience_to_next_level:
		level_up()
	experience_bar.value = experience

func level_up():
	level += 1
	experience -= experience_to_next_level
	level_label.text = "LV: " + str(level)
	Events.level_gained.emit()

func on_battle_started():
	reset_experience()

func reset_experience():
	experience = 0
	level = 1
	experience_bar.value = experience
	level_label.text = "LV: " + str(level)
	
