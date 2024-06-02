extends Node2D

@onready var gameover_menu = %GameoverMenu
@onready var player = %Player
@onready var enemy_spawner = %EnemySpawner

func _ready():
	Events.player_died.connect(on_player_died)
	enemy_spawner.player = player
	Events.battle_started.emit()

func on_player_died():
	gameover_menu.show()

func start_battle():
	Events.battle_started.emit()
	gameover_menu.hide()

func _on_restart_button_pressed():
	start_battle()
