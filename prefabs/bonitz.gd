extends Enemy

class_name Bonitz


func hit():
	$AnimatedSprite2D.animation = "dead"
	harmless = true
