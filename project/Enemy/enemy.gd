class_name Enemy extends CharacterBody2D

@export var enemy_data : EnemyData
var health : int
@export var speed : int
var player
var game_over : bool = false
var is_stunned : bool = false
var is_despawning : bool = false
var movement_delta
var attack_direction : Vector2 = Vector2.ZERO
var animation_player : AnimationPlayer
@onready var navigation_agent_2d = %NavigationAgent2D
@onready var stun_timer = %StunTimer
@onready var sprite = $Sprite2D
@onready var state_chart = %StateChart

var is_flipped : bool = false
var using_avoidance : bool = false
var movement_tween : Tween = null
var direction : Vector2

func _ready():
	health = enemy_data.health
	Events.player_died.connect(on_player_died)
	sprite.material.set_shader_parameter("offset", Vector2(randf_range(-1, 1), randf_range(-1, 1)))
	animation_player = %AnimationPlayer
	animation_player.animation_finished.connect(on_animation_finished)

func on_player_died():
	game_over = true
	if is_instance_valid(navigation_agent_2d):
		navigation_agent_2d.target_position = Vector2(randf_range(-10000, 10000), randf_range(-10000, 10000))



func _on_hurt_box_area_entered(area):
	var damage : int = int(randfn(area.owner.damage, area.owner.damage * 0.08))
	health -= damage
	Events.enemy_damaged.emit(damage, global_position)
	state_chart.send_event("hit")

#region Idle State
func _on_idle_state_entered():
	animation_player.play("idle")
#endregion

#region Move State
func _on_move_state_entered():
	using_avoidance = true
	if game_over:
		navigation_agent_2d.target_position = Vector2(randf_range(-10000, 10000), randf_range(-10000, 10000))
	move()

func _on_move_state_exited():
	using_avoidance = false

func move():
	if not game_over:
		navigation_agent_2d.target_position = player.global_position
	if navigation_agent_2d.is_navigation_finished():
		state_chart.send_event("attack")
		return
	direction = global_position.direction_to(navigation_agent_2d.get_next_path_position())
	animation_player.play("move")

func _on_move_state_physics_processing(delta):
	#if not game_over:
		#navigation_agent_2d.target_position = player.global_position
	#if navigation_agent_2d.is_navigation_finished():
		#return
	movement_delta = delta
	navigation_agent_2d.max_speed = speed
	navigation_agent_2d.velocity = direction * speed

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if not using_avoidance:
		return
	if safe_velocity.x < -2 and not is_flipped:
		scale.x *= -1
		is_flipped = true
	elif safe_velocity.x > 2 and is_flipped:
		scale.x *= -1
		is_flipped = false
	global_position += safe_velocity * movement_delta
	#global_position = global_position.move_toward(global_position + safe_velocity, movement_delta)
#endregion

#region Hit State
func _on_hit_state_entered():
	if health > 0:
		state_chart.send_event("stunned")
	else:
		state_chart.send_event("die")
#endregion

#region Stunned State
func _on_stunned_state_entered():
	sprite.play("idle")
	hit_flash_effect()
	apply_knockback()
	stun_timer.start()

func _on_stun_timer_timeout():
	state_chart.send_event("stun_finished")

func hit_flash_effect():
	sprite.material.set_shader_parameter("flash_opacity", 1.0)
	var hit_tween = create_tween()
	hit_tween.tween_property(sprite, "material:shader_parameter/flash_opacity", 0, 0.4)
	hit_tween.set_trans(Tween.TRANS_SINE)
	hit_tween.play()

func apply_knockback():
	var knockback_direction = -global_position.direction_to(player.global_position)
	movement_tween = create_tween()
	movement_tween.tween_property(self, "position", position + knockback_direction * 35, 0.15)
	movement_tween.play()
#endregion

#region Death State
func _on_death_state_entered():
	animation_player.play("death")
	#Events.enemy_died.emit(self)
	remove_from_group("enemies")
	navigation_agent_2d.queue_free()
	$HitBox.queue_free()
	$HurtBox.queue_free()

func despawn():
	var tween = create_tween()
	tween.tween_property(sprite, "material:shader_parameter/dissolve_value", 0.0, 1.5)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.play()
	await tween.finished
	Events.enemy_despawned.emit()
	queue_free()
#endregion

#region Attack State
func _on_attack_state_entered():
	animation_player.play("attack")
	attack_direction = global_position.direction_to(player.global_position)
	if attack_direction.x < 0 and not is_flipped:
		scale.x *= -1
		is_flipped = true
	elif attack_direction.x > 0 and is_flipped:
		scale.x *= -1
		is_flipped = false

func _on_attack_state_processing(delta):
	position += attack_direction * speed * delta
#endregion

func on_animation_finished(anim_name : String):
	match anim_name:
		"idle":
			if randf() < enemy_data.idle_repeat_chance:
				animation_player.play("idle")
				return
			if not game_over:
				if global_position.distance_to(player.global_position) < enemy_data.attack_range:
					state_chart.send_event("attack")
					return
			state_chart.send_event("move")
		"move":
			if randf() < enemy_data.idle_after_move_chance:
				state_chart.send_event("idle")
				return
			if not game_over:
				if global_position.distance_to(player.global_position) < enemy_data.attack_range:
					state_chart.send_event("attack")
					return
			move()
		"attack":
			state_chart.send_event("idle")
		"death":
			despawn()
