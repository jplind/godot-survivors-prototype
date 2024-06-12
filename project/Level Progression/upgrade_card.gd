class_name UpgradeCard
extends Button

@export var attribute : Attribute
var upgrade_value

@onready var texture_rect = %TextureRect
@onready var name_label = %NameLabel
@onready var value_label = %ValueLabel

func _ready():
	Events.battle_started.connect(on_battle_started)
	Events.upgrade_picked.connect(on_upgrade_picked)
	texture_rect.texture = attribute.texture
	name_label.text = attribute.name
	attribute.value = attribute.value_initial

func _on_pressed():
	attribute.value += upgrade_value
	Events.upgrade_picked.emit()

func update_upgrade_value():
	var value_min : float = attribute.value_scaling * 0.5
	var value_max : float = attribute.value_scaling * 1.5
	var mean : float = (value_max + value_min) * 0.5
	var deviation : float = mean * 0.2
	var upgrade_value_unclamped : float = randfn(mean, deviation)
	if attribute.value is int:
		upgrade_value_unclamped = max(int(round(upgrade_value_unclamped)), 1)
	upgrade_value = clampf(upgrade_value_unclamped, value_min, value_max)

func update_label():
	if attribute.value is float:
		value_label.text = "%.2f > %.2f" % [attribute.value, attribute.value + upgrade_value]
	else:
		value_label.text = "%d > %d" % [attribute.value, attribute.value + upgrade_value]

func on_battle_started():
	attribute.value = attribute.value_initial
	update_upgrade_value()
	update_label()

func on_upgrade_picked():
	update_upgrade_value()
	update_label()
