class_name Enemy extends CharacterBody2D

@export var enemy_data : EnemyData
var health : int
var speed : int
var player
var is_stunned : bool = false
var is_despawning : bool = false
var movement_delta
var despawn_shader : Shader = preload("res://Enemy/eneym_despawn.gdshader")
@onready var navigation_agent_2d = %NavigationAgent2D
@onready var stun_timer = %StunTimer
@onready var sprite = $Sprite2D

func _ready():
	health = enemy_data.health
	speed = enemy_data.speed
	navigation_agent_2d.max_speed = speed

func _physics_process(delta):
	if is_stunned or is_despawning:
		return
	if position.distance_to(player.position) > 1000:
		despawn()
	navigation_agent_2d.target_position = player.position
	if navigation_agent_2d.is_navigation_finished():
		return
	movement_delta = speed * delta
	navigation_agent_2d.velocity = position.direction_to(navigation_agent_2d.get_next_path_position()) * speed
	if navigation_agent_2d.velocity.x < -2:
		sprite.flip_h = false
	elif navigation_agent_2d.velocity.x > 2:
		sprite.flip_h = true

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if is_stunned or is_despawning:
		return
	position = position.move_toward(position + safe_velocity, movement_delta)

func despawn():
	is_despawning = true
	Events.enemy_despawned.emit()
	var tween = create_tween()
	tween.tween_property(sprite, "material:shader_parameter/dissolve_value", 0.0, 0.8)
	tween.set_trans(Tween.TRANS_SINE)
	tween.play()
	navigation_agent_2d.queue_free()
	$HitBox.queue_free()
	$HurtBox.queue_free()
	await tween.finished
	queue_free()

func _on_hurt_box_area_entered(area):
	var damage : int = int(randfn(area.owner.damage, area.owner.damage * 0.08))
	health -= damage
	Events.enemy_damaged.emit(damage, position)
	if health <= 0:
		Events.enemy_died.emit(self)
		despawn()
		return
	is_stunned = true
	stun_timer.start()
	hit_flash_effect()
	apply_knockback()

func _on_stun_timer_timeout():
	is_stunned = false

func hit_flash_effect():
	sprite.material.set_shader_parameter("flash_opacity", 1.0)
	var tween = create_tween()
	tween.tween_property(sprite, "material:shader_parameter/flash_opacity", 0, 0.5)
	tween.set_trans(Tween.TRANS_SINE)
	tween.play()

func apply_knockback():
	var direction = -position.direction_to(player.position)
	var tween = create_tween()
	tween.tween_property(self, "position", position + direction * 35, 0.15)
	tween.play()
