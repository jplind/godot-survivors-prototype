extends Node2D

@onready var restart_button = %RestartButton
@onready var player = %Player
@onready var enemy_spawner = %EnemySpawner
@onready var battle_duration_label = %BattleDurationLabel
@onready var attack_launcher = $AttackLauncher
var battle_duration : float = 0
var battle_timer_running = true

func _ready():
	Events.player_died.connect(on_player_died)
	enemy_spawner.player = player
	attack_launcher.player = player

func on_player_died():
	restart_button.show()
	battle_timer_running = false

func _process(delta):
	if battle_timer_running:
		battle_duration += delta
		battle_duration_label.text = str(int(battle_duration))

func start_battle():
	restart_button.hide()
	Events.battle_started.emit()

func _on_restart_button_pressed():
	battle_duration = 0
	battle_timer_running = true
	start_battle()
