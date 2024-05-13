class_name Enemy extends CharacterBody2D

@export var enemy_data : EnemyData
var health : int
var speed : int
var player
var stunned : bool = false
var movement_delta
@onready var navigation_agent_2d = %NavigationAgent2D
@onready var stun_timer = %StunTimer

func _ready():
	health = enemy_data.health
	speed = enemy_data.speed
	navigation_agent_2d.max_speed = speed

func _physics_process(delta):
	if position.distance_to(player.position) > 1000:
		despawn()
	if stunned:
		return
	navigation_agent_2d.target_position = player.position
	if navigation_agent_2d.is_navigation_finished():
		return
	movement_delta = speed * delta
	navigation_agent_2d.velocity = position.direction_to(navigation_agent_2d.get_next_path_position()) * speed
	if navigation_agent_2d.velocity.x < -2:
		$Sprite2D.flip_h = false
	elif navigation_agent_2d.velocity.x > 2:
		$Sprite2D.flip_h = true

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if stunned:
		return
	position = position.move_toward(position + safe_velocity, movement_delta)

func despawn():
	Events.enemy_despawned.emit()
	queue_free()

func _on_hurt_box_area_entered(area):
	var damage = area.owner.damage
	health -= damage
	Events.enemy_damaged.emit(damage, position)
	if health <= 0:
		Events.enemy_died.emit(self)
		despawn()
	stunned = true
	stun_timer.start()

func _on_stun_timer_timeout():
	stunned = false
