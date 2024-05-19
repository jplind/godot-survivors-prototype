extends MoveBehavior

var curve : float = 90
var rotation_speed : float = 350

func _process(delta):
	owner.direction = owner.direction.rotated(deg_to_rad(curve * delta))
	owner.position += owner.direction * owner.speed * delta
	owner.rotation += deg_to_rad(rotation_speed) * delta
