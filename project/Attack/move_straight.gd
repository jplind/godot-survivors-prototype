extends MoveBehavior

func _process(delta):
	owner.position += owner.direction * owner.speed * delta
