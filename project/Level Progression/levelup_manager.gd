extends Node

var card_array : Array[Node]
@onready var level_up_menu = %LevelUpMenu
@onready var upgrade_cards = %UpgradeCards

func _ready():
	Events.level_gained.connect(on_level_gained)
	for card in upgrade_cards.get_children():
		card_array.append(card)

func on_level_gained():
	level_up_menu.show()
	card_array.shuffle()
	for card in card_array.slice(0, 3):
		card.show()
	get_tree().paused = true
	await Events.upgrade_picked
	get_tree().paused = false
	for card in card_array:
		card.hide()
	level_up_menu.hide()
