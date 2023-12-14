extends Enemy


func _physics_process(delta):
	pass


func hit():
	$AnimatedSprite2D.animation = "dead"
