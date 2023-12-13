extends CharacterBody2D

class_name Player

signal dead
signal interact

const speed := 200.0

var entropy := 0.0
var can_interact := false

var text_box: TextBox

# TODO interact
# TODO attack
# TODO health


func _physics_process(delta):
	velocity = Vector2.ZERO
	var direction = Input.get_vector("game_left", "game_right", "game_up", "game_down")
	
	if direction:
		velocity = direction * speed
		$AnimatedSprite2D.animation = "running"
		$AnimatedSprite2D.rotation = direction.angle() + 0.5 * PI
	else:
		$AnimatedSprite2D.animation = "idle"

	move_and_slide()

func _input(event):
	if can_interact and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			interact.emit()

func hit(add_entropy: int):
	entropy += add_entropy
	if entropy >= 100:
		dead.emit()

func start_interaction(text_node: String):
	$Prompt.show()
	text_box.queued_node = text_node
	can_interact = true

func end_interaction():
	$Prompt.hide()
	can_interact = false

func can_transverse(solidity: int) -> bool:
	# TODO
	return true
