class_name Enemy extends CharacterBody2D

@export var enemy_data : EnemyData
var health : int
var speed : int
var steering_weight : float = 0.8
var player
#var movement_delta
@onready var navigation_agent_2d = %NavigationAgent2D

func _ready():
	health = enemy_data.health
	speed = enemy_data.speed

func _physics_process(delta):
	if position.distance_to(player.position) > 1000:
		despawn()
	navigation_agent_2d.target_position = player.position
	#movement_delta = speed * delta
	if navigation_agent_2d.is_navigation_finished():
		return
	#position = position.move_toward(navigation_agent_2d.get_next_path_position(), movement_delta)
	velocity = position.direction_to(navigation_agent_2d.get_next_path_position()) * speed
	move_and_slide()
	if velocity.x <= 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	#position = position.move_toward(position + safe_velocity, movement_delta)
	velocity = safe_velocity
	move_and_slide()

func despawn():
	Events.enemy_despawned.emit()
	queue_free()

func _on_hurt_box_area_entered(area):
	health -= 500
	Events.enemy_damaged.emit(500, position)
	if health <= 0:
		Events.enemy_died.emit(self)
		despawn()
