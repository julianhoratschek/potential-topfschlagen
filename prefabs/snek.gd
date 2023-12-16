extends Enemy

class_name Snek

const Speed := 20.0

var is_alive := true

func _physics_process(delta: float):
	if not is_alive:
		return
		
	velocity = (globals.player.position - position).normalized() * Speed
	look_at(globals.player.position)
	move_and_slide()


func spawn(at_position: Vector2):
	process_mode = Node.PROCESS_MODE_INHERIT
	is_alive = true
	harmless = false
	$AnimatedSprite2D.rotation = PI
	$AnimatedSprite2D.play(&"slither")
	position = at_position
	show()


func hit():
	is_alive = false
	harmless = true
	rotation = 0
	$AnimatedSprite2D.rotation = 0
	$AnimatedSprite2D.play(&"cry")
	await $AnimatedSprite2D.animation_finished
	process_mode = Node.PROCESS_MODE_DISABLED
	hide()
