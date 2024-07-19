extends Node2D

var is_flipped : bool = false
var speed : float = 170
var direction : Vector2 = Vector2.ZERO
const HEALTH_MAX : int = 200
var health : int
var dead = false

@onready var hurt_box = %HurtBox
@onready var health_bar = %HealthBar
@onready var hit_timer = %HitTimer
@onready var sprite : AnimatedSprite2D = %AnimatedSprite2D

func _ready():
	Events.battle_started.connect(on_battle_started)
	Events.fruit_picked.connect(on_fruit_picked)
	health = HEALTH_MAX
	health_bar.max_value = HEALTH_MAX
	update_health_bar()

func get_input():
	direction = Input.get_vector("left", "right", "up", "down")
	if direction.x < 0 and not is_flipped:
		sprite.scale.x *= -1
		is_flipped = true
	elif direction.x > 0 and is_flipped:
		sprite.scale.x *= -1
		is_flipped = false

func _process(delta):
	if dead:
		return
	get_input()
	if direction:
		position += direction * speed * delta
		sprite.play("move")
	else:
		sprite.play("idle")
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
	health_bar.hide()
	direction = Vector2.ZERO
	Events.player_died.emit()
	sprite.play("die")

func on_battle_started():
	hit_timer.start()
	health = HEALTH_MAX
	update_health_bar()
	health_bar.show()
	dead = false

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
