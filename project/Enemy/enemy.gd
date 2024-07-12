class_name Enemy extends CharacterBody2D

@export var enemy_data : EnemyData
var health : int
var speed : int
var player
var is_stunned : bool = false
var is_despawning : bool = false
var movement_delta
@onready var navigation_agent_2d = %NavigationAgent2D
@onready var stun_timer = %StunTimer
@onready var sprite = $Sprite2D
var is_flipped : bool = false
var is_moving : bool = false

func _ready():
	health = enemy_data.health
	speed = enemy_data.speed
	navigation_agent_2d.max_speed = speed
	sprite.material.set_shader_parameter("offset", Vector2(randf_range(-1, 1), randf_range(-1, 1)))

func _physics_process(delta):
	if is_stunned or is_despawning or is_moving:
		return
	if position.distance_to(player.position) > 1000:
		despawn()
		return
	sprite.play("move")
	navigation_agent_2d.target_position = player.position
	if navigation_agent_2d.is_navigation_finished():
		return
	movement_delta = speed * delta
	navigation_agent_2d.velocity = position.direction_to(navigation_agent_2d.get_next_path_position()) * speed
	if navigation_agent_2d.velocity.x < -2 and not is_flipped:
		scale.x *= -1
		is_flipped = true
	elif navigation_agent_2d.velocity.x > 2 and is_flipped:
		scale.x *= -1
		is_flipped = false

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if is_stunned or is_despawning or is_moving:
		return
	#position = position.move_toward(position + safe_velocity, movement_delta)
	#position = position.move_toward(position + safe_velocity, movement_delta)
	is_moving = true
	var tween : Tween = create_tween()
	tween.tween_property(self, "position", position + safe_velocity, 1)
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.play()
	await tween.finished
	if is_despawning or is_stunned:
		return
	sprite.play("idle")
	await get_tree().create_timer(0.5).timeout
	is_moving = false

func despawn():
	is_despawning = true
	remove_from_group("enemies")
	Events.enemy_despawned.emit()
	navigation_agent_2d.queue_free()
	$HitBox.queue_free()
	$HurtBox.queue_free()
	sprite.play("die")
	await sprite.animation_finished
	var tween = create_tween()
	tween.tween_property(sprite, "material:shader_parameter/dissolve_value", 0.0, 1.5)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.play()
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
	sprite.play("idle")
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
