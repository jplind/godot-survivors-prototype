extends CharacterBody2D

@onready var hit_box = %HitBox
@onready var health_bar = %HealthBar
@onready var hit_timer = %HitTimer
var speed : float = 160
var direction : Vector2 = Vector2.ZERO
var health : int = 100
var dead = false

func _ready():
	Events.battle_started.connect(on_battle_started)

func get_input():
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed

func _physics_process(delta):
	if dead:
		return
	get_input()
	move_and_slide()
	if hit_timer.is_stopped():
		if hit_box.has_overlapping_areas():
			take_damage()

func take_damage():
	for enemy in hit_box.get_overlapping_areas():
		health = max(health - 10, 0)
		update_health_bar(health)
		if health <= 0:
			die()
	hit_timer.start()

func update_health_bar(value):
	health_bar.value = value
	print(str(health) + " " + str(health_bar.value) + " " + str(health_bar.max_value))

func die():
	dead = true
	Events.player_died.emit()
	self.modulate = Color.GRAY

func on_battle_started():
	hit_timer.start()
	health = 100
	update_health_bar(health)
	dead = false
	self.modulate = Color.WHITE
