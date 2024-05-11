extends Node2D

@export var attack_object_scene : PackedScene
@onready var launched_objects = %LaunchedObjects
@onready var launch_timer = $LaunchTimer
var player

func _ready():
	Events.player_died.connect(on_player_died)
	Events.battle_started.connect(on_battle_started)

func launch_attack_object():
	var attack_object = attack_object_scene.instantiate()
	attack_object.position = player.position
	launched_objects.add_child(attack_object)

func _on_launch_timer_timeout():
	launch_attack_object()

func on_player_died():
	launch_timer.stop()

func on_battle_started():
	launch_timer.start()
