extends Node

var experience : int
var level : int
var to_next_level : int
const START_EXPERIENCE : int = 0
const START_LEVEL : int = 1
const START_TO_NEXT_LEVEL = 100
@onready var experience_bar : ProgressBar = %ExperienceBar
@onready var level_label = %LevelLabel

func _ready():
	Events.book_picked.connect(on_book_picked)
	Events.battle_started.connect(on_battle_started)

func on_book_picked(value):
	add_experience(value)

func add_experience(value : int):
	experience += value
	if experience >= to_next_level:
		level_up()
	experience_bar.value = experience

func level_up():
	level += 1
	experience -= to_next_level
	to_next_level = level * 100
	experience_bar.max_value = to_next_level
	experience_bar.value = experience
	level_label.text = "LV: " + str(level)
	Events.level_gained.emit()

func on_battle_started():
	reset_experience()

func reset_experience():
	experience = START_EXPERIENCE
	level = START_LEVEL
	to_next_level = START_TO_NEXT_LEVEL
	experience_bar.value = experience
	experience_bar.max_value = to_next_level
	level_label.text = "LV: " + str(level)
	
