extends Enemy

class_name Snek

var is_alive := true

func spawn(at_position: Vector2):
	process_mode = Node.PROCESS_MODE_INHERIT
	is_alive = true
	position = at_position
	show()


func _physics_process(delta):
	if not is_alive:
		return
		
	velocity = (globals.player.position - position).normalized() * 20.0
	look_at(globals.player.position)
	move_and_slide()


func hit():
	is_alive = false
	rotation = 0
	$AnimatedSprite2D.rotation = 0
	$AnimatedSprite2D.play("cry")
	await $AnimatedSprite2D.animation_finished
	process_mode = Node.PROCESS_MODE_DISABLED
	hide()
