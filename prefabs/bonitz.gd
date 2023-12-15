extends Enemy


func hit():
	$AnimatedSprite2D.animation = "dead"
	harmless = true
