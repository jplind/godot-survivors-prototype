extends Node2D

@onready var restart_button = %RestartButton
@onready var player = %Player
@onready var enemy_spawner = %EnemySpawner

func _ready():
	Events.player_died.connect(on_player_died)
	enemy_spawner.player = player

func on_player_died():
	restart_button.show()

func start_battle():
	restart_button.hide()
	Events.battle_started.emit()

func _on_restart_button_pressed():
	start_battle()
