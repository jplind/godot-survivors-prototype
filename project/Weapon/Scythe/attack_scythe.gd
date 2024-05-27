extends Attack

var curve : float = -90
var rotation_speed : float = -350

func move(delta):
	direction = direction.rotated(deg_to_rad(curve * delta))
	position += direction * speed * delta
	rotation += deg_to_rad(rotation_speed) * delta
