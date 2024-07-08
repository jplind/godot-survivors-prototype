class_name Attack
extends Node2D

@export var weapon_data : WeaponData

var damage : int
var speed : int
var lifetime : float
var direction : Vector2
var particles : GPUParticles2D
var is_despawning : bool = false
@onready var hit_box = %HitBox
@onready var lifetime_timer = %LifetimeTimer

func _ready():
	hit_box.owner = self
	rotation = direction.angle() + PI * 0.5
	damage = weapon_data.damage.value
	speed = weapon_data.attack_speed
	if weapon_data.size:
		scale *= weapon_data.size.value
	lifetime = weapon_data.attack_lifetime
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()

func _process(delta):
	move(delta)

func move(delta):
	pass

func _on_lifetime_timer_timeout():
	despawn()

func _on_hit_box_area_entered(area):
	if weapon_data.is_piercing:
		return
	queue_free()

func despawn():
	if is_despawning:
		return
	is_despawning = true
	speed = 0
	$Sprite2D.queue_free()
	hit_box.queue_free()
	if particles:
		particles.emitting = false
		await particles.finished
		queue_free()
