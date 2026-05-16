extends AnimatedSprite2D

func _physics_process(delta: float) -> void:
	self.global_position.x+=1.5
	if self.global_position.x>1200:
		self.global_position.x = -150
