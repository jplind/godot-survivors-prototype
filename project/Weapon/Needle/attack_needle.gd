extends Attack

func move(delta):
	position += direction * speed * delta
