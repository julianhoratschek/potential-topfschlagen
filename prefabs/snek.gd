extends CharacterBody2D

class_name Snek

var is_alive := true

func spawn(at_position: Vector2):
	# process_mode = Node.PROCESS_MODE_INHERIT
	is_alive = true
	position = at_position
	show()


func _physics_process(delta):
	velocity = (globals.player.position - position).normalized() * 20.0
	move_and_slide()
