extends Node

var experience : int
var level : int
var experience_required : int
const EXPERIENCE_INITIAL : int = 0
const LEVEL_INITIAL : int = 1
const EXPERIENCE_REQUIRED_INITIAL = 100
@onready var experience_bar : ProgressBar = %ExperienceBar
@onready var level_label = %LevelLabel

func _ready():
	Events.book_picked.connect(on_book_picked)
	Events.battle_started.connect(on_battle_started)

func on_book_picked(value):
	add_experience(value)

func add_experience(value : int):
	experience += value
	if experience >= experience_required:
		level_up()
	experience_bar.value = experience

func level_up():
	level += 1
	experience -= experience_required
	experience_required = level * 50
	experience_bar.max_value = experience_required
	experience_bar.value = experience
	level_label.text = "LV: " + str(level)
	Events.level_gained.emit()

func on_battle_started():
	reset_experience()

func reset_experience():
	experience = EXPERIENCE_INITIAL
	level = LEVEL_INITIAL
	experience_required = EXPERIENCE_REQUIRED_INITIAL
	experience_bar.value = experience
	experience_bar.max_value = experience_required
	level_label.text = "LV: " + str(level)
	
