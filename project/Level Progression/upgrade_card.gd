extends Button

@export var attribute : WeaponAttribute

@onready var texture_rect = %TextureRect
@onready var name_label = %NameLabel
@onready var value_label = %ValueLabel

func _ready():
	Events.battle_started.connect(on_battle_started)
	texture_rect.texture = attribute.texture
	name_label.text = attribute.name
	update_label()

func _on_pressed():
	Events.upgrade_picked.emit()
	attribute.level += 1
	attribute.value = attribute.level_values[attribute.level]
	update_label()

func update_label():
	var level = attribute.level
	value_label.text = "+" + str(attribute.level_values[attribute.level + 1] - attribute.level_values[level])

func on_battle_started():
	attribute.level = 0
	attribute.value = attribute.level_values[attribute.level]
	update_label()
