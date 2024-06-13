extends Node

var viable_upgrades : Array[Node]
@onready var level_up_menu = %LevelUpMenu
@onready var upgrade_cards = %UpgradeCards

func _ready():
	Events.level_gained.connect(on_level_gained)
	Events.battle_started.connect(on_battle_started)

func on_level_gained():
	level_up_menu.show()
	viable_upgrades.shuffle()
	for card in viable_upgrades.slice(0, 3):
		card.show()
	get_tree().paused = true
	await Events.upgrade_picked
	get_tree().paused = false
	for card in viable_upgrades:
		card.hide()
	level_up_menu.hide()

func on_battle_started():
	reset_viable_upgrades()

func reset_viable_upgrades():
	viable_upgrades.clear()
	for card in upgrade_cards.get_children():
		viable_upgrades.append(card)
