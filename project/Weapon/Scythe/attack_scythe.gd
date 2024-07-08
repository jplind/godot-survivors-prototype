extends Attack

signal scythe_returned
var player : Node2D
var base_rotation_speed : float = -350
var rotation_speed : float

@onready var initial_velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * 800
var velocity : Vector2

var angular_velocity : float = -180
var angular_acceleration : float = 90

var grace_count : int = -1
var acceleration : float = 600
var is_returning : bool = false

func _ready():
	super()
	speed = 0
	velocity = initial_velocity

func move(delta):
	if is_returning:
		speed += acceleration * delta
		position += global_position.direction_to(player.global_position) * delta * speed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, delta * acceleration)
		if velocity.is_zero_approx():
			is_returning = true
		#angular_velocity = min(angular_velocity + angular_acceleration * delta, 0)
		#velocity = velocity.rotated(deg_to_rad(angular_velocity * delta))
		position += velocity * delta
	rotation_speed = -velocity.length() * 1.6 - speed * 1.6 + base_rotation_speed
	rotation += deg_to_rad(rotation_speed) * delta

func _on_player_detection_area_entered(area):
	grace_count += 1
	if grace_count > 0:
		scythe_returned.emit()
		queue_free()
