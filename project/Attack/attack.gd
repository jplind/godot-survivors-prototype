class_name Attack
extends Node2D

var damage : Vector2
var speed : int
var lifetime : float
var pierce : int
var pierce_count : int = 0
var targeting_behavior
var direction : Vector2
@onready var hit_box = %HitBox
@onready var lifetime_timer = %LifetimeTimer
@onready var move_behavior = %MoveBehavior

func _ready():
	hit_box.owner = self
	lifetime_timer.wait_time = lifetime
	lifetime_timer.start()
	rotation = direction.angle() + PI * 0.5
	move_behavior.owner = self

func _on_lifetime_timer_timeout():
	queue_free()

func _on_hit_box_area_entered(area):
	if pierce:
		pierce_count += 1
		if pierce_count < pierce:
			return
	queue_free()
