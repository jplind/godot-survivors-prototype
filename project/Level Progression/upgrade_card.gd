extends Button

@export var upgrade_card_data : UpgradeCardData
var current_level : int = 0
@onready var texture_rect = %TextureRect
@onready var name_label = %NameLabel
@onready var value_label = %ValueLabel

func _ready():
	texture_rect.texture = upgrade_card_data.texture
	name_label.text = upgrade_card_data.name
	value_label.text = "+" + str(upgrade_card_data.values[current_level])

func _on_pressed():
	Events.upgrade_picked.emit()
