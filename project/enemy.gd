class_name Enemy extends CharacterBody2D

@onready var navigation_agent_2d = %NavigationAgent2D
var speed = 50
var steering_weight : float = 0.8
var player
var march_velocity
var movement_delta

func _physics_process(delta):
	if position.distance_to(player.position) > 1000:
		queue_free()
	navigation_agent_2d.target_position = player.position
	movement_delta = speed * delta
	if navigation_agent_2d.is_navigation_finished():
		return
	position = position.move_toward(navigation_agent_2d.get_next_path_position(), movement_delta)

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
	position = position.move_toward(position + safe_velocity, movement_delta)

func despawn():
	Events.enemy_despawned.emit()
	queue_free()
