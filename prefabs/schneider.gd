extends Area2D

var state := &"unhappy"


func set_happy():
	state = &"happy"
	$Schneider/AnimatedSprite2D.animation = &"happy"
