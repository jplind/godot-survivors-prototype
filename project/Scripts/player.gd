extends Node2D

@onready var hurt_box = %HurtBox
@onready var health_bar = %HealthBar
@onready var hit_timer = %HitTimer
@onready var sprite = %Sprite2D
var speed : float = 150
var direction : Vector2 = Vector2.ZERO
const HEALTH_MAX : int = 200
var health : int
var dead = false

func _ready():
	Events.battle_started.connect(on_battle_started)
	Events.fruit_picked.connect(on_fruit_picked)
	health = HEALTH_MAX
	health_bar.max_value = HEALTH_MAX
	update_health_bar()

func get_input():
	direction = Input.get_vector("left", "right", "up", "down")
	if direction.x < 0:
		sprite.flip_h = false
	elif direction.x > 0:
		sprite.flip_h = true

func _process(delta):
	if dead:
		return
	get_input()
	position += direction * speed * delta
	if hit_timer.is_stopped():
		if hurt_box.has_overlapping_areas():
			take_damage()

func take_damage():
	for enemy in hurt_box.get_overlapping_areas():
		health = max(health - 10, 0)
		update_health_bar()
		if health <= 0:
			die()
	hit_timer.start()

func update_health_bar():
	health_bar.value = health

func die():
	dead = true
	direction = Vector2.ZERO
	Events.player_died.emit()
	self.modulate = Color.DARK_GRAY

func on_battle_started():
	hit_timer.start()
	health = HEALTH_MAX
	update_health_bar()
	dead = false
	self.modulate = Color.WHITE

func on_fruit_picked(value):
	if dead:
		return
	health = min(health + value, HEALTH_MAX)
	update_health_bar()

func _on_collectable_pull_area_entered(area):
	if dead:
		return
	area.owner.pulled = true
	area.owner.player = self
