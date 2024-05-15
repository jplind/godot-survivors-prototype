extends Node2D

var damage = 200
var speed : float = 3
const MIN_SPEED : float = 1
const MAX_SPEED : float = 5
var radius : float = 110
var acceleration : float = 0.5
var acceleration_wait_time_range : Vector2 = Vector2(2, 6)
@onready var acceleration_timer = %AccelerationTimer
@onready var moving_orb = $MovingOrb
@onready var hit_box = %HitBox

func _ready():
	Events.player_died.connect(on_player_died)
	Events.battle_started.connect(on_battle_started)
	moving_orb.top_level = true
	randomize_acceleration_wait_time()
	acceleration_timer.start()
	hit_box.owner = self

func _process(delta):
	if not visible:
		return
	speed = clampf(speed + acceleration * delta, MIN_SPEED, MAX_SPEED)
	rotation += speed * delta
	moving_orb.position = global_position + Vector2.UP.rotated(rotation) * radius

func randomize_acceleration_wait_time():
	acceleration_timer.wait_time = randf_range(acceleration_wait_time_range.x, acceleration_wait_time_range.y)

func _on_acceleration_timer_timeout():
	acceleration = -acceleration

func on_player_died():
	hide()
	hit_box.process_mode = PROCESS_MODE_DISABLED

func on_battle_started():
	show()
	hit_box.process_mode = PROCESS_MODE_INHERIT
